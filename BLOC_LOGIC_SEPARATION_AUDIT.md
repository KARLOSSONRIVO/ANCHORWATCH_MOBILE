# 🏗️ BLoC Logic Separation Audit & Recommendations

**Date:** October 18, 2025  
**Project:** ANCHORWATCH_MOBILE  
**Branch:** will_oct12  
**Focus:** Identifying business logic that should be moved from screens to BLoCs

---

## 📋 Executive Summary

After analyzing all screens and BLoCs, I found that **your architecture is already quite good!** Most business logic is properly separated into BLoCs. However, there are **8 areas** where logic could be improved or moved from UI to BLoC layer.

---

## ✅ What's Already Good

### **Properly Separated:**
- ✅ **Authentication logic** - All in `AuthenticationBloc`
- ✅ **Alerts filtering & pagination** - All in `AlertsBloc`
- ✅ **Dashboard data loading** - All in `DashboardBloc`
- ✅ **AnchorWise chat logic** - All in `AnchorWiseBloc`
- ✅ **Profile loading** - All in `ProfileBloc`
- ✅ **Password reset flow** - All in `PasswordResetBloc`
- ✅ **Signup validation** - All in `SignUpBloc`
- ✅ **FAQ expand/collapse logic** - All in `FaqBloc`

---

## ⚠️ Areas for Improvement

### **1. Form Validation Logic in UI** (LOW PRIORITY)

**Current Issue:** Form validators are inline in screens

**Files Affected:**
- `login_screen.dart` - Username/password validation
- `signup_screen.dart` - All field validations
- `change_username_screen.dart` - Username validation with regex
- `change_password_screen.dart` - Password validation
- `change_email_screen.dart` - Email validation with regex

**Example (change_username_screen.dart lines 175-190):**
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a username';
  }
  if (value.length < 3) {
    return 'Username must be at least 3 characters';
  }
  if (value.length > 30) {
    return 'Username cannot exceed 30 characters';
  }
  final regex = RegExp(r'^[a-zA-Z0-9_]+$');
  if (!regex.hasMatch(value)) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  return null;
},
```

**Recommendation:**
Move validation logic to a dedicated **Validator class** or **BLoC state**.

**Proposed Solution:**
```dart
// lib/utils/validators/form_validators.dart
class FormValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 30) {
      return 'Username cannot exceed 30 characters';
    }
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

// Usage in screens:
validator: FormValidators.validateUsername,
```

**Benefits:**
- ✅ Centralized validation logic
- ✅ Easier to test
- ✅ Reusable across screens
- ✅ Easier to maintain

**Priority:** 🟡 **LOW** - This is more about code organization than architecture

---

### **2. Password Visibility Toggle in UI State** (LOW PRIORITY)

**Current Issue:** Password visibility (`_obscurePassword`) managed with `setState` in widgets

**Files Affected:**
- `login_screen.dart` (line 237)
- `signup_screen.dart` (lines 350, 441)
- `change_password_screen.dart` (lines 122, 150, 178)
- `reset_password_confirm_screen.dart` (lines 232, 345)

**Example:**
```dart
bool _obscurePassword = true;

// In button:
onPressed: () {
  setState(() {
    _obscurePassword = !_obscurePassword;
  });
},
```

**Recommendation:**
This is actually **FINE as-is**. This is pure UI state and doesn't belong in BLoC.

**Verdict:** ✅ **NO CHANGE NEEDED** - UI-only state should stay in widget

---

### **3. Profile Screen Expansion State** (LOW PRIORITY)

**Current Issue:** Edit account section expansion tracked with `setState`

**File:** `profile_screen.dart` (lines 283, 330, 348, 360)

**Example:**
```dart
bool _isEditAccountExpanded = false;

onTap: () {
  setState(() {
    _isEditAccountExpanded = !_isEditAccountExpanded;
  });
},
```

**Recommendation:**
This is UI-only state and should stay in the widget.

**Verdict:** ✅ **NO CHANGE NEEDED**

---

### **4. Discover Screen Tab State** (LOW PRIORITY)

**Current Issue:** Current tab tracked with `setState`

**File:** `discover_screen.dart` (lines 46, 52, 58)

**Example:**
```dart
String currentTab = 'Macro Trends';

