# sulabh_market_app
Sulabh Market is an Flutter based Hybrid app, mainly created to learn advance concepts of flutter and firebase. It is a type of Ebay App, where user can buy, sell and favourtes products. The user also have the permission to chat with the seller.

# Architectural Patterns

Patterns that recur across multiple files in the codebase.

---

## 1. Named Route Pattern

Every screen declares a `static const String screenId` that doubles as its route key.

- `lib/screens/home_screen.dart:21` — `static const String screenId = 'home_screen';`
- `lib/screens/auth/login_screen.dart` — same pattern
- All other screens in `lib/screens/**/*.dart`

All routes are registered centrally in `lib/main.dart:75-98`:

```
routes: {
  SplashScreen.screenId: (context) => const SplashScreen(),
  LoginScreen.screenId:  (context) => const LoginScreen(),
  ...
}
```

Navigate with `Navigator.pushReplacementNamed(context, LoginScreen.screenId)` or `Navigator.pushNamed(...)`. This makes routes refactor-safe and eliminates raw strings at call sites.

---

## 2. Service Layer (Firebase Abstraction)

Firebase interactions are kept out of widgets and routed through two service classes.

**`Auth` (`lib/services/auth.dart`)**
- Owns all `CollectionReference` handles: `users`, `categories`, `products`, `messages` (lines 21-27).
- Handles all `FirebaseAuth` operations: email/password sign-in, phone OTP, Google Sign-In, registration.
- Other services borrow its collection references rather than instantiating their own.

**`UserService` (`lib/services/user.dart`)**
- Composes `Auth` via `Auth authService = Auth()` (line 10).
- Exposes higher-level CRUD: user data, seller data, product CRUD, favourites, chat room management.
- Widgets instantiate `UserService firebaseUser = UserService()` locally (not injected).

Pattern: widgets call `firebaseUser.someMethod(context, ...)` and pass `BuildContext` for snackbars/dialogs. The service handles Firestore and delegates UI feedback to `constants/widgets.dart` helpers.

---

## 3. Provider State Management

Two `ChangeNotifier` providers are registered globally in `lib/main.dart:47-55` via `MultiProvider`.

| Provider | Holds |
|---|---|
| `CategoryProvider` (`lib/provider/category_provider.dart`) | Selected category/subcategory, uploaded image URLs, multi-step form data, user details snapshot |
| `ProductProvider` (`lib/provider/product_provider.dart`) | Currently viewed `DocumentSnapshot` for product and seller |

**Consume** with `Provider.of<CategoryProvider>(context)` or `context.read/watch`. Providers call `notifyListeners()` after every mutation.

`CategoryProvider` also holds a `UserService` instance and calls `getUserData()` to populate `userDetails` — services are composed inside providers, not injected.

---

## 4. Firestore Data Access via FutureBuilder / StreamBuilder

Widgets fetch Firestore data directly using `FutureBuilder<DocumentSnapshot>` or stream-based `StreamBuilder`. There is no repository layer caching results.

- `lib/screens/home_screen.dart:81-112` — `FutureBuilder` for user address
- `lib/screens/product/product_details_screen.dart` — `FutureBuilder` for product + seller details
- `lib/screens/chat/chat_stream.dart` — `StreamBuilder` for real-time chat messages

Firestore calls go through `UserService` methods that return `Future<DocumentSnapshot>` or `Stream`.

---

## 5. Shared Widget Helper Functions

`lib/constants/widgets.dart` exports top-level functions (not a class) used across the entire app for consistent UI feedback:

| Function | Use |
|---|---|
| `loadingDialogBox(context, message)` | Non-dismissible progress dialog |
| `customSnackBar({context, content})` | Black snackbar with white text |
| `roundedButton({...})` | Styled `ElevatedButton` with border radius 18 |
| `wrongDetailsAlertBox(text, context)` | Error alert dialog |
| `openBottomSheet({context, child, ...})` | Scrollable modal bottom sheet |
| `customPopUpMenu({context, chatroomId})` | Three-dot menu for chat actions |

These helpers accept `BuildContext` and are called directly from both screens and services.

---

## 6. Firestore Collection Structure

Based on `lib/services/auth.dart:21-27` and `lib/services/user.dart`:

```
users/{uid}           — name, email, mobile, address, state, city, country, user_img, location (GeoPoint)
products/{productId}  — title, description, category, subcategory, price, postDate, status, favourites[]
categories/{id}       — (subcategory tree, read by CategoryProvider)
messages/{chatroomId} — chatroomId, lastChat, lastChatTime, read
  └── chats/{msgId}   — message, sent_by, time
```

---

## 7. Deep Linking

`lib/main.dart:103-122` handles `sulabhmarketapp://product?productId=<id>` deep links via `uni_links`. The `initDeepLinks()` function is called before `runApp`. Sharing is done via `lib/global_var.dart` using `share_plus`.

---

## 8. Multi-Step Listing Flow

Selling a product is a multi-step flow managed through `CategoryProvider`:

1. `CategoryListScreen` → sets category
2. `SubCategoryScreen` → sets subcategory
3. `SellCarForm` / `CommonForm` → collects form fields, stores in `formData`
4. `UserFormReview` → final review before Firestore write

State (category, subcategory, form data, uploaded image URLs) is accumulated in `CategoryProvider` and cleared via `clearData()` after submission.
