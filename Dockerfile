FROM nodered/node-red:latest

USER root

# Install gosu to safely drop privileges, and bcryptjs for your auth setup
RUN apt-get update && apt-get install -y --no-install-recommends gosu \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/nodered-auth \
    && cd /opt/nodered-auth \
    && npm install --omit=dev --no-fund --no-audit bcryptjs

# Custom Node-RED configuration.
COPY settings.js /opt/nodered-settings/settings.js

# Startup script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Leave as root so the entrypoint can perform the 'chown' fix on startup.
# Privileges are securely dropped inside the entrypoint.sh script.
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
