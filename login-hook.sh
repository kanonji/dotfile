#!/bin/sh

# ./login-hook.d/foo.sh

if [ -x './login-hook-env.sh' ]; then
    ./login-hook-env.sh
fi
