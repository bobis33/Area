FROM ghcr.io/cirruslabs/flutter:3.27.1

WORKDIR /app

COPY /app .

RUN flutter pub get \
    && flutter build apk --release

CMD ["echo", "Mobile client APK build completed"]
