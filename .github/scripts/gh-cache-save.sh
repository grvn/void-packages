#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <cache-key> <path>"
    exit 1
fi

KEY="$1"
PATH_TO_CACHE="$2"

if [ ! -d "$PATH_TO_CACHE" ]; then
    echo "Directory '$PATH_TO_CACHE' does not exist"
    exit 0
fi

TARBALL="/tmp/cache.tgz"
tar -czf "$TARBALL" -C "$PATH_TO_CACHE" .

# Reserve cache entry
RESERVE=$(curl -sSL -X POST -H "Authorization: Bearer $GITHUB_TOKEN" -H "Content-Type: application/json" \
  -d "{\"key\":\"$KEY\",\"version\":\"1\"}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/caches")

UPLOAD_URL=$(echo "$RESERVE" | jq -r '.upload_url')

if [ "$UPLOAD_URL" = "null" ]; then
    echo "Cache already exists, skipping upload"
    exit 0
fi

# Upload tarball
curl -sSL -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" -H "Content-Type: application/octet-stream" \
  --data-binary @"$TARBALL" \
  "$UPLOAD_URL"

echo "Cache saved: $KEY"
