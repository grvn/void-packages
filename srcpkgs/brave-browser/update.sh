#!/usr/bin/env bash

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"
TEMPLATE=${__dir}/template
REPO="brave/brave-browser"

LATEST_VERSION=$(gh release list --repo ${REPO} --exclude-drafts --exclude-pre-releases --json name,tagName,isLatest --jq '.[] | select(.isLatest)|.tagName')
export VERSION=${LATEST_VERSION#"v"}
CURRENT_VERSION=$(grep -E '^version=' "${TEMPLATE}" | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export SHA256=$(curl -L https://github.com/brave/brave-browser/releases/download/v${VERSION}/brave-browser-${VERSION}-linux-amd64.zip.sha256 | cut -d ' ' -f1 )
[[ -n ${SHA256} && ${SHA256} =~ ^[A-Fa-f0-9]{64}$ ]] && printf "got junk instead of sha256\n" && exit 1

sed -i "s|^version=.*$|version=${VERSION}|" "${TEMPLATE}"
sed -i "s|^checksum=.*$|checksum=${SHA256}|" "${TEMPLATE}"

printf "Brave template updated\n"
