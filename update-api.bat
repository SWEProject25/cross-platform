@echo off
setlocal

rem ===== CONFIG =====
set "SWAGGER_URL=http://backend-code.duckdns.org/dev/swagger.json"
set "DOWNLOAD=swagger.json"
set "FIXED=swagger_fixed.json"
set "OUT_DIR=Lam7aApi"

rem ===== Download =====
echo [✓] Downloading OpenAPI JSON from %SWAGGER_URL%
curl -s -L "%SWAGGER_URL%" -o "%DOWNLOAD%"
if %errorlevel% neq 0 (
    echo [✗] curl failed
    exit /b 1
)
if not exist "%DOWNLOAD%" (
    echo [✗] Download missing
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "fix-opids.ps1" -InputFile "%DOWNLOAD%" -OutputFile "%FIXED%"

rem ===== Prepare generator input =====
rem Remove previous output to avoid conflicts
if exist "%OUT_DIR%" (
    echo [!] Removing existing %OUT_DIR% ...
    rmdir /S /Q "%OUT_DIR%"
)

rem Ensure openapi-generator-cli exists (install if needed)
where openapi-generator-cli >nul 2>nul
if %errorlevel% neq 0 (
    echo [ ] openapi-generator-cli not found. Installing...
    call npm install -g @openapitools/openapi-generator-cli
    if %errorlevel% neq 0 (
        echo [✗] Failed to install openapi-generator-cli
        exit /b 1
    )
    echo [✓] openapi-generator-cli installed
)

rem ===== Generate =====
echo [✓] Generating %OUT_DIR% from %FIXED%
call openapi-generator-cli generate -i "%FIXED%" -g dart-dio -o "%OUT_DIR%"
if %errorlevel% neq 0 (
    echo [✗] openapi-generator-cli generate failed
    exit /b 1
)
echo [✓] Generation complete

rem ===== Cleanup generator extras =====
if exist "%OUT_DIR%\test" rmdir /S /Q "%OUT_DIR%\test"
if exist "%OUT_DIR%\doc" rmdir /S /Q "%OUT_DIR%\doc"
rm "%DOWNLOAD%"
rm "%FIXED%"

rem ===== Flutter steps =====
cd "%OUT_DIR%" || (echo [✗] %OUT_DIR% folder missing & exit /b 1)

echo [✓] Getting dependencies
call flutter pub get
if %errorlevel% neq 0 (
    echo [✗] flutter pub get failed
    exit /b 1
)

echo [✓] Running build_runner
call flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [✗] build_runner failed
    exit /b 1
)



echo.
echo All steps completed successfully.
exit /b 0
