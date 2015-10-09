#!/bin/sh
WORKING_DIR=$(cd $(dirname "${0}"); pwd)

${WORKING_DIR}/login-hook-root.d/add-loopback-ip-alias.sh

if [ -x "${WORKING_DIR}/login-hook-root-env.sh" ]; then
    ${WORKING_DIR}/login-hook-root-env.sh
fi
