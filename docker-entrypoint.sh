#!/bin/sh
set -eu

echo "Starting Node-RED..."

# Check required variables.
if [ -z "${NODERED_ADMIN_USERNAME:-}" ]; then
    echo "ERROR: NODERED_ADMIN_USERNAME is not set."
    exit 1
fi

if [ -z "${NODERED_ADMIN_PASSWORD:-}" ]; then
    echo "ERROR: NODERED_ADMIN_PASSWORD is not set."
    exit 1
fi

if [ -z "${NODE_RED_CREDENTIAL_SECRET:-}" ]; then
    echo "ERROR: NODE_RED_CREDENTIAL_SECRET is not set."
    exit 1
fi

# Convert the Coolify password to a bcrypt hash.
NODERED_ADMIN_PASSWORD_HASH="$(
    node -e '
        const bcrypt = require("/opt/nodered-auth/node_modules/bcryptjs");

        const password = process.argv[1];

        if (!password) {
            console.error("ERROR: No password supplied.");
            process.exit(1);
        }

        console.log(bcrypt.hashSync(password, 8));
    ' "$NODERED_ADMIN_PASSWORD"
)"

export NODERED_ADMIN_PASSWORD_HASH

# The plaintext password is no longer needed.
unset NODERED_ADMIN_PASSWORD

echo "Node-RED authentication configured for user: ${NODERED_ADMIN_USERNAME}"

# Start Node-RED using /data as its persistent user directory.
exec node-red \
    --userDir /data \
    --settings /opt/nodered-settings/settings.js
