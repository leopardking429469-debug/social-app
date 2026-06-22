# Social App - Instagram/TikTok Style Social Network

A Flutter application with Instagram/TikTok-style features including user search, profile viewing, and real-time profile view notifications.

## ✨ Features

- 🔍 **User Search & Discovery**
  - Search accounts by username
  - Search by email
  - Search by bio/description
  - Browse trending users
  - Discover new accounts

- 👤 **User Profiles**
  - View user profiles with bio and follower count
  - Profile picture support
  - Followers/Following stats

- 🔔 **Profile View Notifications** (TikTok-style)
  - Get notified when someone views your profile
  - Shows "@username viewed your profile"
  - Real-time notification updates
  - Mark notifications as read

- 🔥 **Real-time Updates**
  - Firebase Firestore integration
  - Live notification streaming
  - Instant profile view tracking

- 🔐 **Authentication**
  - Firebase Authentication
  - Email/Password signup and login
  - Secure user sessions

## 📁 Project Structure

```
lib/
├── models/
│   ├── user_model.dart           # User data model
│   └── notification_model.dart   # Notification data model
├── screens/
│   ├── search/
│   │   └── search_screen.dart    # User search & discovery
│   ├── profile/
│   │   └── user_profile_screen.dart  # Profile view with notifications
│   └── notifications/
│       └── notifications_screen.dart # Notifications display
├── services/
│   ├── auth_service.dart         # Firebase authentication
│   ├── firebase_service.dart     # Firestore operations
│   ├── search_service.dart       # User search queries
│   └── notification_service.dart # Push notifications
├── widgets/
│   ├── notification_card.dart    # Notification UI component
│   └── profile_header.dart       # Profile header widget
├── main.dart                      # App entry point
└── firebase_options.dart         # Firebase configuration
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Firebase Account
- Dart SDK

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/leopardking429469-debug/social-app.git
cd social-app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure Firebase:**
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com)
   - Enable Authentication (Email/Password)
   - Create a Firestore database
   - Download configuration files:
     - `google-services.json` (Android) → `android/app/`
     - `GoogleService-Info.plist` (iOS) → `ios/Runner/`
   - Update `lib/firebase_options.dart` with your Firebase credentials

4. **Set up Firestore Database:**
   - Create collections: `users`, `notifications`, `profile_views`
   - Set appropriate security rules

5. **Run the app:**
```bash
flutter run
```

## 📱 Usage

### Search & Discover Users
- Navigate to the Search tab
- Search by username, email, or bio
- View trending users
- Tap on any user to view their profile

### View Profile
- Profiles display user info, followers, and bio
- When you view someone's profile, they get a notification
- See who has viewed your profile
- Follow/Message buttons (when implemented)

### Notifications
- Real-time profile view notifications
- View all notifications in the Notifications tab
- Mark notifications as read
- Each notification shows who and when

## 🔧 Configuration

### Firebase Security Rules

**Firestore Rules:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.uid;
    }
    match /notifications/{document=**} {
      allow read: if request.auth.uid == resource.data.userId;
      allow write: if request.auth != null;
    }
    match /profile_views/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 📦 Dependencies

- **firebase_core** - Firebase initialization
- **firebase_auth** - User authentication
- **cloud_firestore** - Database
- **firebase_messaging** - Push notifications
- **provider** - State management
- **cached_network_image** - Image caching
- **timeago** - Time formatting

## 🎯 Roadmap

- [ ] User authentication screens (Login/Signup)
- [ ] Edit profile functionality
- [ ] Follow/Unfollow system
- [ ] Direct messaging
- [ ] Feed with posts
- [ ] Like/Comment on posts
- [ ] Stories feature
- [ ] Image upload to Firebase Storage
- [ ] Dark mode support
- [ ] Push notifications with FCM

## 📝 API Endpoints

### Services

**SearchService**
- `searchUsersByUsername(query)` - Search by username
- `searchUsersByEmail(query)` - Search by email
- `searchUsersByBio(query)` - Search by bio
- `getAllUsers(limit)` - Get all users
- `getTrendingUsers(limit)` - Get trending users

**FirebaseService**
- `recordProfileView(viewedUserId, viewerUserId, viewerUsername)` - Track profile view
- `getUserNotifications(userId)` - Stream of user notifications
- `getUserData(uid)` - Fetch user profile data
- `updateUserProfile(uid, data)` - Update user info

**AuthService**
- `signUp(email, password, username)` - Create account
- `signIn(email, password)` - Login
- `signOut()` - Logout
- `authStateChanges()` - Listen to auth state

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and enhancement requests.

## 📄 License

This project is open source and available under the MIT License.

## 📧 Support

For issues or questions, please open an issue on GitHub or contact the developers.

---

Built with ❤️ using Flutter & Firebase
