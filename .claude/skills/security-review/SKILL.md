---
name: security-review
description: iOS Security patterns and checklist for Vibe-Coding. Covers Keychain, CryptoKit, App Transport Security, biometrics, and avoiding common iOS vulnerabilities.
---

# iOS Security Review Skill

This skill ensures all Swift code generated during an AI-Driven Development (Vibe-Coding) session follows Apple's security best practices.

## When to Activate

- Implementing authentication, login flows, or biometrics (`LocalAuthentication`)
- Storing user preferences, tokens, or PII
- Setting up network layers and URLSessions
- Handling deep links or inter-process communication
- Writing file storage or database caching layers

## iOS Security Checklist

### 1. Secrets Management (Keychain vs UserDefaults)

#### ❌ NEVER Do This
```swift
// INSECURE: Storing tokens or passwords in UserDefaults
UserDefaults.standard.set(apiToken, forKey: "user_api_token")

// INSECURE: Hardcoded secrets
let apiKey = "sk-proj-xxxxx"
```

#### ✅ ALWAYS Do This
```swift
// SECURE: Use the Keychain for sensitive data (tokens, passwords, PII)
import Security

func saveToken(_ token: Data) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "user_api_token",
        kSecValueData as String: token,
        kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    ]
    SecItemAdd(query as CFDictionary, nil)
}
```

> **Vibe-Coding Tip**: Instruct the AI to explicitly use `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` to ensure credentials cannot be migrated to other devices or accessed while the device is locked.

### 2. File Protection (Data Protection API)

By default, files written to the iOS sandbox are protected when the device is locked, but you should enforce it explicitly for sensitive documents.

```swift
// SECURE: Enforce complete file protection
try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
```

#### Verification Step
- [ ] All database files (CoreData/SwiftData/SQLite) and cached JSON containing PII are written with `.completeFileProtection`.

### 3. Network Security (App Transport Security)

#### ❌ NEVER Do This
```xml
<!-- INSECURE: Allowing arbitrary loads bypasses ATS -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### ✅ ALWAYS Do This
- Leave `NSAppTransportSecurity` out of the `Info.plist` completely. iOS defaults to forcing HTTPS with TLS 1.2+.
- If connecting to local development servers, add explicit exceptions ONLY for `localhost`.

### 4. Cryptography 

#### ❌ NEVER Do This
- Do not use `CommonCrypto` (e.g., `CC_SHA256`) in modern Swift.
- Do not roll your own encryption algorithms.

#### ✅ ALWAYS Do This
- Use Apple's modern **`CryptoKit`**.

```swift
import CryptoKit

// Hashing
let hashed = SHA256.hash(data: inputData)

// Symmetric Encryption (ChaChaPoly)
let symmetricKey = SymmetricKey(size: .bits256)
let sealedBox = try ChaChaPoly.seal(messageData, using: symmetricKey)
```

### 5. Deep Linking and IPC Security

When handling URLs passed to the app via `onOpenURL` or universal links, always validate the payload.

```swift
// INSECURE: Blindly executing commands from deep links
.onOpenURL { url in 
    appState.deleteUser(id: url.lastPathComponent) 
}

// SECURE: Validate deep link host, path, and prompt user before destructive actions
.onOpenURL { url in
    guard url.host == "mysecureapp.com", url.path == "/action" else { return }
    // Prompt user for confirmation before acting on URL parameters
}
```

### 6. Biometric Authentication

When using FaceID/TouchID, always provide a fallback and handle errors gracefully.

```swift
import LocalAuthentication

let context = LAContext()
var error: NSError?

if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
    let reason = "Authenticate to view secure notes."
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
        DispatchQueue.main.async {
            if success {
                // Unlock successful
            } else {
                // Handle fallback (e.g., ask for App PIN)
            }
        }
    }
}
```

### 7. Avoiding Information Leakage

#### UI Privacy
When the app goes to the background, iOS takes a snapshot of the UI for the app switcher. Hide sensitive data (banking info, medical records) before this happens.

```swift
struct SecureDataView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var isBlurred = false

    var body: some View {
        DataContentView()
            .blur(radius: isBlurred ? 20 : 0)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                isBlurred = (newPhase != .active)
            }
    }
}
```

#### Print Statements
Never commit `print(userPassword)` or `print(apiToken)`. Use `os.Logger` for structured logging, which redacts data marked as private by default unless a debugger is attached.

```swift
import OSLog

let logger = Logger(subsystem: "com.myapp", category: "Auth")
logger.debug("User \(userID, privacy: .public) logged in.")
// Sensitive data (like tokens) will be redacted in production logs
logger.info("Token received: \(token, privacy: .private)")
```

## Pre-Deployment Verification

- [ ] **Keychain**: No passwords or tokens in `UserDefaults`.
- [ ] **ATS**: No `NSAllowsArbitraryLoads` in `Info.plist`.
- [ ] **UI Snapshot**: Sensitive screens blur on backgrounding.
- [ ] **CryptoKit**: Used instead of CommonCrypto.
- [ ] **Logging**: Extraneous `print()` statements removed; `os.Logger` used with `.private` masking.
- [ ] **Deep Links**: All incoming URL parameters validated.
- [ ] **Files**: `.completeFileProtection` enabled for user-generated documents.
