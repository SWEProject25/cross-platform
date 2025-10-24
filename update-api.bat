@echo off
setlocal

:: Step 1 - Check if openapi-generator-cli is installed
set "CLI_INSTALLED=0"
where openapi-generator-cli >nul 2>nul && set "CLI_INSTALLED=1"
if "%CLI_INSTALLED%"=="1" (
    echo [✓] Check if openapi-generator-cli is installed
) else (
    echo [ ] Check if openapi-generator-cli is installed
    echo [ ] Installing openapi-generator-cli
    call npm install -g @openapitools/openapi-generator-cli >nul 2>nul
    if %errorlevel% neq 0 (
        echo [✗] Failed to install openapi-generator-cli
        exit /b 1
    )
    echo [✓] install openapi-generator-cli
)

echo [✓] Generating Lam7aApi
:: Step 2 - Generate Lam7aApi
call openapi-generator-cli generate -i http://backend-code.duckdns.org/dev/swagger.json -g dart-dio -o Lam7aApi >nul 2>nul

rm -rf Lam7aApi/test Lam7aApi/doc

echo [✓] Getting dependencies
:: Step 3 - Get dependencies
cd Lam7aApi || (echo [✗] Lam7aApi folder missing & exit /b 1)
call flutter pub get >nul 2>nul
if %errorlevel% neq 0 (
    echo [✗] Getting dependencies
    exit /b 1
)

echo [✓] Running build_runner
:: Step 4 - Run build_runner
call flutter pub run build_runner build --delete-conflicting-outputs >nul 2>nul
if %errorlevel% neq 0 (
    echo [✗] Running build_runner
    exit /b 1
)

echo.
echo All steps completed successfully.