onTap: () {
  setState(() {
    currentTab = 'Macro Trends';
  });
},
```

**Recommendation:**
This is navigation/UI state. Could be in BLoC but not necessary.

**Verdict:** ✅ **ACCEPTABLE** - Simple UI state

---

### **5. Articles URL Launching Logic** (MEDIUM PRIORITY) ⚠️

**Current Issue:** URL launching logic is in the screen widget

**File:** `articles_screen.dart` (lines ~390-410)

**Example:**
```dart
Future<void> _launchArticleUrl(String urlString) async {
  try {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      SnackBarHelper.showError(context, 'Could not open the link.');
    }
  } catch (e) {
    SnackBarHelper.showError(context, 'Error opening link: $e');
  }
}
```

**Recommendation:**
Move to a **UrlLauncherService** or utility class.

**Proposed Solution:**
```dart
// lib/utils/url_launcher_helper.dart
class UrlLauncherHelper {
  static Future<bool> launch(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        return await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// Usage in screen:
final success = await UrlLauncherHelper.launch(article.url);
if (!success && context.mounted) {
  SnackBarHelper.showError(context, 'Could not open the link.');
}
```

**Priority:** 🟡 **MEDIUM** - Good for reusability

---

### **6. Dashboard URL Launching** (MEDIUM PRIORITY) ⚠️

**Current Issue:** Same URL launching logic duplicated in dashboard

**File:** `dashboard_screen.dart` (line ~1105)

**Recommendation:**
Use the same `UrlLauncherHelper` as above.

**Priority:** 🟡 **MEDIUM** - Remove duplication

---

### **7. Contact Support Debug Screen** (HIGH PRIORITY) 🔴

**Current Issue:** **DIRECT API CALL IN UI!** Bypasses BLoC architecture entirely.

**File:** `debug/contact_support_debug_screen.dart` (lines 37-65)

**Example:**
```dart
Future<void> _testContactSupport() async {
  setState(() {
    _result = 'Sending...';
  });

  try {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.anchorwatch.com',
      headers: {'Authorization': 'Bearer ${token}'},
    ));
    
    final response = await dio.post(
      '/contact-support/',
      data: {'message': _messageController.text},
    );
    
    setState(() {
      _result = 'Success: ${response.data}';
    });
  } catch (e) {
    setState(() {
      _result = 'Error: $e';
    });
  }
}
```

**Recommendation:**
This is a **DEBUG SCREEN**, so it's acceptable for testing. But if it moves to production, it MUST use `ContactSupportBloc`.

**Verdict:** ⚠️ **ACCEPTABLE** for debug purposes only. Remove before production.

**Priority:** 🔴 **HIGH** (if moving to production)

---

### **8. Profile Picture Confirmation Logic** (LOW PRIORITY)

**Current Issue:** Profile reload triggered from UI listener

**File:** `profile_screen.dart` (lines 116-119)

**Example:**
```dart
BlocListener<ProfilePictureBloc, ProfilePictureState>(
  listener: (context, profilePictureState) {
    if (profilePictureState.status == ProfilePictureStatus.confirmed) {
      context.read<ProfileBloc>().add(const ProfileLoadRequested());
    }
  },
  // ...
)
```

**Recommendation:**
This pattern is actually **CORRECT** for cross-BLoC communication via UI. Alternative would be to use a `StreamSubscription` in the ProfileBloc to listen to ProfilePictureBloc, but that's more complex.

**Verdict:** ✅ **ACCEPTABLE** - This is a valid pattern

---

### **9. SignUp Screen - Cross-BLoC Communication** (MEDIUM PRIORITY) ⚠️

**Current Issue:** SignupScreen manually triggers AuthenticationBloc

**File:** `signup_screen.dart` (lines 67-68)

**Example:**
```dart
if (state.status == SignUpStatus.success) {
  context.read<AuthenticationBloc>().add(
    AuthenticationStatusRequested(),
  );
  // Navigate...
}
```

**Recommendation:**
**Option A:** Keep as-is (acceptable for simple cases)  
**Option B:** Have SignUpBloc emit a different event that the screen listens to, then the screen doesn't need to know about AuthenticationBloc.

**Better Pattern:**
```dart
// In SignUpBloc, after successful signup:
emit(SignUpState(status: SignUpStatus.successAndCheckAuth));

