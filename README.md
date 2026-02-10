# Juvo Customer app 

Juvo is a multi store marketplace.

## Requirements
*  Flutter SDK setup (version 3.24.0 Stable)
*  Java setup (version 23)
*  Gradle (version 8.10)
*  JDK with path setup (only for vs code)
*  Xcode for IPA file build
*  State management -> riverpod

## Default Setup
Run an existing flutter project on IDE

#### Change App Logo

You can generate app icon using this website https://icon.kitchen
* Then go to /android/app/src/main/resand replace all mipmap folder with your /android folder
*  Again go to /ios/Runner and replace Assets.xcassets with your generated Assets.xcassets folder

#### Change App Name

1. Change the value of label from/android/app/src/main/AndroidManifest.xml
 `android:label="My App"`
2. Change the value of CFBundleName from /iOS/Runner/info.plist
 `<key>CFBundleName</key><string>My App</string>`

## Change Base URL

Please do NOT put slash ( / ) at the end of your base url. Use your admin url as base url. First you have to install your admin panel. For example: If your admin url is https://admin.your_domain.com base url will be https://your_domain.com. Open `/lib/app_constants.dart` and replace baseUrl variable value with your own URL.

`static const String baseUrl='https://your_domain.com'`


## Building & Release (CI/CD)

The project uses GitHub Actions for automated builds and releases. To enable signed builds, you must configure the following **Secrets** in your repository settings (`Settings > Secrets and variables > Actions`).

### 🔑 Required Secrets

#### 🤖 Android Secrets
*   `GOOGLE_SERVICES_JSON`: The **Base64 encoded** content of your `android/app/google-services.json`.
*   `KEY_JKS`: The **Base64 encoded** content of your release keystore file (`.jks`).
*   `KEY_PASSWORD`: The password for your keystore.
*   `ALIAS_PASSWORD`: The password for your key alias.
*   `PRODUCTION_ENV`: The **Base64 encoded** content of your `.env/production.env` file.

#### 🍎 iOS Secrets
*   `IOS_GOOGLE_SERVICE_INFO_PLIST`: The **Base64 encoded** content of `ios/Runner/GoogleService-Info.plist`.
*   `IOS_P12_BASE64`: The **Base64 encoded** `.p12` export of your Apple Distribution Certificate.
*   `IOS_MOBILEPROVISION_BASE64`: The **Base64 encoded** `.mobileprovision` file for your app.
*   `IOS_CERTIFICATE_PASSWORD`: The password used when exporting the `.p12` certificate.

---

### 🛠️ How to Encode Files
To provide the file contents as secrets, you must encode them to Base64 first. Use the following commands from the **root of your repository**:

**macOS/Linux:**
```bash
# For Android
base64 -i android/app/google-services.json | pbcopy

# For iOS
base64 -i ios/Runner/GoogleService-Info.plist | pbcopy

# For Production Environment
base64 -i .env/production.env | pbcopy
```

**Windows (PowerShell):**
```powershell
# For Android
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/google-services.json")) | clip

# For iOS
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ios/Runner/GoogleService-Info.plist")) | clip

# For Production Environment
[Convert]::ToBase64String([IO.File]::ReadAllBytes(".env/production.env")) | clip
```

Paste the resulting string into the corresponding GitHub Secret value.

### 🏗️ Multi-Tenant Build Support (build_* branches)
You can trigger dynamic builds for specific clients by creating a branch following the `build_<client>-*` pattern (e.g., `build_clientname-v1.0`).

The workflow will automatically look for client-specific secrets:
*   `GOOGLE_SERVICES_JSON_<CLIENT>`
*   `IOS_GOOGLE_SERVICE_INFO_PLIST_<CLIENT>`
*   `PRODUCTION_ENV_<CLIENT>`

If found, these will take precedence over the default secrets. The release candidate will also be tagged with the client suffix (e.g., `v1.0.0-clientname`).

### 📦 Change App Package

Firstly, find out the existing package name. You can find it out from top of `/app/src/main/AndroidManifest.xml` file. Then right click on project folder from android studio and click on **Replace in Path**. You will see a popup window with two input boxes. In first box you have to put existing package name that you saw in `AndroidManifest.xml` file previously and then write down your preferred package name in second box and then click on **Replace All** button.

