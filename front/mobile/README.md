# Front Mobile

## Description

This is the mobile front-end for the area project. It is build with [Flutter](https://flutter.dev/).

## Prerequisites

- [Dart](https://dart.dev/get-dart)
- [Flutter](https://flutter.dev/docs/get-started/install)

First create a `.env` file in the `app/` folder and copy the content of the `.env.example` file in it. You will have to fill the variables with your own values.
In Production, you will have to change the value of the `API_URL` variable to the production API URL.

Then run the following command to get the dependencies:

```bash
$> flutter pub get
```

## Usage

```bash
$> flutter build [ apk | appbundle ]
[...]
$> flutter run --release
```
> You should use android studio to run the app on an emulator or a real device.
