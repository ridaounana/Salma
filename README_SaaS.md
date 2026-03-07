# Love Page SaaS Platform

A platform that allows users to create personalized love pages for their significant others, complete with countdown timers, sweet messages, and custom themes.

## 🚀 Features

- **User Authentication**: Secure sign-up and login using Firebase Authentication
- **Page Customization**: Create personalized love pages with:
  - Partner's name
  - Anniversary countdown timer
  - Custom love messages
  - Photo uploads
  - Multiple color themes
  - Multi-language support (English, French, Arabic)
- **Dashboard**: Manage all your love pages in one place
- **Shareable Pages**: Each page gets a unique URL for easy sharing
- **Responsive Design**: Works beautifully on all devices

## 📋 Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase account
- A code editor (VS Code, Android Studio, etc.)

## 🔧 Setup Instructions

### 1. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable the following services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage

4. Get your Firebase configuration:
   - Go to Project Settings
   - Add a Web App
   - Copy the firebaseConfig object

5. Update `lib/firebase_options.dart` with your Firebase configuration

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

For development:
```bash
flutter run
```

For web build:
```bash
flutter build web
```

## 📁 Project Structure

```
lib/
├── auth/                  # Authentication pages
│   ├── login_page.dart
│   └── signup_page.dart
├── dashboard/             # Dashboard and page management
│   ├── dashboard_page.dart
│   └── create_page_page.dart
├── providers/             # State management
│   └── auth_provider.dart
├── services/              # Backend services
│   ├── auth_service.dart
│   ├── page_service.dart
│   └── storage_service.dart
├── viewer/                # Page viewer
│   └── page_viewer.dart
├── firebase_options.dart  # Firebase configuration
└── main_saaS.dart         # App entry point
```

## 🔐 Firebase Security Rules

### Firestore Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /pages/{pageId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

### Storage Rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 🎨 Customization

### Adding New Color Themes

Edit `lib/dashboard/create_page_page.dart` and add new color pairs to the `_buildColorOption` calls.

### Adding New Languages

1. Add the language code to the dropdown in `create_page_page.dart`
2. Add translations to your page data structure
3. Implement RTL support if needed

## 📱 Deployment

### Firebase Hosting

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Initialize Firebase Hosting:
```bash
firebase init hosting
```

4. Build your Flutter app:
```bash
flutter build web
```

5. Deploy:
```bash
firebase deploy
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## ❤️ Credits

Created with love for Salma ❤️
