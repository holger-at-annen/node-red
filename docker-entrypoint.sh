#!/bin/sh
set -eu

if [ -z "${NODERED_ADMIN_USERNAME:-}" ]; then
    echo "ERROR: NODERED_ADMIN_USERNAME is not set"
    exit 1
fi

if [ -z "${NODERED_ADMIN_PASSWORD:-}" ]; then
    echo "ERROR: NODERED_ADMIN_PASSWORD is not set"
    exit 1
fi

export NODERED_ADMIN_PASSWORD_HASH="$(
    node -e 'console.log(require("bcryptjs").hashSync(process.argv[1], 8));' \
    "$NODERED_ADMIN_PASSWORD"
)"

unset NODERED_ADMIN_PASSWORD

exec node-red --userDir /data
