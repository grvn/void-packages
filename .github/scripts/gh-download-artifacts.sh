#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <artifact-name> <output-dir>"
    exit 1
fi

ARTIFACT_NAME="$1"
OUTDIR="$2"

mkdir -p "$OUTDIR"

# List artifacts
LIST_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts"

ARTIFACT_ID=$(curl -sSL \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  "${LIST_URL}" \
  | jq -r ".artifacts[]
      | select(.name==\"${ARTIFACT_NAME}\")
      | select(.workflow_run.id == ${GITHUB_RUN_ID})
      | .id")

if [ -z "$ARTIFACT_ID" ] || [ "$ARTIFACT_ID" = "null" ]; then
    echo "Artifact '$ARTIFACT_NAME' not found for this run"
    exit 1
fi

# Download artifact
DOWNLOAD_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts/${ARTIFACT_ID}/zip"

echo "Downloading artifact '$ARTIFACT_NAME' (ID $ARTIFACT_ID)..."

curl -L -sSL -H "Authorization: Bearer ${GH_TOKEN}" -o /tmp/artifact.zip "${DOWNLOAD_URL}"

unzip -o /tmp/artifact.zip -d "$OUTDIR"

echo "Download complete."
