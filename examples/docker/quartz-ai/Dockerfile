# Lucee image, override with: docker compose build --build-arg LUCEE_IMAGE=lucee/lucee:<tag>
ARG LUCEE_IMAGE=lucee/lucee:7.1
FROM ${LUCEE_IMAGE}

# server config: Quartz extension, AI connection (from env vars), console logging
COPY lucee-config.json /opt/lucee/server/lucee-server/context/.CFConfig.json

# Quartz job definitions, read by the "quartz-task" gateway
COPY quartz/config.json /opt/lucee/server/lucee-server/context/quartz/config.json

# job components, {lucee-config}/components/ is mapped by default
COPY jobs/ /opt/lucee/server/lucee-server/context/components/jobs/

# job listeners: run statistics and AI token usage
COPY listeners/ /opt/lucee/server/lucee-server/context/components/listeners/

# sample feed the job checks when FEED_URL is not set
COPY data/ /opt/lucee/sample-data/
