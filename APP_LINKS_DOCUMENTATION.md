# App Links Documentation - Foodyman

This documentation provides a comprehensive guide for App Links (Deep Links) implementation in the Foodyman application.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Technical Requirements](#technical-requirements)
3. [Platform Configuration](#platform-configuration)
4. [Code Implementation](#code-implementation)
5. [Supported Link Types](#supported-link-types)
6. [Usage Examples](#usage-examples)
7. [Error Handling](#error-handling)
8. [Testing](#testing)
9. [Best Practices](#best-practices)

## 🔍 Overview

App Links is a technology that allows users to be directed directly to specific pages of the application. In the Foodyman app, this functionality is implemented using the `app_links` package.

### Key Features:
- ✅ Support for Android and iOS platforms
- ✅ Group order link management
- ✅ Shop and product link processing
- ✅ Category link support
- ✅ Legacy link format processing

## 🛠 Technical Requirements

### Dependencies
```yaml
dependencies:
  app_links: ^6.4.1
  auto_route: ^10.1.2
```

### Flutter Version
- Flutter: 3.32.0+
- Dart SDK: >=3.8.0 <4.0.0

## 📱 Platform Configuration

### Android Configuration

#### 1. AndroidManifest.xml
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop">
    
    <!-- App link intent -->
    <meta-data
        android:name="flutter_deeplinking_enabled"
        android:value="true" />

    <intent-filter
        android:autoVerify="true"
        tools:targetApi="m">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:host="@string/deep_link_host"
            android:pathPattern="/.*"
            android:scheme="https" />
    </intent-filter>
</activity>
```

#### 2. strings.xml
```xml
<resources>
    <string name="app_name">Foodyman</string>
    <string name="deep_link_host">your-domain.com</string>
    <!-- Other strings... -->
</resources>
```

### iOS Configuration

#### Info.plist
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>Bundle ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>foodyman.org</string>
            <!-- Other schemes... -->
        </array>
    </dict>
</array>
```

## 💻 Code Implementation

### Main Service File: `app_links_service.dart`

```dart
abstract class AppLinksService {
  static late AppLinks _appLinks;
  static StreamSubscription<Uri>? _linkSubscription;

  // Initialize the service
  static Future<void> init(BuildContext context, {bool isMain = false}) async {
    _appLinks = AppLinks();
    
    // Handle initial link if app was launched from a link
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(context, initialLink);
    }

    // Listen for incoming app links
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleDeepLink(context, uri),
      onError: (err) => log("Error listening to app links: $err"),
    );
  }

  // Process deep links
  static void _handleDeepLink(BuildContext context, Uri uri) {
    final String path = uri.path;
    final Map<String, String> queryParams = uri.queryParameters;
    
    // Handle different link types...
  }

  // Create deep link
  static String createDeepLink({
    required String path,
    required Map<String, String> parameters,
  }) {
    final Uri uri = Uri(
      scheme: 'https',
      host: AppConstants.deepLinkHost,
      path: path,
      queryParameters: parameters,
    );
    return uri.toString();
  }

  // Clean up resources
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
```

### Initialization in MainPage

```dart
@override
void initState() {
  if (widget.isListen) AppLinksService.init(context, isMain: true);
  // Other initialization code...
  super.initState();
}
```

## 🔗 Supported Link Types

### 1. Group Order Links
```
https://your-domain.com/shop/123?group=cart_id&owner_id=456
https://your-domain.com/restaurant/123?g=cart_id&o=456
```

**Processing:**
- Navigate to shop page
- Pass Cart ID and Owner ID
- Activate group order functionality

### 2. Shop Links
```
https://your-domain.com/shop/123
https://your-domain.com/restaurant/123
https://your-domain.com/shop/123?product=product_id
```

**Processing:**
- Navigate to shop page
- With optional product ID
- Display specific shop

### 3. Product Links
```
https://your-domain.com/?product_id=123&shop_id=456
```

**Processing:**
- Navigate to shop page
- Display specific product
- Pass shop and product information

### 4. Category Links
```
https://your-domain.com/?category_id=123&shop_id=456
```

**Processing:**
- Navigate to category page (to be implemented in future)
- Display specific category

### 5. Legacy Links
```
https://your-domain.com/?shop_id=123
```

**Processing:**
- Support old format links
- Convert to new format

## 📝 Usage Examples

### 1. Creating Deep Links

```dart
// Create link for shop
String shopLink = AppLinksService.createDeepLink(
  path: '/shop/123',
  parameters: {},
);

// Create shop link with product
String productLink = AppLinksService.createDeepLink(
  path: '/shop/123',
  parameters: {'product': 'product_456'},
);

// Create group order link
String groupLink = AppLinksService.createDeepLink(
  path: '/shop/123',
  parameters: {
    'group': 'cart_789',
    'owner_id': '456',
  },
);
```

### 2. Sharing Links

```dart
import 'package:share_plus/share_plus.dart';

void shareShopLink(String shopId) {
  String link = AppLinksService.createDeepLink(
    path: '/shop/$shopId',
    parameters: {},
  );
  
  Share.share(
    'Check out this restaurant: $link',
    subject: 'Restaurant Recommendation',
  );
}
```

### 3. Adding Custom Link Handler

```dart
static void _handleDeepLink(BuildContext context, Uri uri) {
  final String path = uri.path;
  final Map<String, String> queryParams = uri.queryParameters;

  // Add new link type
  if (path.contains('promotion')) {
    final String? promotionId = queryParams['id'];
    if (promotionId != null) {
      context.pushRoute(PromotionRoute(promotionId: promotionId));
      return;
    }
  }

  // Existing handlers...
}
```

## ⚠️ Error Handling

### Common Issues

1. **Link not working**
   - Android: Check `autoVerify="true"`
   - iOS: Verify URL schemes are properly configured
   - Check if deep link host is correctly set

2. **Context mounted error**
   ```dart
   if (context.mounted) {
     _handleDeepLink(context, uri);
   }
   ```

3. **Stream subscription error**
   ```dart
   _linkSubscription = _appLinks.uriLinkStream.listen(
     (Uri uri) => _handleDeepLink(context, uri),
     onError: (err) {
       log("Error listening to app links: $err");
       // Handle error
     },
   );
   ```

### Debugging

```dart
// Add logs
log("Handling deep link - Path: $path, Query params: $queryParams");

// Error logs
log("Error getting initial app link: $e");
log("Error listening to app links: $err");
```

## 🧪 Testing

### 1. Android Testing

```bash
# Test using ADB
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://your-domain.com/shop/123" \
  com.your.package.name
```

### 2. iOS Testing

```bash
# Test using Simulator
xcrun simctl openurl booted "https://your-domain.com/shop/123"
```

### 3. Flutter Testing

```dart
// Unit test example
test('should create correct deep link', () {
  String link = AppLinksService.createDeepLink(
    path: '/shop/123',
    parameters: {'product': '456'},
  );
  
  expect(link, 'https://your-domain.com/shop/123?product=456');
});
```

## 🎯 Best Practices

### 1. Link Structure

- **Consistent path format**: `/shop/{id}`, `/product/{id}`
- **Query parameters**: `?group=cart_id&owner_id=123`
- **Versioning**: support `/v2/shop/{id}` format in future

### 2. Security

- **Validation**: validate all parameters
- **Authorization**: check user permissions
- **Sanitization**: sanitize inputs

### 3. Performance

- **Lazy loading**: load only necessary pages
- **Caching**: cache frequently used data
- **Error handling**: handle errors gracefully

### 4. User Experience

- **Loading states**: show loading process
- **Fallback**: provide alternative when link fails
- **Analytics**: collect link usage statistics

## 📊 Monitoring and Analytics

### Link Usage Statistics

```dart
// Add analytics event
static void _handleDeepLink(BuildContext context, Uri uri) {
  // Analytics tracking
  Analytics.track('deep_link_opened', {
    'path': uri.path,
    'query_params': uri.queryParameters,
    'timestamp': DateTime.now().toIso8601String(),
  });
  
  // Process link...
}
```

### Error Tracking

```dart
// Add error tracking
try {
  _handleDeepLink(context, uri);
} catch (e, stackTrace) {
  Crashlytics.recordError(e, stackTrace);
  log("Deep link error: $e");
}
```

## 🔄 Future Improvements

1. **Universal Links** (iOS) and **App Links** (Android) full support
2. **Dynamic Link** functionality restoration
3. **A/B testing** for link variants
4. **Deep link analytics** dashboard
5. **Link shortening** service integration

## 📞 Help and Support

If you have questions or issues:

1. **Check logs**: Use `flutter logs` command
2. **Debug mode**: Test in development mode
3. **Platform specific**: Test Android and iOS separately
4. **Documentation**: Re-read this documentation

---

**Last Updated**: 2024
**Version**: 1.0.0
**Author**: Foodyman Development Team
