<div align="center">
  <h1>💸 Smart Expense Tracker</h1>
  <p>A beautifully designed, production-level, fully offline Flutter mobile application to manage personal finances seamlessly.</p>
</div>

---

## 📸 Screenshots

<p align="center">
  <img src="assests/Screenshot%201.png" alt="Smart Expense Tracker Screenshot 1" width="350" style="border-radius: 10px; margin: 0 10px;"/>
  <img src="assests/Screenshot%202.png" alt="Smart Expense Tracker Screenshot 2" width="350" style="border-radius: 10px; margin: 0 10px;"/>
</p>

---

## ✨ Key Features

* **🛡️ Secure Local Authentication:** Simulated local login and signup using Hive. Includes validation routines to maintain data integrity.
* **📊 Comprehensive Dashboard:** Instantly view your total balance and expense trends alongside an interactive pie chart to pinpoint where your money goes.
* **💸 Seamless Core Management:** Efficiently add, review, edit, and delete expenditures. Features swipe-to-delete with confirmation alerts.
* **🎨 Premium UI / UX:** Designed leveraging Material 3 guidelines and a custom color palette, integrated with fully responsive layouts, loading shimmer-effects, animations, and transitions.
* **🌒 Dark Mode:** Full dual-mode support that persists based on user settings!
* **⚡ State Management:** Built using Flutter's dependable `Provider` for maximum UI responsiveness and efficient component rebuilding.
* **🗃️ Offline First (Hive DB):** All data is stored purely locally, providing lightning-fast reads/writes entirely without the need for an internet connection.

## 🛠️ App Architecture & Tech Stack

This project was built following industry-standard structure components, modular code techniques, and clean architecture practices:

* **Framework:** Flutter / Dart
* **State Management:** Provider (`^6.1.2`)
* **Local Storage:** Hive (`^2.2.3`), `hive_flutter`
* **UI/UX Components:** `fl_chart`, `shimmer`, `animate_do`, `google_fonts`

### Folder Structure
```text
lib/
 ┣ models/           # Hive annotated class models & generated adapters
 ┣ providers/        # Business logic containing Auth, Expenses, and Theme mechanisms
 ┣ screens/          # Every major view (Login, Splash, Dashboard, Add Expense)
 ┣ services/         # Wrappers dealing with Local Storage interaction
 ┣ utils/            # Reusable constants, validators, and App-wide Theme configs
 ┣ widgets/          # Individual atomic/standalone components (Tiles, Empty states)
 ┗ main.dart         # Flutter runner & MultiProvider execution
```

## 🚀 Getting Started

To run this application natively on your hardware, make sure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed. 

### Prerequisites

1. Clone the repository.
2. Initialize dependencies by executing:
```bash
flutter pub get
```
3. *(Optional)* Should you ever edit the Models, regenerate your Hive adapters using:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

Attach a mobile device or fire up your Android/iOS emulator and run:
```bash
flutter run
```

### Build APK

Generate a complete production-level `.apk` file ready to be installed onto devices using:
```bash
flutter build apk
```
*The output resides directly inside `build/app/outputs/flutter-apk/app-release.apk`!*

---
<div align="center">
  <sub>Built with ❤️ using Flutter. Designed for utility and speed.</sub>
</div>
