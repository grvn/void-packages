#!/usr/bin/env bash

set -euo pipefail

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"
TEMPLATE=${__dir}/template
REPO="zen-browser/desktop"

LATEST_VERSION=$(gh release list --repo ${REPO} --exclude-drafts --exclude-pre-releases --json name,tagName,isLatest --jq '.[] | select(.isLatest)|.tagName' | grep -oE '[0-9]\.([0-9\.]+[a-z]*)+' )
export VERSION=${LATEST_VERSION#"v"}
CURRENT_VERSION=$(grep -E '^version=' "${TEMPLATE}" | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export SHA256=$(gh release view ${LATEST_VERSION} -R ${REPO} --json assets --jq '.assets[] | select(.name=="zen.linux-x86_64.tar.xz") | .digest' | cut -d":" -f2)
[[ -n ${SHA256} && ${SHA256} =~ ^[A-Fa-f0-9]{64}$ ]] && printf "got junk instead of checksum\n" && exit 1

sed -i "s|^version=.*$|version=${VERSION}|" "${TEMPLATE}"
sed -i "s|^revision=.*$|revision=1|" "${TEMPLATE}"
sed -i "s|^checksum=.*$|checksum=${SHA256}|" "${TEMPLATE}"

printf "Zen template updated\n"
