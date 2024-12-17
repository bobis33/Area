FROM ghcr.io/cirruslabs/flutter:3.27.1 AS build

WORKDIR /app
COPY /app .

RUN flutter pub get && flutter build apk --release

FROM alpine:latest AS production

WORKDIR /app

COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /app/app-release.apk

CMD ["echo", "Mobile client APK build completed"]
