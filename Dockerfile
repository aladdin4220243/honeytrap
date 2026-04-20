FROM golang:1.20-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

# نسخ go.mod و go.sum أولاً (للاستفادة من caching)
COPY go.mod go.sum ./
RUN go mod download

# نسخ الكود المتبقي
COPY . .

# إصلاح مسارات الاستيراد (تحويل imports المحلية إلى imports كاملة)
RUN find . -name "*.go" -exec sed -i 's|"./services|"github.com/honeytrap/honeytrap/services|g' {} \;

# بناء honeytrap
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o honeytrap ./cmd/honeytrap

FROM alpine:latest

RUN apk --no-cache add ca-certificates
RUN mkdir -p /config /data

COPY --from=builder /app/honeytrap /usr/local/bin/honeytrap
COPY config.toml /config/config.toml

EXPOSE 8022 8080

ENTRYPOINT ["honeytrap"]
CMD ["--config", "/config/config.toml", "--data", "/data/"]
