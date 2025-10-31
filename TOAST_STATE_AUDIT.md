# 🔍 Toast/SnackBar State Conflict Audit Report

**Date:** October 18, 2025  
**Project:** ANCHORWATCH_MOBILE  
**Focus:** Identifying potential widget tree conflicts from SnackBar + Navigation patterns

---

## ✅ **Already Fixed Issues**

### 1. **MainNavigationScreen** (CRITICAL - FIXED ✅)
- **Location:** `lib/presentation/screens/main_navigation_screen.dart`
- **Issue:** SnackBar shown immediately before navigation during logout
- **Status:** ✅ **FIXED** - Removed SnackBar, using PostFrameCallback for navigation

### 2. **LoginScreen** (CRITICAL - FIXED ✅)
- **Location:** `lib/presentation/screens/login_screen.dart`
- **Issue:** SnackBar + navigation on successful login
- **Status:** ✅ **FIXED** - Removed welcome SnackBar, using PostFrameCallback for navigation

---

## ⚠️ **POTENTIAL ISSUES - Require Immediate Fixes**

### 3. **SignupScreen** (HIGH RISK ⚠️)
- **Location:** `lib/presentation/screens/signup_screen.dart` (Line 65)
- **Pattern:**
  ```dart
  if (state.status == SignUpStatus.success) {
    context.read<AuthenticationBloc>().add(AuthenticationStatusRequested());
    SnackBarHelper.showSuccess(context, 'Account created successfully!');
    Navigator.pop(context); // ⚠️ IMMEDIATE NAVIGATION AFTER TOAST
  }
  ```
- **Risk Level:** 🔴 **HIGH** - Same pattern as the logout bug
- **Why It's Risky:** 
  - Shows toast
  - Immediately pops navigation
  - Widget tree gets disposed while SnackBar is rendering
- **Recommended Fix:** Remove SnackBar or use PostFrameCallback with delay

---

### 4. **ChangeUsernameScreen** (HIGH RISK ⚠️)
- **Location:** `lib/presentation/screens/profile/change_username_screen.dart` (Line 65)
- **Pattern:**
  ```dart
  if (state is ChangeUsernameSuccess) {
    SnackBarHelper.showSuccess(context, state.message);
    // Update auth state
    context.read<AuthenticationBloc>().add(...);
    Navigator.of(context).pop(newUsername); // ⚠️ IMMEDIATE NAVIGATION
  }
  ```
- **Risk Level:** 🔴 **HIGH**
- **Why It's Risky:**
  - Shows success toast
  - Triggers auth state update
  - Immediately pops screen
  - All three actions happen synchronously
- **Recommended Fix:** Remove SnackBar or delay navigation

---

### 5. **ChangePasswordScreen** (HIGH RISK ⚠️)
- **Location:** `lib/presentation/screens/profile/change_password_screen.dart` (Line 50)
- **Pattern:**
  ```dart
  if (state is ChangePasswordSuccess) {
    SnackBarHelper.showSuccess(context, 'Password changed successfully!');
    Navigator.of(context).pop(); // ⚠️ IMMEDIATE NAVIGATION
  }
  ```
- **Risk Level:** 🔴 **HIGH**
- **Why It's Risky:** Classic toast + immediate pop pattern
- **Recommended Fix:** Remove SnackBar or use PostFrameCallback

---

### 6. **ChangeEmailScreen** (MEDIUM RISK ⚠️)
- **Location:** `lib/presentation/screens/profile/change_email_screen.dart` (Line 50)
- **Pattern:**
  ```dart
  if (state is ChangeEmailRequestSuccess) {
    SnackBarHelper.showSuccess(context, 'OTP sent successfully');
    Navigator.push(context, MaterialPageRoute(...)); // Push to new screen
  }
  ```
- **Risk Level:** 🟡 **MEDIUM**
- **Why It's Less Risky:**
  - Uses `push` instead of `pop` (current widget stays alive)
  - But still has timing issues
- **Recommended Fix:** Consider removing SnackBar or showing it on the NEW screen

---

