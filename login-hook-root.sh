#!/bin/sh
./login-hook-root.d/add-loopback-ip-alias.sh

if [ -x './login-hook-root-env.sh' ]; then
    ./login-hook-root-env.sh
fi
