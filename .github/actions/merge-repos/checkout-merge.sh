#!/bin/bash

set -ex

PRIMARY_REF="${PRIM_REF/refs\//refs\/remotes\/}"
SECONDARY_REF="${SEC_REF/refs\//refs\/remotes\/}"

/bin/echo -e '::group::\x1b[32mCloning primary repository...\x1b[0m'
git clone --progress --no-checkout --filter=tree:0 "${PRIM_SERVER_URL}/${PRIM_REPOSITORY}" "$PWD"
git config --global --add gc.auto 0
git config --global --add safe.directory "$PWD"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mFetching primary repository refs...\x1b[0m'
git fetch --prune --progress --filter=tree:0 origin \
    +refs/heads/*:refs/remotes/origin/* \
    +${PRIM_REF}:"${PRIMARY_REF}"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mChecking out primary repository...\x1b[0m'
git checkout --progress --force "${PRIMARY_REF}"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mConfiguring for merging secondary repository...\x1b[0m'
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git remote add -f secondary "${SEC_SERVER_URL}/${SEC_REPOSITORY}"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mMerging secondary repository...\x1b[0m'
git merge --no-commit --strategy-option=theirs --allow-unrelated-histories -Xignore-space-change "secondary/${PRIMARY_REF}"
echo "::endgroup::"
