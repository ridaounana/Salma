# Love Page SaaS Platform - Installation Guide

## Quick Start Guide

### Prerequisites Checklist
- [ ] Flutter SDK (>=3.0.0) installed
- [ ] Firebase account created
- [ ] Code editor (VS Code/Android Studio) installed
- [ ] Node.js & npm installed (for deployment)

---

## Step 1: Install Flutter SDK

### Windows
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract the zip file to a location (e.g., C:\srclutter)
3. Add Flutter to PATH:
   - Search for "Edit environment variables"
   - Click "Environment Variables"
   - Under "System variables", select "Path" and click "Edit"
   - Click "New" and add path to flutterin
4. Verify installation:
   ```bash
   flutter doctor
   ```

### macOS
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/macos
2. Extract the zip file
3. Add Flutter to PATH:
   ```bash
   export PATH="$PATH:/path/to/flutter/bin"
   ```
4. Verify installation:
   ```bash
   flutter doctor
   ```

### Linux
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/linux
2. Extract the tar.xz file
3. Add Flutter to PATH:
   ```bash
   export PATH="$PATH:/path/to/flutter/bin"
   ```
4. Verify installation:
   ```bash
   flutter doctor
   ```

---

## Step 2: Clone the Repository

```bash
git clone <repository-url>
cd Salma
```

---

## Step 3: Install Dependencies

```bash
flutter pub get
```

---

## Step 4: Firebase Setup

### 4.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "love-page-saas")
4. Follow the setup wizard
5. Enable Google Analytics (optional)

### 4.2 Enable Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Click **Add new provider**
3. Select **Email/Password**
4. Click **Enable**
5. Click **Save**

### 4.3 Setup Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose a location (recommended: closest to your users)
4. Select **Start in test mode** (for development) or **Start in production mode**
5. Click **Enable**

### 4.4 Setup Storage

1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Choose default rules or custom rules
4. Click **Done**

### 4.5 Get Firebase Configuration

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll to **Your apps** section
3. Click the **Web** icon (</>)
4. Register app (no need for Firebase SDK)
5. Copy the `firebaseConfig` object
6. Update `lib/firebase_options.dart` with your configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
);
```

### 4.6 Configure Security Rules

#### Firestore Rules
In Firebase Console → Firestore Database → Rules, paste:

```javascript
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

#### Storage Rules
In Firebase Console → Storage → Rules, paste:

```javascript
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

---

## Step 5: Platform-Specific Setup

### For Web Development
No additional setup required beyond Firebase configuration.

### For Android Development

1. Download `google-services.json` from Firebase Console
   - Go to Project Settings → Your apps → Android
   - Add Android app (package name: com.example.salma_love)
   - Download `google-services.json`

2. Place `google-services.json` in `android/app/`

3. Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

4. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### For iOS Development

1. Download `GoogleService-Info.plist` from Firebase Console
   - Go to Project Settings → Your apps → iOS
   - Add iOS app (bundle ID: com.example.salmaLove)
   - Download `GoogleService-Info.plist`

2. Place `GoogleService-Info.plist` in `ios/Runner/`

3. Open `ios/Runner.xcworkspace` in Xcode
4. Add `GoogleService-Info.plist` to the project

### For macOS Development

Same steps as iOS, but place files in `macos/Runner/` and use `macos/Runner.xcworkspace`.

### For Windows Development

No additional Firebase setup required. Ensure you have:
- Visual Studio 2019 or later with "Desktop development with C++" workload
- Windows 10 or later

### For Linux Development

No additional Firebase setup required. Ensure you have:
- Clang, CMake, Ninja, and GTK development libraries
- For Ubuntu/Debian:
  ```bash
  sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
  ```

---

## Step 6: Run the Application

### Development Mode

#### Web
```bash
flutter run -d chrome
```

#### Android
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

#### iOS
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

#### macOS
```bash
flutter run -d macos
```

#### Windows
```bash
flutter run -d windows
```

#### Linux
```bash
flutter run -d linux
```

### Production Build

#### Web
```bash
flutter build web
```
Output: `build/web/`

#### Android APK
```bash
flutter build apk
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (Play Store)
```bash
flutter build appbundle
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS
```bash
flutter build ios
```
Output: Use Xcode to archive and upload

#### macOS
```bash
flutter build macos
```
Output: `build/macos/Build/Products/Release/`

#### Windows
```bash
flutter build windows
```
Output: `build/windows/runner/Release/`

#### Linux
```bash
flutter build linux
```
Output: `build/linux/x64/release/`

---

## Step 7: Deployment (Web)

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
- Select your Firebase project
- Use `build/web` as public directory
- Configure as single-page app: **Yes**
- Set up automatic builds: **No**

4. Build Flutter app:
```bash
flutter build web
```

5. Deploy to Firebase:
```bash
firebase deploy
```

6. Access your app:
```
https://<project-id>.web.app
```

### Custom Domain (Optional)

1. In Firebase Console → Hosting
2. Click **Add custom domain**
3. Enter your domain
4. Follow DNS configuration instructions
5. Wait for SSL certificate (may take up to 24 hours)

---

## Troubleshooting

### Flutter Issues

#### "flutter command not found"
- Add Flutter to PATH (see Step 1)
- Restart terminal/command prompt

#### "No devices found"
- Connect device or start emulator
- Run `flutter devices` to check available devices
- For web: `flutter config --enable-web`

#### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Try `flutter doctor` to diagnose issues

### Firebase Issues

#### "Authentication failed"
- Verify Firebase configuration in `firebase_options.dart`
- Check that Authentication is enabled in Firebase Console
- Ensure correct API keys

#### "Firestore permission denied"
- Check Firestore security rules
- Ensure user is authenticated
- Verify collection and document paths

#### "Storage upload failed"
- Check Storage security rules
- Ensure user is authenticated
- Verify file size limits

### Platform-Specific Issues

#### Android build fails
- Update Android SDK
- Check `android/build.gradle` dependencies
- Verify `google-services.json` placement

#### iOS build fails
- Update Xcode to latest version
- Check CocoaPods: `pod install` in `ios/` directory
- Verify `GoogleService-Info.plist` placement

#### Web build fails
- Ensure Flutter web is enabled: `flutter config --enable-web`
- Check Firebase web configuration
- Verify browser compatibility

---

## Additional Resources

### Official Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Documentation](https://dart.dev/guides)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Firebase Community](https://firebase.google.com/support/community)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Firebase Console](https://console.firebase.google.com/)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

---

## Support

If you encounter issues not covered in this guide:
1. Check the [DOCUMENTATION.md](DOCUMENTATION.md) for detailed technical information
2. Search existing issues on GitHub
3. Create a new issue with:
   - Platform (Web/Android/iOS/etc.)
   - Flutter version (`flutter --version`)
   - Error message or description
   - Steps to reproduce
   - Expected vs actual behavior

---

## Next Steps

After successful installation:
1. Read the [DOCUMENTATION.md](DOCUMENTATION.md) for detailed technical information
2. Explore the codebase structure
3. Run the app and test features
4. Customize as needed
5. Deploy to your preferred platform

Happy coding! ❤️
