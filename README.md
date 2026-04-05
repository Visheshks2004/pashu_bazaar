# 🐄 Pashu Bazaar - Livestock Marketplace

A Flutter application for buying and selling cows, buffaloes, oxen, and other livestock.

## 📱 Features
- User Authentication with Phone OTP
- Multi-language Support (English, Hindi, Marathi)
- Location-based Animal Listings
- Filter & Search Functionality
- Real-time Chat (WhatsApp Integration)
- Firebase Backend

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Firebase Account
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Add your Firebase configuration files
4. Run `flutter run`

## 🏗️ Project Structure
lib/
├── main.dart
├── splash_screen.dart
├── features/
│ ├── auth/
│ ├── home/
│ ├── language/
│ ├── add_listing/
│ ├── details/
│ └── profile/
├── l10n/ # Localization files
└── models/ # Data models

## 🔧 Configuration
1. Create Firebase project
2. Add Android/iOS apps in Firebase Console
3. Download config files and place in:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Update `firebase_options.dart` with your config

## 👨‍💻 Author
Vishesh Kumar

## 🤝 Contributing
Pull requests are welcome.
