#!/bin/bash
# MCUXpresso IDE .deb.bin에서 NXP 툴체인 추출
# Usage: ./extract-linux.sh mcuxpressoide-xxx.deb.bin [output.7z]

set -e

INPUT="$1"
VERSION="${2:-}"

if [ -z "$INPUT" ]; then
    echo "Usage: $0 <mcuxpressoide-xxx.deb.bin> [version]"
    exit 1
fi

echo "📦 Extracting MCUXpresso IDE installer..."
TMPDIR=$(mktemp -d)
"$INPUT" --noexec --target "$TMPDIR/installer"

echo "📦 Extracting .deb package..."
cd "$TMPDIR"
ar x installer/*.deb
tar xzf data.tar.gz

echo "🔍 Finding tools directory..."
TOOLS_DIR=$(find usr -type d -name "tools" -path "*/com.nxp.mcuxpresso.tools.linux*" | head -1)

if [ -z "$TOOLS_DIR" ]; then
    echo "❌ tools directory not found"
    exit 1
fi

# 버전 감지
if [ -z "$VERSION" ]; then
    VERSION=$(cat "$TOOLS_DIR/arm-toolchain-addons-version.txt" 2>/dev/null || echo "unknown")
fi

echo "✅ Found toolchain v${VERSION} at ${TOOLS_DIR}"

# 검증
if [ -f "$TOOLS_DIR/bin/arm-none-eabi-gcc" ]; then
    GCC_VER=$("$TOOLS_DIR/bin/arm-none-eabi-gcc" --version | head -1)
    echo "   GCC: $GCC_VER"
fi

OUTPUT="nxp-${VERSION}-linux-x64.7z"
echo "📦 Compressing to ${OUTPUT}..."
cd "$TOOLS_DIR"
7z a "$OLDPWD/$OUTPUT" .

echo "✅ Done: $OUTPUT"
echo "   SHA256: $(sha256sum "$OLDPWD/$OUTPUT" | cut -d' ' -f1)"

# 정리
rm -rf "$TMPDIR"
