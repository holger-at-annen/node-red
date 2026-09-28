FROM nodered/node-red:latest

USER root

# Install bcryptjs so we can generate the Node-RED
# admin password hash at container startup.
RUN mkdir -p /opt/nodered-auth \
    && cd /opt/nodered-auth \
    && npm install --omit=dev --no-fund --no-audit bcryptjs

# Custom Node-RED configuration.
COPY settings.js /opt/nodered-settings/settings.js

# Startup script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER node-red

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
