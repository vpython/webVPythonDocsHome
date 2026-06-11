#!/bin/bash
# Builds VPython docs from RST sources and deploys to GCS bucket.
# Requires: sphinx, gcloud CLI

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/vpdocs"
OUTPUT_DIR="$SCRIPT_DIR/docs/VPythonDocs"
BUCKET="gs://glow-docs/VPythonDocs"

echo "Building VPython docs..."
"$SCRIPT_DIR/.venv/bin/sphinx-build" -b html "$SOURCE_DIR" "$OUTPUT_DIR"

echo "Deploying to $BUCKET..."
gcloud storage rsync -r --delete-unmatched-destination-objects --exclude=".doctrees/.*|\.buildinfo.*" "$OUTPUT_DIR" "$BUCKET"

echo "Done."
