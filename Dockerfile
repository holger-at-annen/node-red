FROM nodered/node-red:latest

USER root

# Install su-exec (Alpine alternative to gosu) and bcryptjs for auth setup
RUN apk add --no-cache su-exec \
    && mkdir -p /opt/nodered-auth \
    && cd /opt/nodered-auth \
    && npm install --omit=dev --no-fund --no-audit bcryptjs

# Custom Node-RED configuration.
COPY settings.js /opt/nodered-settings/settings.js

# Startup script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Leave as root so entrypoint can perform the 'chown' fix on startup.
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
