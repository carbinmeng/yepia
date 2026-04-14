#!/bin/bash
set -euo pipefail

DEFAULT_APP_PATH="/Applications/YEPIA.app"
APP_PATH="${1:-$DEFAULT_APP_PATH}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: This script only supports macOS."
  exit 1
fi

if [[ ! -d "$APP_PATH" ]]; then
  echo "ERROR: App bundle not found: $APP_PATH"
  echo "Usage: $0 [/path/to/YEPIA.app]"
  exit 1
fi

if [[ "$(basename "$APP_PATH")" != "YEPIA.app" ]]; then
  echo "WARN: Target does not end with YEPIA.app: $APP_PATH"
fi

if ! command -v xattr >/dev/null 2>&1; then
  echo "ERROR: xattr command not found."
  exit 1
fi

if ! command -v codesign >/dev/null 2>&1; then
  echo "ERROR: codesign command not found."
  exit 1
fi

echo "[fix-yepia-macos] Clearing quarantine and extended attributes: $APP_PATH"
sudo xattr -cr "$APP_PATH"

echo "[fix-yepia-macos] Re-signing app bundle with ad-hoc signature: $APP_PATH"
sudo codesign --force --deep --sign - "$APP_PATH"

echo "[fix-yepia-macos] Verifying signature"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

echo "[fix-yepia-macos] Opening app"
open "$APP_PATH"

