# Love Page SaaS Platform - Complete Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technical Architecture](#technical-architecture)
4. [Installation Guide](#installation-guide)
5. [Configuration](#configuration)
6. [Development Guide](#development-guide)
7. [Deployment Guide](#deployment-guide)
8. [API Reference](#api-reference)
9. [Troubleshooting](#troubleshooting)
10. [Contributing](#contributing)

---

## Project Overview

The Love Page SaaS Platform is a Flutter-based application that allows users to create personalized love pages for their significant others. Each page includes countdown timers, sweet messages, photo galleries, and customizable themes.

### Key Information
- **Project Name**: salma_love
- **Version**: 1.0.0+1
- **Platform**: Flutter (Web, Android, iOS, macOS, Windows, Linux)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **Language**: Dart (>=3.0.0)

---

## Features

### User Features
1. **Authentication**
   - Email/Password Sign Up
   - Email/Password Sign In
   - Password Reset
   - Secure Session Management

2. **Page Management**
   - Create personalized love pages
   - Edit existing pages
   - Delete pages
   - View all pages in dashboard

3. **Page Customization**
   - Partner's name
   - Anniversary date with countdown timer
   - Custom love messages
   - Photo uploads (multiple images)
   - Color themes (4 predefined themes)
   - Multi-language support (English, French, Arabic with RTL)

4. **Sharing**
   - Unique URL for each page
   - Easy link copying
   - Public page viewing (no authentication required)

### Technical Features
1. **Backend Services**
   - Firebase Authentication
   - Firestore Database
   - Firebase Storage
   - Real-time data synchronization

2. **State Management**
   - Provider pattern for authentication state
   - Local state for UI components

3. **Image Handling**
   - Image picker (gallery/camera)
   - Automatic image compression
   - Cloud storage upload
   - CDN delivery

---

## Technical Architecture

### Project Structure
```
lib/
├── auth/                      # Authentication module
│   ├── login_page.dart       # Login UI and logic
│   └── signup_page.dart      # Sign up UI and logic
├── dashboard/                 # Dashboard module
│   ├── dashboard_page.dart   # Main dashboard with page list
│   └── create_page_page.dart # Page creation form
├── providers/                 # State management
│   └── auth_provider.dart    # Authentication state provider
├── services/                  # Backend services
│   ├── auth_service.dart     # Firebase Auth wrapper
│   ├── page_service.dart     # Firestore operations
│   └── storage_service.dart  # Firebase Storage operations
├── viewer/                    # Page viewing module
│   └── page_viewer.dart      # Public page viewer
├── firebase_options.dart      # Firebase configuration
└── main.dart                 # Application entry point
```

### Data Models

#### Page Document Structure
```json
{
  "pageId": "string (UUID)",
  "userId": "string (Firebase Auth UID)",
  "partnerName": "string",
  "anniversaryDate": "string (ISO 8601)",
  "primaryColor": "string (hex)",
  "secondaryColor": "string (hex)",
  "messages": ["string"],
  "imageUrls": ["string"],
  "language": "string (en/fr/ar)",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp",
  "shareUrl": "string"
}
```

### Service Layer

#### AuthService
Handles all Firebase Authentication operations:
- `signUpWithEmailAndPassword()`: Create new user
- `signInWithEmailAndPassword()`: Authenticate user
- `signOut()`: End user session
- `resetPassword()`: Send password reset email

#### PageService
Manages Firestore operations:
- `createPage()`: Create new love page
- `getPage()`: Retrieve page by ID
- `getUserPages()`: Get all pages for current user
- `updatePage()`: Update existing page
- `deletePage()`: Remove page

#### StorageService
Handles Firebase Storage operations:
- `pickImageFromGallery()`: Select image from device
- `pickImageFromCamera()`: Capture new photo
- `uploadPageImages()`: Upload multiple images
- `deleteImage()`: Remove image from storage

### State Management

#### AuthProvider
Manages authentication state using Provider pattern:
- `currentUser`: Current authenticated user
- `isAuthenticated`: Boolean auth status
- `signIn()`: Sign in action
- `signUp()`: Sign up action
- `signOut()`: Sign out action

---

## Installation Guide

### Prerequisites

1. **Flutter SDK** (>=3.0.0)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Firebase Account**
   - Create account at: https://console.firebase.google.com/
   - Enable required services (see Configuration section)

3. **Code Editor**
   - VS Code (recommended) with Flutter extension
   - Android Studio with Flutter plugin
   - IntelliJ IDEA with Flutter plugin

4. **Node.js & npm** (for Firebase deployment)
   - Download from: https://nodejs.org/

### Step-by-Step Installation

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd Salma
```

#### 2. Install Flutter Dependencies
```bash
flutter pub get
```

#### 3. Firebase Setup

##### a. Create Firebase Project
1. Go to Firebase Console
2. Click "Add project"
3. Follow the setup wizard
4. Enable Google Analytics (optional)

##### b. Enable Authentication
1. Go to Authentication → Sign-in method
2. Enable "Email/Password" provider
3. Click Save

##### c. Setup Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Choose a location (recommended: closest to users)
4. Start in test mode or production mode
5. Apply security rules (see Configuration section)

##### d. Setup Storage
1. Go to Storage
2. Click "Get started"
3. Choose default rules or custom rules
4. Click "Done"

##### e. Get Firebase Configuration
1. Go to Project Settings
2. Scroll to "Your apps" section
3. Click "Web" icon (</>)
4. Register app (no need for Firebase SDK)
5. Copy the `firebaseConfig` object
6. Update `lib/firebase_options.dart` with your configuration

#### 4. Platform-Specific Setup

##### For Web
No additional setup required beyond Firebase configuration.

##### For Android
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`
3. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```
4. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

##### For iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/`
3. Add to Xcode project

##### For macOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `macos/Runner/`
3. Add to Xcode project

#### 5. Run the Application

##### Development Mode
```bash
# For Web
flutter run -d chrome

# For Android
flutter run -d <device-id>

# For iOS
flutter run -d <device-id>

# For macOS
flutter run -d macos

# For Windows
flutter run -d windows

# For Linux
flutter run -d linux
```

##### Production Build
```bash
# Web
flutter build web

# Android
flutter build apk

# iOS
flutter build ios

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
```

---

## Configuration

### Firebase Security Rules

#### Firestore Rules
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

### Environment Variables

Update `lib/firebase_options.dart` with your Firebase configuration:

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

### Customization

#### Adding New Color Themes
Edit `lib/dashboard/create_page_page.dart` and add to the `_buildColorOption` calls:

```dart
_buildColorOption('#FF9A9E', '#FECFEF'),  // Pink
_buildColorOption('#A18CD1', '#FBC2EB'),  // Purple
_buildColorOption('#84FAB0', '#8FD3F4'),  // Green
_buildColorOption('#FFD194', '#D1913C'),  // Orange
// Add your theme here
_buildColorOption('#YOUR_COLOR_1', '#YOUR_COLOR_2'),
```

#### Adding New Languages
1. Add language code to dropdown in `create_page_page.dart`:
```dart
DropdownMenuItem(value: 'es', child: Text('Español')),
```

2. Add translations to page data structure
3. Implement RTL support if needed (for Arabic, Hebrew, etc.)

---

## Development Guide

### Code Style
- Follow Dart effective guidelines
- Use `flutter analyze` to check for issues
- Format code with `dart format`

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Debugging
- Use Flutter DevTools for debugging
- Enable debug mode in `main.dart`:
```dart
MaterialApp(
  debugShowCheckedModeBanner: true,
  // ...
)
```

### Common Development Tasks

#### Adding New Features
1. Create service method in appropriate service file
2. Update UI components
3. Test thoroughly
4. Update documentation

#### Modifying Database Schema
1. Update data models
2. Migrate existing data if needed
3. Update security rules
4. Test with sample data

---

## Deployment Guide

### Firebase Hosting (Web)

#### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### 2. Login to Firebase
```bash
firebase login
```

#### 3. Initialize Firebase Hosting
```bash
firebase init hosting
```
- Select your Firebase project
- Use `build/web` as public directory
- Configure as single-page app (yes)
- Set up automatic builds (no)

#### 4. Build Flutter App
```bash
flutter build web
```

#### 5. Deploy
```bash
firebase deploy
```

#### 6. Custom Domain (Optional)
1. Go to Firebase Console → Hosting
2. Click "Add custom domain"
3. Follow DNS configuration instructions

### App Store Deployment

#### Google Play Store (Android)
1. Generate signed APK/AAB
2. Create Play Console account
3. Create app listing
4. Upload APK/AAB
5. Complete store listing
6. Submit for review

#### Apple App Store (iOS)
1. Generate IPA file
2. Create App Store Connect account
3. Create app record
4. Upload via Xcode or Transporter
5. Complete store listing
6. Submit for review

---

## API Reference

### AuthService Methods

#### signUpWithEmailAndPassword
```dart
Future<UserCredential?> signUpWithEmailAndPassword({
  required String email,
  required String password,
})
```
Creates a new user account with email and password.

**Parameters:**
- `email`: User's email address
- `password`: User's password (min 6 characters)

**Returns:** `UserCredential` or `null`

**Throws:** `FirebaseAuthException` on failure

#### signInWithEmailAndPassword
```dart
Future<UserCredential?> signInWithEmailAndPassword({
  required String email,
  required String password,
})
```
Signs in an existing user with email and password.

**Parameters:**
- `email`: User's email address
- `password`: User's password

**Returns:** `UserCredential` or `null`

**Throws:** `FirebaseAuthException` on failure

#### signOut
```dart
Future<void> signOut()
```
Signs out the current user.

#### resetPassword
```dart
Future<void> resetPassword(String email)
```
Sends a password reset email to the user.

**Parameters:**
- `email`: User's email address

### PageService Methods

#### createPage
```dart
Future<String> createPage({
  required String partnerName,
  required String anniversaryDate,
  required String primaryColor,
  required String secondaryColor,
  required List<String> messages,
  required List<String> imageUrls,
  required String language,
})
```
Creates a new love page.

**Parameters:**
- `partnerName`: Name of the partner
- `anniversaryDate`: Anniversary date (ISO 8601 format)
- `primaryColor`: Primary theme color (hex)
- `secondaryColor`: Secondary theme color (hex)
- `messages`: List of love messages
- `imageUrls`: List of image URLs
- `language`: Language code (en/fr/ar)

**Returns:** Page ID (UUID)

**Throws:** Exception on failure

#### getPage
```dart
Future<Map<String, dynamic>?> getPage(String pageId)
```
Retrieves a page by its ID.

**Parameters:**
- `pageId`: Page ID to retrieve

**Returns:** Page data as `Map<String, dynamic>` or `null`

#### getUserPages
```dart
Future<List<Map<String, dynamic>>> getUserPages()
```
Retrieves all pages for the current authenticated user.

**Returns:** List of page data, sorted by creation date (newest first)

#### updatePage
```dart
Future<void> updatePage({
  required String pageId,
  String? partnerName,
  String? anniversaryDate,
  String? primaryColor,
  String? secondaryColor,
  List<String>? messages,
  List<String>? imageUrls,
  String? language,
})
```
Updates an existing page. All parameters except `pageId` are optional.

**Parameters:**
- `pageId`: Page ID to update
- Other parameters: Same as `createPage`, all optional

**Throws:** Exception on failure

#### deletePage
```dart
Future<void> deletePage(String pageId)
```
Deletes a page by its ID.

**Parameters:**
- `pageId`: Page ID to delete

**Throws:** Exception on failure

### StorageService Methods

#### pickImageFromGallery
```dart
Future<XFile?> pickImageFromGallery()
```
Opens image picker to select an image from gallery.

**Returns:** Selected image as `XFile` or `null`

#### pickImageFromCamera
```dart
Future<XFile?> pickImageFromCamera()
```
Opens camera to capture a new image.

**Returns:** Captured image as `XFile` or `null`

#### uploadPageImages
```dart
Future<List<String>> uploadPageImages(List<XFile> imageFiles)
```
Uploads multiple images to Firebase Storage.

**Parameters:**
- `imageFiles`: List of images to upload

**Returns:** List of download URLs

#### deleteImage
```dart
Future<void> deleteImage(String imageUrl)
```
Deletes an image from Firebase Storage.

**Parameters:**
- `imageUrl`: URL of the image to delete

---

## Troubleshooting

### Common Issues

#### 1. Firebase Initialization Failed
**Problem:** App crashes on startup with Firebase error.

**Solution:**
- Verify Firebase configuration in `firebase_options.dart`
- Check that Firebase project is properly set up
- Ensure all required services are enabled

#### 2. Authentication Errors
**Problem:** Users cannot sign in or sign up.

**Solution:**
- Check Firebase Console Authentication settings
- Verify Email/Password provider is enabled
- Check network connectivity
- Review error messages in console

#### 3. Image Upload Fails
**Problem:** Images fail to upload to Firebase Storage.

**Solution:**
- Check Storage security rules
- Verify user is authenticated
- Check file size limits
- Ensure Storage bucket is properly configured

#### 4. Countdown Shows Zero
**Problem:** Anniversary countdown displays all zeros.

**Solution:**
- Verify anniversary date format (ISO 8601)
- Check date parsing in page viewer
- Ensure date is in the future

#### 5. Messages Not Displaying
**Problem:** Custom messages or default messages don't appear.

**Solution:**
- Check messages array in Firestore
- Verify page data structure
- Check console for errors
- Ensure page viewer properly handles empty messages

### Debug Mode

Enable detailed logging in development:

```dart
void main() {
  runApp(const LovePageSaaS());
}

// In debug mode, print more details
bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
```

### Performance Optimization

#### Reduce Image Sizes
- Compress images before upload
- Use appropriate image formats (WebP recommended)
- Implement lazy loading for image galleries

#### Optimize Firestore Queries
- Use indexes for frequently queried fields
- Limit query results with pagination
- Cache frequently accessed data

---

## Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Review Guidelines
- Follow existing code style
- Add comments for complex logic
- Update documentation
- Include tests for new features
- Ensure all tests pass

### Reporting Issues
- Use GitHub Issues
- Provide detailed description
- Include steps to reproduce
- Add screenshots if applicable
- Specify environment details

---

## License

This project is licensed under the MIT License.

## Support

For support and questions:
- Create an issue on GitHub
- Email: support@example.com
- Documentation: [Link to docs]

## Changelog

### Version 1.0.0 (Current)
- Initial release
- User authentication
- Page creation and management
- Image upload functionality
- Multi-language support
- Countdown timer
- Custom messages
- Color themes
- Sharing functionality
