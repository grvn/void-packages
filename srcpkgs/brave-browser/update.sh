#!/usr/bin/env bash

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"

LATEST_VERSION=$(gh release list --repo brave/brave-browser --exclude-drafts --exclude-pre-releases --json name,tagName,isLatest --jq '.[] | select(.isLatest)|.tagName')
export VERSION=${LATEST_VERSION#"v"}
CURRENT_VERSION=$(grep -E '^version=' ${__dir}/template | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export SHA256=$(curl -L https://github.com/brave/brave-browser/releases/download/v${VERSION}/brave-browser_${VERSION}-linux-amd64.zip.sha256 | cut -d ' ' -f1 )
[[ ! ${SHA256} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of sha256\n" && exit 1

envsubst '${SHA256} ${VERSION}' < ${__dir}/.template > ${__dir}/template

printf "Brave template updated\n"
