# Flutter mid-term: Products

A small Flutter application based on the teacher's example. It displays products and opens a separate screen with a product fetched by ID. State management uses BLoC (`flutter_bloc`).

## Requirements

- Flutter SDK with Dart 3.13.5 or newer (same Dart constraint as the teacher's original project)
- Android emulator / Android phone, or iOS Simulator on macOS
- Internet access (DummyJSON is a public API, so no local backend is required)

## Run

```bash
flutter pub get
flutter run
```

Select an Android or iOS device if Flutter asks. For a web demo, use `flutter run -d chrome` (Chrome must be installed).

To run the simple test:

```bash
flutter test
```

## How it works

1. The home page requests `GET https://dummyjson.com/products` to display a list.
2. Tap any product card or enter an ID (for example, `1`) and press **Find**.
3. The details page makes a **new request**: `GET https://dummyjson.com/products/{id}`.
4. BLoC handles the loading, loaded, and error states.
5. If the ID does not exist or the network is unavailable, the page shows a message and **Try again**.

No API key, local server, login, or `.env` file is needed.

## Project files

- `lib/main.dart` - app and products list
- `lib/product_page.dart` - separate detail screen
- `lib/product_bloc.dart` - events, states, and BLoC
- `lib/product_api.dart`, `lib/rest_api.dart` - Dio HTTP requests
- `lib/product.dart` - product model from the teacher's example
- `lib/widgets/product_view.dart` - teacher-style product card

## Upload to GitHub

From the project folder:

```bash
git init
git add .
git commit -m "Flutter mid-term products app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Create an **empty repository** in GitHub first, then replace the example URL with your own. Do not upload `.dart_tool/`, `build/`, `.gradle/` or `android/local.properties`; these are ignored or excluded.

The project's original platform folders are included. `flutter pub get` will regenerate machine-specific files as needed.
