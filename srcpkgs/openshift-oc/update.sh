#!/usr/bin/env bash

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"

LATEST_VERSION=$(git ls-remote --tags --refs --sort="v:refname" https://github.com/openshift/oc openshift-clients-\* | tail -n1 | sed 's/.*\///')
VERSION=${LATEST_VERSION#"openshift-clients-"}
CUR_VERSION=$(grep -E '^version=' ${__dir}/template | cut -d= -f2)
CUR_TIMESTAMP=$(grep -E '^timestamp=' ${__dir}/template | cut -d= -f2)
CURRENT_VERSION=$(printf "%s-%s" "${CUR_VERSION}" "${CUR_TIMESTAMP}")

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export TIMESTAMP=${VERSION##*-}
export VERSION=${VERSION%-*}

# No preprepped checksum files, need to download the binary and calculate it myself
curl --fail -sL --output oc.tar.gz https://github.com/openshift/oc/archive/refs/tags/${LATEST_VERSION}.tar.gz
export SHA256=$(sha256sum ./oc.tar.gz | cut -d ' ' -f1 )
rm ./oc.tar.gz
[[ ! ${SHA256} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of sha256\n" && exit 1

git clone --no-checkout --depth 1 --filter=blob:none --single-branch --branch ${LATEST_VERSION} https://github.com/openshift/oc.git oc
cd oc
export GIT_SHORT_COMMIT=$(git rev-list --max-count=1 --abbrev-commit HEAD)
cd ..
rm -rf oc
[[ ! ${GIT_SHORT_COMMIT} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of git short commit\n" && exit 1

envsubst '${SHA256} ${VERSION} ${GIT_SHORT_COMMIT} ${TIMESTAMP}' < ${__dir}/.template > ${__dir}/template

printf "oc template updated\n"
