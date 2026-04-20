# استخدام الصورة الرسمية من Docker Hub
FROM honeytrap/honeytrap:latest

# إنشاء المجلدات المطلوبة
RUN mkdir -p /config /data

# نسخ ملف التكوين
COPY config.toml /config/config.toml

# المنافذ
EXPOSE 8022

# إلغاء أي نقطة دخول افتراضية وتشغيل honeytrap مباشرة
ENTRYPOINT []
CMD ["honeytrap", "--config", "/config/config.toml", "--data", "/data/"]