// In screen:
if (state.status == SignUpStatus.successAndCheckAuth) {
  context.read<AuthenticationBloc>().add(AuthenticationStatusRequested());
  // Navigate...
}
```

Or even better, use a **coordinator/router pattern** but that's a bigger refactor.

**Priority:** 🟡 **MEDIUM** - Current approach works but could be cleaner

---

### **10. ChangeUsername Screen - Cross-BLoC Communication** (SIMILAR TO #9)

**File:** `change_username_screen.dart` (lines 68-70)

**Example:**
```dart
if (state is ChangeUsernameSuccess) {
  context.read<AuthenticationBloc>().add(
    AuthenticationUsernameUpdated(newUsername: newUsername)
  );
  // Navigate...
}
```

**Verdict:** Same as #9 - ✅ **ACCEPTABLE** pattern for cross-BLoC communication

---

## 📊 Summary Table

| Issue | File(s) | Priority | Recommendation |
|-------|---------|----------|----------------|
| **1. Form Validators** | Multiple | 🟡 LOW | Extract to `FormValidators` class |
| **2. Password Visibility** | Multiple | ✅ OK | Keep as-is (UI state) |
| **3. Profile Expansion** | `profile_screen.dart` | ✅ OK | Keep as-is (UI state) |
| **4. Tab State** | `discover_screen.dart` | ✅ OK | Keep as-is (UI state) |
| **5. URL Launcher (Articles)** | `articles_screen.dart` | 🟡 MEDIUM | Extract to `UrlLauncherHelper` |
| **6. URL Launcher (Dashboard)** | `dashboard_screen.dart` | 🟡 MEDIUM | Use `UrlLauncherHelper` |
| **7. Debug API Calls** | `contact_support_debug_screen.dart` | 🔴 HIGH* | Remove before production |
| **8. Profile Picture Reload** | `profile_screen.dart` | ✅ OK | Valid cross-BLoC pattern |
| **9. Signup → Auth Trigger** | `signup_screen.dart` | 🟡 MEDIUM | Acceptable, could improve |
| **10. Change Username → Auth** | `change_username_screen.dart` | 🟡 MEDIUM | Acceptable, could improve |

\* Only if moving to production

---

## 🎯 Recommended Action Plan

### **Phase 1: Quick Wins (1-2 hours)**
1. ✅ Create `FormValidators` class
2. ✅ Create `UrlLauncherHelper` class
3. ✅ Refactor all validation to use `FormValidators`
4. ✅ Refactor URL launching to use `UrlLauncherHelper`

### **Phase 2: Optional Improvements (2-4 hours)**
5. Consider adding coordinator pattern for cross-BLoC communication
6. Add unit tests for `FormValidators`

### **Phase 3: Production Readiness**
7. Remove or properly architect the debug screen

---

## 📝 Implementation Examples

### **Example 1: Form Validators Class**

```dart
// lib/utils/validators/form_validators.dart
class FormValidators {
  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 30) {
      return 'Username cannot exceed 30 characters';
    }
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // OTP validation
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the verification code';
    }
    if (value.trim().length != length) {
      return 'Verification code must be $length digits';
    }
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
}
```

### **Example 2: URL Launcher Helper**

```dart
// lib/utils/url_launcher_helper.dart
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Launch URL in external browser
  static Future<bool> launchExternal(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        return await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }

  /// Launch URL in in-app browser
  static Future<bool> launchInApp(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        return await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
        );
      }
      return false;
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }

  /// Launch email
  static Future<bool> launchEmail(String email, {String? subject, String? body}) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      return await launchUrl(emailUri);
    } catch (e) {
      print('Error launching email: $e');
      return false;
    }
  }

  /// Launch phone
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      return await launchUrl(phoneUri);
    } catch (e) {
      print('Error launching phone: $e');
      return false;
    }
  }
}
```

---

## 🎖️ Final Verdict

**Your BLoC architecture is already well-structured!** 🎉

Most business logic is properly separated. The main improvements are:
1. **Centralizing form validation** (code organization)
2. **Extracting URL launching** (reusability)
3. **Cleaning up debug code** (production readiness)

These are **nice-to-haves**, not critical issues. Your current architecture follows Flutter best practices quite well!

---

## 📚 Additional Resources

- [BLoC Pattern Best Practices](https://bloclibrary.dev/#/coreconcepts)
- [Flutter Clean Architecture](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)
- [Form Validation Strategies](https://docs.flutter.dev/cookbook/forms/validation)
