#!/bin/bash
# Serves the VPython docs on port 8070.
#
# Serves from the webVPythonDocsHome root so that the docs are reachable at:
#   http://localhost:8070/docs/VPythonDocs/index.html
# which matches the PUBLIC_DOCS_HOME URL expected by flaskHost.
#
# --bind 0.0.0.0 makes the server reachable on all network interfaces, not
# just localhost, so tablets and phones on the same network can access it.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Serving VPython docs on port 8070 (root: $SCRIPT_DIR)"
python3 -m http.server 8070 --bind 0.0.0.0 --directory "$SCRIPT_DIR"
