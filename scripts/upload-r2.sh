#!/bin/bash
# Cloudflare R2에 툴체인 업로드
# 사전 준비: npm install -g wrangler && wrangler login
# Usage: ./upload-r2.sh <bucket-name> <file.7z>

set -e

BUCKET="$1"
FILE="$2"

if [ -z "$BUCKET" ] || [ -z "$FILE" ]; then
    echo "Usage: $0 <bucket-name> <file.7z>"
    echo "Example: $0 embtool-toolchains nxp-14.2.1-linux-x64.7z"
    exit 1
fi

FILENAME=$(basename "$FILE")

echo "📤 Uploading ${FILENAME} to R2 bucket '${BUCKET}'..."
wrangler r2 object put "${BUCKET}/${FILENAME}" --file="$FILE"

echo "✅ Uploaded: ${FILENAME}"
echo "   SHA256: $(sha256sum "$FILE" | cut -d' ' -f1)"
echo ""
echo "📋 Update versions.json with this info"
