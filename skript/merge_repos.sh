#!/bin/bash

git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global --add safe.directory "*"

git remote add -f grvn https://github.com/grvn/void-packages.git
git merge --no-commit --strategy-option=theirs --allow-unrelated-histories -Xignore-space-change grvn/main
