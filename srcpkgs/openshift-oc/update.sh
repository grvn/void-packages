#!/usr/bin/env bash

set -euo pipefail

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"
TEMPLATE=${__dir}/template

LATEST_VERSION=$(git ls-remote --tags --refs https://github.com/openshift/oc | grep -o 'openshift-clients-\(v\)\?[0-9]\+\.[0-9]\+\.[0-9]\+-[0-9]\{8,14\}$' \
  | awk -F- '
      {
        ts = $NF
        while (length(ts) < 14) ts = ts "0"
        print ts, $0
      }
    ' \
  | sort -nr | head -n1 | cut -d' ' -f2-
)
VERSION=${LATEST_VERSION#"openshift-clients-"}
CUR_VERSION=$(grep -E '^version=' "${TEMPLATE}" | cut -d= -f2)
CUR_TIMESTAMP=$(grep -E '^timestamp=' "${TEMPLATE}" | cut -d= -f2)
CURRENT_VERSION=$(printf "%s-%s" "${CUR_VERSION}" "${CUR_TIMESTAMP}")

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export TIMESTAMP=${VERSION##*-}
export VERSION=${VERSION%-*}

# No preprepped checksum files, need to download the binary and calculate it myself
curl --fail -sL --output oc.tar.gz https://github.com/openshift/oc/archive/refs/tags/${LATEST_VERSION}.tar.gz
export SHA256=$(sha256sum ./oc.tar.gz | cut -d ' ' -f1 )
rm ./oc.tar.gz
[[ -n ${SHA256} && ${SHA256} =~ ^[A-Fa-f0-9]{64}$ ]] && printf "got junk instead of sha256\n" && exit 1

git clone --no-checkout --depth 1 --filter=blob:none --single-branch --branch ${LATEST_VERSION} https://github.com/openshift/oc.git oc
cd oc
export GIT_SHORT_COMMIT=$(git rev-list --max-count=1 --abbrev-commit HEAD)
cd ..
rm -rf oc
[[ ! ${GIT_SHORT_COMMIT} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of git short commit\n" && exit 1

sed -i "s|^version=.*$|version=${VERSION}|" "${TEMPLATE}"
sed -i "s|^checksum=.*$|checksum=${SHA256}|" "${TEMPLATE}"
sed -i "s|^_git_commit=.*$|_git_commit=${GIT_SHORT_COMMIT}|" "${TEMPLATE}"
sed -i "s|^timestamp=.*$|timestamp=${TIMESTAMP}|" "${TEMPLATE}"

printf "oc template updated\n"
