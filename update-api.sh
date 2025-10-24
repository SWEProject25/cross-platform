#!/bin/bash
set -e

# ===== CONFIG =====
SWAGGER_URL="http://backend-code.duckdns.org/dev/swagger.json"
DOWNLOAD="swagger.json"
FIXED="swagger_fixed.json"
OUT_DIR="Lam7aApi"

# Set npm to use local cache to avoid permission issues
export NPM_CONFIG_CACHE="$HOME/.npm"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export OPENAPI_GENERATOR_VERSION="7.10.0"

# ===== Ensure directories exist =====
mkdir -p "$HOME/.npm"
mkdir -p "$HOME/.npm-global/lib"   # Fix: prevent ENOENT
mkdir -p "$HOME/.npm-global/bin"

# Add npm-global/bin to PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# ===== Download =====
echo "[✓] Downloading OpenAPI JSON from $SWAGGER_URL"
curl -s -L "$SWAGGER_URL" -o "$DOWNLOAD"
if [ $? -ne 0 ]; then
    echo "[✗] curl failed"
    exit 1
fi
if [ ! -f "$DOWNLOAD" ]; then
    echo "[✗] Download missing"
    exit 1
fi

# ===== Run PowerShell fixer (if available) =====
if command -v pwsh >/dev/null 2>&1; then
    echo "[✓] Running PowerShell fix script via pwsh"
    pwsh -NoProfile -ExecutionPolicy Bypass -File "fix-opids.ps1" -InputFile "$DOWNLOAD" -OutputFile "$FIXED"
elif command -v powershell >/dev/null 2>&1; then
    echo "[✓] Running PowerShell fix script via powershell"
    powershell -NoProfile -ExecutionPolicy Bypass -File "fix-opids.ps1" -InputFile "$DOWNLOAD" -OutputFile "$FIXED"
else
    echo "[!] PowerShell not found; skipping fix-opids.ps1"
    cp "$DOWNLOAD" "$FIXED"
fi

# ===== Prepare generator input =====
if [ -d "$OUT_DIR" ]; then
    echo "[!] Removing existing $OUT_DIR ..."
    rm -rf "$OUT_DIR"
fi

# ===== Generate API client =====
echo "[✓] Generating $OUT_DIR from $FIXED"
npx --yes @openapitools/openapi-generator-cli@2.14.0 version-manager set "$OPENAPI_GENERATOR_VERSION"
npx --yes @openapitools/openapi-generator-cli@2.14.0 generate -i "$FIXED" -g dart-dio -o "$OUT_DIR"
if [ $? -ne 0 ]; then
    echo "[✗] openapi-generator-cli generate failed"
    exit 1
fi
echo "[✓] Generation complete"

# ===== Cleanup generator extras =====
echo "[✓] Cleaning up extra files..."
rm -rf "$OUT_DIR/test" "$OUT_DIR/doc"
rm -f "$DOWNLOAD" "$FIXED"

# ===== Flutter steps =====
cd "$OUT_DIR" || { echo "[✗] $OUT_DIR folder missing"; exit 1; }

echo "[✓] Getting dependencies"
flutter pub get || { echo "[✗] flutter pub get failed"; exit 1; }

echo "[✓] Running build_runner"
flutter pub run build_runner build --delete-conflicting-outputs || { echo "[✗] build_runner failed"; exit 1; }

echo ""
echo "🎉 All steps completed successfully."
exit 0
