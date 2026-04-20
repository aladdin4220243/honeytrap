FROM golang:1.20-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

# نسخ الكود
COPY . .

# إصلاح مسارات الاستيراد (هذا قد لا يعمل دائماً)
RUN find . -name "*.go" -exec sed -i 's|github.com/honeytrap/honeytrap/services|./services|g' {} \;

# تجميع
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o honeytrap .

FROM alpine:latest

RUN apk --no-cache add ca-certificates
RUN mkdir -p /config /data

COPY --from=builder /app/honeytrap /usr/local/bin/honeytrap
COPY config.toml /config/config.toml

EXPOSE 8022

CMD ["honeytrap", "--config", "/config/config.toml", "--data", "/data/"]
