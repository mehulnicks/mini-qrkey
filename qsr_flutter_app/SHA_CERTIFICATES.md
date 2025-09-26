# SHA Certificate Fingerprints for QSR Flutter App

## Generated on: September 26, 2025

### Debug Certificate (for development)
**Alias:** androiddebugkey
**Keystore:** ~/.android/debug.keystore (default Android debug keystore)
**Valid from:** Mon Sep 15 10:58:55 IST 2025 until Wed Sep 08 10:58:55 IST 2055

**SHA1 Fingerprint:** 
```
4A:2E:BD:6C:41:5D:78:0C:E1:FB:E4:90:6E:6E:33:13:68:E0:49:C3
```

**SHA256 Fingerprint:**
```
26:69:BD:6F:F6:93:10:97:CE:DC:BF:24:29:53:98:32:6C:48:05:25:AE:F7:ED:E7:5A:DF:FF:FA:AC:22:87:3E
```

## How to Add These to Firebase Console

### Step 1: Go to Firebase Console
1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Select your QSR Flutter App project

### Step 2: Add SHA Fingerprints
1. Go to **Project Settings** (gear icon)
2. Select your Android app under "Your apps"
3. Scroll down to "SHA certificate fingerprints"
4. Click "Add fingerprint"
5. Add the SHA1 fingerprint: `4A:2E:BD:6C:41:5D:78:0C:E1:FB:E4:90:6E:6E:33:13:68:E0:49:C3`
6. Click "Add fingerprint" again
7. Add the SHA256 fingerprint: `26:69:BD:6F:F6:93:10:97:CE:DC:BF:24:29:53:98:32:6C:48:05:25:AE:F7:ED:E7:5A:DF:FF:FA:AC:22:87:3E`

### Step 3: Download Updated google-services.json
1. After adding the fingerprints, download the updated `google-services.json`
2. Replace the existing file in `android/app/google-services.json`

### Step 4: Enable Google Sign-In
1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Google** as a sign-in provider
3. Add your support email address

## For Production Release

When you create a release build, you'll need to:

1. **Create a release keystore:**
   ```bash
   keytool -genkey -v -keystore ~/release-key.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Get the release SHA fingerprints:**
   ```bash
   "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -list -v -alias release -keystore ~/release-key.keystore
   ```

3. **Add release SHA fingerprints to Firebase Console** (same process as above)

## Current Status
✅ Debug SHA fingerprints generated
✅ Ready to add to Firebase Console
⏳ Waiting for Firebase Console configuration
⏳ Production keystore (create when ready for release)

## Notes
- These fingerprints are specific to your development environment
- The debug keystore is automatically created by Flutter/Android SDK
- Each developer working on the project may have different debug fingerprints
- For production, use a secure release keystore and store it safely

## Commands Used
```bash
# Command to generate debug SHA fingerprints:
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
```