### 7. **ResetPasswordConfirmScreen** (HIGH RISK ⚠️)
- **Location:** `lib/presentation/screens/password_reset/reset_password_confirm_screen.dart` (Line 64)
- **Pattern:**
  ```dart
  if (state.status == PasswordResetStatus.passwordReset) {
    SnackBarHelper.showSuccess(context, 'Password reset successfully!...');
    AppRouter.clearPasswordResetBloc();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    // ⚠️ REMOVES ALL ROUTES - VERY DANGEROUS
  }
  ```
- **Risk Level:** 🔴 **CRITICAL**
- **Why It's VERY Risky:**
  - Shows toast
  - Clears the entire navigation stack
  - Destroys ALL widget trees
  - Highest chance of crash
- **Recommended Fix:** MUST remove SnackBar, navigate immediately

---

### 8. **ConfirmChangeEmailScreen** (LOW RISK ✅)
- **Location:** `lib/presentation/screens/profile/confirm_change_email_screen.dart` (Line 56)
- **Pattern:**
  ```dart
  if (state is ChangeEmailConfirmSuccess) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, widget.newEmail); // No SnackBar before pop
  }
  ```
- **Risk Level:** 🟢 **LOW** - Already safe!
- **Why It's Safe:** No SnackBar shown before navigation

---

## ✅ **SAFE PATTERNS (No Issues)**

These screens show SnackBars but DON'T navigate immediately:

9. **ContactScreen** - Shows toast but stays on screen ✅
10. **AnchorWiseScreen** - Shows error toast only ✅
11. **ArticlesScreen** - Shows toasts but no navigation ✅
12. **DashboardScreen** - Shows error toast only ✅
13. **LoginScreen (Error case)** - Shows error but stays on screen ✅
14. **ResetPasswordEmailScreen** - Shows error only ✅
15. **ResetPasswordOtpScreen** - Shows error only ✅

---

## 📋 **Priority Fix List**

| Priority | Screen | Risk | Action Required |
|----------|--------|------|----------------|
| 🔥 **P0** | ResetPasswordConfirmScreen | CRITICAL | Remove SnackBar immediately |
| 🔴 **P1** | SignupScreen | HIGH | Remove/delay SnackBar |
| 🔴 **P1** | ChangeUsernameScreen | HIGH | Remove/delay SnackBar |
| 🔴 **P1** | ChangePasswordScreen | HIGH | Remove/delay SnackBar |
| 🟡 **P2** | ChangeEmailScreen | MEDIUM | Consider moving toast to next screen |

---

## 🛠️ **Recommended Fix Pattern**

### Option 1: Remove SnackBar (Cleanest)
```dart
if (state is Success) {
  // No SnackBar here
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      Navigator.of(context).pop();
    }
  });
}
```

### Option 2: Delay Navigation (If toast is critical)
```dart
if (state is Success) {
  SnackBarHelper.showSuccess(context, 'Success!');
  // Wait for SnackBar to render
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) {
      Navigator.of(context).pop();
    }
  });
}
```

### Option 3: Show Toast on Next Screen (Best UX)
```dart
// In NEW screen's initState or didChangeDependencies:
WidgetsBinding.instance.addPostFrameCallback((_) {
  SnackBarHelper.showSuccess(context, 'Previous action succeeded!');
});
```

---

## 🎯 **Summary**

- **Total SnackBar usages found:** 36
- **Critical issues (SnackBar + Navigation):** 6
- **Already fixed:** 2 (MainNavigationScreen, LoginScreen)
- **Require immediate fixes:** 4-5
- **Safe patterns:** ~25

**Recommendation:** Fix all P0 and P1 issues to prevent the same crash pattern from occurring in other flows.

---

## 📝 **Testing Checklist After Fixes**

- [ ] Sign up new account → Navigate to login
- [ ] Change username → Navigate back to profile
- [ ] Change password → Navigate back to profile
- [ ] Change email → Navigate to OTP screen
- [ ] Reset password → Navigate back to login
- [ ] Log out → Navigate to login (already fixed)
- [ ] Log in → Navigate to dashboard (already fixed)

All navigation transitions should be smooth without crashes! 🚀
