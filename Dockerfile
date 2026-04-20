FROM golang:1.20-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o honeytrap .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

# إنشاء المجلد المطلوب للتكوين
RUN mkdir -p /config /data

# نسخ الملف التنفيذي
COPY --from=builder /app/honeytrap /usr/local/bin/honeytrap

# نسخ ملف التكوين إلى المكان الصحيح
COPY config.toml /config/config.toml

EXPOSE 8022 8080

CMD ["honeytrap", "--config", "/config/config.toml", "--data", "/data/"]
