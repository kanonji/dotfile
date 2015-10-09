#!/bin/sh
WORKING_DIR=$(cd $(dirname "${0}"); pwd)

# ${WORKING_DIR}/login-hook.d/foo.sh

if [ -x "${WORKING_DIR}/login-hook-env.sh" ]; then
    ${WORKING_DIR}/login-hook-env.sh
fi
