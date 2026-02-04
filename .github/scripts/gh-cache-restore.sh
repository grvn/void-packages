#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <cache-key> <restore-path>"
    exit 1
fi

KEY="$1"
RESTORE_PATH="$2"

mkdir -p "$RESTORE_PATH"

LIST=$(curl -sSL -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/caches?key=$KEY")

CACHE_ID=$(echo "$LIST" | jq -r '.actions_caches[0].id // empty')

if [ -z "$CACHE_ID" ]; then
    echo "No cache found for key: $KEY"
    exit 0
fi

curl -sSL -H "Authorization: Bearer $GITHUB_TOKEN" -o /tmp/cache.tgz "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/caches/$CACHE_ID"

tar -xzf /tmp/cache.tgz -C "$RESTORE_PATH"

echo "Cache restored: $KEY"
