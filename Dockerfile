FROM honeytrap/honeytrap:latest

# إنشاء المجلدات المطلوبة للتكوين والبيانات
RUN mkdir -p /config /data

# نسخ ملف التكوين المخصص إلى المسار الذي تتوقعه الصورة
COPY config.toml /config/config.toml

# فتح المنفذ الذي سيراقبه Honeytrap
EXPOSE 8022

# تشغيل Honeytrap مع ملف التكوين الخاص بنا
CMD ["honeytrap", "--config", "/config/config.toml", "--data", "/data/"]
