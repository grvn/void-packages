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

# We do not want the preprepped checksum files, need to download the binary and calculate it myself
gh release download -R ${REPO} --archive=tar.gz --output "dgop.tar.gz"
export SHA256=$(sha256sum ./dgop.tar.gz | cut -d ' ' -f1 )
rm ./dgop.tar.gz

if [[ -z ${SHA256} ]]; then
  printf "got nothing instead of checksum (empty)\n"
  exit 1
fi
if [[ ! ${SHA256} =~ ^[A-Fa-f0-9]{64}$ ]]; then
  printf "got junk instead of checksum (invalid format)\n"
  exit 1
fi

printf "checksum OK\nchecksum=%s\n" "${SHA256}"
sed -i "s|^version=.*$|version=${VERSION}|" "${TEMPLATE}"
sed -i "s|^revision=.*$|revision=1|" "${TEMPLATE}"
sed -i "s|^checksum=.*$|checksum=${SHA256}|" "${TEMPLATE}"

printf "dgop template updated\n"
