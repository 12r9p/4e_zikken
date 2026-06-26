#!/bin/bash
set -e

# Change directory to the package root directory
CDPATH="" cd -- "$(dirname -- "$0")/.."

echo "==> Cleaning previous builds..."
rm -rf build/
swift package clean

echo "==> Building executable in release mode..."
swift build -c release

# Get executable path
EXE_PATH=$(swift build -c release --show-bin-path)/SpectrogramApp
if [ ! -f "$EXE_PATH" ]; then
    echo "Error: Compiled binary not found at $EXE_PATH"
    exit 1
fi

echo "==> Creating macOS App Bundle..."
APP_DIR="build/SpectrogramApp.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
mkdir -p "$MACOS_DIR"

echo "==> Copying binary into App Bundle..."
cp "$EXE_PATH" "$MACOS_DIR/"
chmod +x "$MACOS_DIR/SpectrogramApp"

echo "==> Creating Info.plist..."
cat > "$APP_DIR/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SpectrogramApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.takumi.spectrogram-app</string>
    <key>CFBundleName</key>
    <string>SpectrogramApp</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "==> Successfully created app at build/SpectrogramApp.app!"
echo "==> You can run the application with:"
echo "    open build/SpectrogramApp.app"
echo "    or run the CLI test mode with:"
echo "    ./build/SpectrogramApp.app/Contents/MacOS/SpectrogramApp <csv_dir> <output_png> [sampling_rate] [sample_count]"
