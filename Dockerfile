FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git gcc musl-dev curl

ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /src/honeytrap
COPY . .

RUN go mod tidy && \
    CGO_ENABLED=0 GOOS=linux go build \
    -a -installsuffix cgo \
    -o /go/bin/honeytrap .

# ── Runtime stage ──────────────────────────────────────────────────────────────
FROM python:3.12-alpine

RUN apk add --no-cache ca-certificates curl && \
    update-ca-certificates

# Python forwarder dependencies
RUN pip install --no-cache-dir requests

# Create dirs
RUN mkdir -p /config /data /logs

# Copy honeytrap binary
COPY --from=builder /go/bin/honeytrap /honeytrap/honeytrap

# Copy config and forwarder
COPY config.toml         /config/config.toml
COPY forwarder.py        /forwarder.py
COPY entrypoint.sh       /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8022 5900 8080

ENTRYPOINT ["/entrypoint.sh"]
