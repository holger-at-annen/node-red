#!/bin/sh
set -eu

echo "Verifying data volume ownership..."

# Ensure the /data directory belongs to the 'node-red' user (UID 1000).
chown -R 1000:1000 /data

# Check required variables.
if [ -z "${NODERED_ADMIN_USERNAME:-}" ] || [ -z "${NODERED_ADMIN_PASSWORD:-}" ] || [ -z "${NODE_RED_CREDENTIAL_SECRET:-}" ]; then
    echo "ERROR: Missing required environment variables (USERNAME, PASSWORD, or SECRET)."
    exit 1
fi

echo "Configuring Node-RED authentication..."

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
unset NODERED_ADMIN_PASSWORD

echo "Node-RED authentication configured for user: ${NODERED_ADMIN_USERNAME}"
echo "Starting Node-RED as user 'node-red'..."

# Drop root privileges cleanly using su-exec.
# 'exec' ensures Node-RED receives OS shutdown signals (SIGTERM) properly.
exec su-exec node-red node-red \
    --userDir /data \
    --settings /opt/nodered-settings/settings.js
