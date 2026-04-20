FROM honeytrap/honeytrap:latest

RUN mkdir -p /config /data
COPY config.toml /config/config.toml

EXPOSE 8022

ENTRYPOINT []
CMD ["honeytrap", "--config", "/config/config.toml", "--data", "/data/"]
