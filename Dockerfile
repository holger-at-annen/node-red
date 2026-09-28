FROM nodered/node-red:latest

USER root

COPY settings.js /data/settings.js
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER node-red

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
