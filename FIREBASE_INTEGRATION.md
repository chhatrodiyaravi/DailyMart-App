# Firebase Integration Steps

1. Configure Firebase project
   - Create a Firebase project in the Firebase Console.
   - Add Android app with package name from `android/app/src/main/AndroidManifest.xml` and download `google-services.json` into `android/app/`.
   - Add iOS app and download `GoogleService-Info.plist` into `ios/Runner`.
   - (Optional) Run `flutterfire configure` to generate `lib/firebase_options.dart` and include during initialization.

2. Dependencies
   - pubspec.yaml already includes: `firebase_core`, `firebase_auth`, `cloud_firestore`, `google_sign_in`, `firebase_storage`, `provider`, `cached_network_image`.
   - Run:

```bash
flutter pub get
```

3. Android setup
   - Ensure `android/build.gradle` contains the Google services plugin and `com.google.gms:google-services` is in `build.gradle`.
   - Ensure `android/app/google-services.json` exists.

4. iOS setup
   - Ensure `ios/Runner/Info.plist` contains required Firebase config and `GoogleService-Info.plist` is present.

5. Usage in app
   - `AuthProvider` supports email/password registration and login. It also now supports Google Sign-In via `AuthService`.
   - `FirestoreService` provides streams for `categories` and `products`. Example usage in `HomeScreen`.
   - `StorageService` provides helper to upload images to `products/{productId}/` folder in Firebase Storage.

Firestore collections suggested

- users (userId -> profile)
- categories (id, name, iconName/color or image)
- products (id, name, description, price, imageUrl, categoryId, stock, discount)
- carts (userId -> items map)
- orders (orderId documents)

Example queries

- Stream categories: `FirebaseFirestore.instance.collection('categories').snapshots()`
- Products by category: `FirebaseFirestore.instance.collection('products').where('categoryId', isEqualTo: 'catId').snapshots()`

6. Next steps
   - Update admin screens for adding/editing categories and products using `StorageService` to upload images.
   - Add Cloud Functions for order processing, promo codes, and FCM notifications.
