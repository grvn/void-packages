#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 [--retention-days N] <artifact-name> <path>"
    exit 1
}

RETENTION_DAYS=""
ARGS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --retention-days)
            RETENTION_DAYS="$2"
            shift 2
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

if [ ${#ARGS[@]} -ne 2 ]; then
    usage
fi

ARTIFACT_NAME="${ARGS[0]}"
ARTIFACT_PATH="${ARGS[1]}"

if [ ! -e "$ARTIFACT_PATH" ]; then
    echo "Error: path '$ARTIFACT_PATH' does not exist"
    exit 1
fi

# GitHub API requires a zip archive
ZIPFILE="/tmp/${ARTIFACT_NAME}.zip"
rm -f "$ZIPFILE"

if [ -d "$ARTIFACT_PATH" ]; then
    (cd "$ARTIFACT_PATH" && zip -r "$ZIPFILE" .)
else
    zip -j "$ZIPFILE" "$ARTIFACT_PATH"
fi

# Build JSON metadata
JSON=$(jq -n \
    --arg name "$ARTIFACT_NAME" \
    --argjson retention "${RETENTION_DAYS:-null}" \
    '{
        name: $name,
        retention_days: $retention
    }'
)

set -x

# Create artifact
CREATE_URL="https://uploads.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts"

echo "Creating artifact '$ARTIFACT_NAME'..."

ARTIFACT_ID=$(curl -sSL \
  -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$JSON" \
  "$CREATE_URL" \
  | jq -r '.id')

if [ -z "$ARTIFACT_ID" ] || [ "$ARTIFACT_ID" = "null" ]; then
    echo "Failed to create artifact"
    exit 1
fi

echo "Artifact created with ID $ARTIFACT_ID"

# Upload the zip file
UPLOAD_URL="https://uploads.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts/${ARTIFACT_ID}/zip"

echo "Uploading data..."
curl -sSL \
  -X PUT \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Content-Type: application/zip" \
  --data-binary @"${ZIPFILE}" \
  "$UPLOAD_URL" >/dev/null

echo "Upload complete."
