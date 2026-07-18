#!/bin/bash
set -e

# Change directory to the package root directory
CDPATH="" cd -- "$(dirname -- "$0")/.."

echo "==> Building app for verification..."
swift build

# Get debug binary path
EXE_PATH=$(swift build --show-bin-path)/SpectrogramApp

# Target experiment data directory (prefer clean path, fallback to control character path)
PREFER_DIR="/Users/takumi/Documents/4e_zikken/hattori/フーリエ変換の基礎実験"
FALLBACK_DIR="/Users/takumi/Documents/4e_zikken/"$'\b'"1_hattori/フーリエ変換の基礎実験"

if [ -d "$PREFER_DIR" ]; then
    EXP_DIR="$PREFER_DIR"
else
    EXP_DIR="$FALLBACK_DIR"
fi

TEST_OUT="test_output.png"

echo "==> Running smoke test against directory:"
echo "    $EXP_DIR"

if [ ! -d "$EXP_DIR" ]; then
    echo "Error: Experiment directory not found at $EXP_DIR"
    exit 1
fi

rm -f "$TEST_OUT"

echo "==> Running compiled binary in headless CLI mode..."
"$EXE_PATH" "$EXP_DIR" "$TEST_OUT" 256 256

if [ -f "$TEST_OUT" ]; then
    echo "==> [SUCCESS] Smoke test completed successfully!"
    echo "    Generated image details:"
    ls -lh "$TEST_OUT"
    # Clean up test output
    rm -f "$TEST_OUT"
    echo "==> Cleaned up test output."
else
    echo "Error: Smoke test failed to generate $TEST_OUT"
    exit 1
fi
