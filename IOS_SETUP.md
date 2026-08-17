# iOS Release Setup Guide 🍎

Currently, iOS builds are **disabled** or optional. If you decide to
publish to the App Store, you must configure the following **GitHub
Secrets**.

## Required Secrets (Organization or Repo Level)

* **`IOS_P12_BASE64`**: Your Apple Distribution Certificate (.p12).
* **`IOS_CERTIFICATE_PASSWORD`**: The password for the .p12 file
  (plain text password).
* **`IOS_MOBILEPROVISION_BASE64`**: Provisioning Profile
  (.mobileprovision).
* **`IOS_GOOGLE_SERVICE_INFO_PLIST`**: Firebase Config (if using
  Firebase).

### How to Generate (PowerShell)

```powershell
# IOS_P12_BASE64
$bytes = [IO.File]::ReadAllBytes("path\to\dist.p12")
[Convert]::ToBase64String($bytes)

# IOS_MOBILEPROVISION_BASE64
$bytes = [IO.File]::ReadAllBytes("path\to\app.mobileprovision")
[Convert]::ToBase64String($bytes)

# IOS_GOOGLE_SERVICE_INFO_PLIST
$bytes = [IO.File]::ReadAllBytes("ios\Runner\GoogleService-Info.plist")
[Convert]::ToBase64String($bytes)
```

## How to Enable

1. Add the secrets above to `GitHub Settings > Secrets > Actions`.
2. Enable the **iOS Workflow**:
   * Ensure `.github/workflows/release-ios.yml` exists.
   * Or add `build-type: ios` to your build workflow inputs.
