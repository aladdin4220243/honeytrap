# مرحلة البناء
FROM golang:1.20-alpine AS builder

# تثبيت git (مطلوب لتحميل dependencies)
RUN apk add --no-cache git

WORKDIR /app

# نسخ ملفات go module أولاً (للاستفادة من caching)
COPY go.mod go.sum ./
RUN go mod download

# نسخ باقي الكود
COPY . .

# تجميع honeytrap (بدون استخدام scripts/gen-ldflags.go)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o honeytrap .

# مرحلة التشغيل
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# نسخ الملف التنفيذي
COPY --from=builder /app/honeytrap /usr/local/bin/honeytrap

# نسخ ملف التكوين
COPY config.toml ./config.toml

# المنافذ المطلوبة
EXPOSE 8022 8080

# التشغيل
CMD ["honeytrap", "--config", "config.toml"]
