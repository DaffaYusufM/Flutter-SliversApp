# ---------- STAGE 1: Build Flutter Web ----------
FROM ghcr.io/cirruslabs/flutter:3.35.7 AS build
WORKDIR /app

# Aktifkan support untuk web
RUN flutter config --enable-web
# Copy semua file proyek
COPY . .

# Install dependency dan build release
RUN flutter pub get && flutter build web --release
# ---------- STAGE 2: Serve pakai Nginx ----------
FROM nginx:alpine
# Hapus file default nginx
RUN rm -rf /usr/share/nginx/html/*
# Salin hasil build Flutter Web ke direktori html nginx
COPY --from=build /app/build/web /usr/share/nginx/html
# Expose port 80
EXPOSE 80
# Healthcheck optional
HEALTHCHECK --interval=30s --timeout=30s --start-period=10s \
  CMD wget -qO- http://localhost/ || exit 1
# Jalankan nginx di foreground
CMD ["nginx", "-g", "daemon off;"]
