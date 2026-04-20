FROM honeytrap/honeytrap:latest

COPY config.toml /config/config.toml

EXPOSE 8022 8080

CMD ["honeytrap", "--config", "/config/config.toml"]
