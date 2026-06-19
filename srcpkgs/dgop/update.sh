#!/usr/bin/env bash

set -euo pipefail

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"
TEMPLATE=${__dir}/template
REPO="AvengeMedia/dgop"

LATEST_VERSION=$(gh release list --repo ${REPO} --exclude-drafts --exclude-pre-releases --json name,tagName,isLatest --jq '.[] | select(.isLatest)|.tagName')
export VERSION=${LATEST_VERSION#"v"}
CURRENT_VERSION=$(grep -E '^version=' "${TEMPLATE}" | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export SHA256=$(curl --fail --location --retry 3 --retry-delay 2 --silent https://github.com/${REPO}/releases/download/v${VERSION}/dgop-linux-amd64.tar.gz.sha256 | cut -d ' ' -f1 )
[[ -n ${SHA256} && ${SHA256} =~ ^[A-Fa-f0-9]{64}$ ]] && printf "got junk instead of sha256\n" && exit 1

sed -i "s|^version=.*$|version=${VERSION}|" "${TEMPLATE}"
sed -i "s|^checksum=.*$|checksum=${SHA256}|" "${TEMPLATE}"

printf "dgop template updated\n"

