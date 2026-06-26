#!/bin/bash
set -e

# Change directory to the package root directory
CDPATH="" cd -- "$(dirname -- "$0")/.."

echo "==> Building and running Spectrogram App in GUI mode..."
swift run SpectrogramApp
