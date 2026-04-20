FROM honeytrap/honeytrap:latest

# إنشاء المجلدات المطلوبة
RUN mkdir -p /config /data

# نسخ ملف التكوين
COPY config.toml /config/config.toml

# تعريض المنفذ
EXPOSE 8022

# تجاوز نقطة الدخول الأصلية وتشغيل honeytrap مباشرة
ENTRYPOINT ["honeytrap"]
CMD ["--config", "/config/config.toml", "--data", "/data/"]
