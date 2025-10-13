#!/usr/bin/env bash

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"

LATEST_VERSION=$(gh release list --repo zen-browser/desktop --json name,tagName,isLatest --jq '.[] | select(.isLatest)|.tagName' | grep -oE '[0-9]\.([0-9\.]+[a-z]*)+' )
export VERSION=${LATEST_VERSION#"v"}
CURRENT_VERSION=$(grep -E '^version=' ${__dir}/template | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export SHA256=$(gh release view ${LATEST_VERSION} -R zen-browser/desktop --json assets --jq '.assets[] | select(.name=="zen.linux-x86_64.tar.xz") | .digest' | cut -d":" -f2)
[[ ! ${SHA256} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of checksum\n" && exit 1

envsubst '${SHA256} ${VERSION}' < ${__dir}/.template > ${__dir}/template

printf "Zen template updated\n"
