#!/bin/bash

set -e

/bin/echo -e '\x1b[32mUpdate etc/conf...\x1b[0m'
echo XBPS_BUILD_ENVIRONMENT=ci >> etc/conf
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
echo XBPS_CHROOT_CMD=uchroot >> etc/conf
echo XBPS_MAKEJOBS="$(nproc)" >> etc/conf

/bin/echo -e '\x1b[32mRunning xbps bootstrap...\x1b[0m'
./xbps-src binary-bootstrap
