#!/bin/bash
# Builds VPython docs from RST sources and outputs to docs/VPythonDocs/.
# Run from the webVPythonDocsHome directory.
# Requires: python -m venv .venv && .venv/bin/pip install -r requirements.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/vpdocs"
OUTPUT_DIR="$SCRIPT_DIR/docs/VPythonDocs"

echo "Building VPython docs..."
echo "  Source: $SOURCE_DIR"
echo "  Output: $OUTPUT_DIR"

"$SCRIPT_DIR/.venv/bin/sphinx-build" -b html "$SOURCE_DIR" "$OUTPUT_DIR"

echo "Done. Output at $OUTPUT_DIR/index.html"
