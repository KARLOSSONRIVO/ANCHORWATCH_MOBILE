# Alert Email Notification System

## Overview

The AnchorWatch mobile app includes an automatic email notification system that sends alerts to users via email whenever a new alert is received through the WebSocket connection. This system ensures users are notified of critical events even when they're not actively using the app.

## How It Works

### Architecture Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER LOGIN                                │
│  User authenticates → Email stored in SharedPreferences          │
│  Key: StorageKeys.userEmail                                     │
└───────────────────┬─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                   WEBSOCKET CONNECTION                           │
│  AlertWebSocketService connects to: ws://backend/ws/alerts/     │
│  Listens for incoming alert messages                            │
└───────────────────┬─────────────────────────────────────────────┘
                    │
                    ▼ (Alert Received)
┌─────────────────────────────────────────────────────────────────┐
│                   EMAIL SERVICE TRIGGER                          │
│  EmailService.sendAlertEmail(alert) called automatically        │
│  - Retrieves user email from SharedPreferences                  │
│  - Attempts backend POST to /api/alerts/send_email/            │
│  - Falls back to mailto: if backend fails                       │
└─────────────────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                    USER NOTIFICATION                             │
│  Email delivered to user's inbox with alert details             │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### 1. Authentication & Email Storage

**File:** `lib/services/authentication_service.dart`

When a user logs in successfully:
```dart
Future<bool> storeAuthResult(AuthResult authResult) async {
  // Store user email in SharedPreferences
  await StorageService.setString(StorageKeys.userEmail, authResult.user.email);
  // ...
}
```

**Storage Key:** `StorageKeys.userEmail` = `'user_email'`

**When Email is Stored:**
- ✅ Successful login
- ✅ Successful registration
- ✅ Profile update (if email changed)

**When Email is Cleared:**
- ❌ User logout
- ❌ Token expiration/invalidation

---

### 2. WebSocket Alert Reception

**File:** `lib/services/alert_websocket_service.dart`

The `AlertWebSocketService` maintains a persistent WebSocket connection to receive real-time alerts:

```dart
@singleton
class AlertWebSocketService {
  final EmailService _emailService;
  
  void connect({required String baseUrl}) {
    // Connects to: ws://baseUrl/ws/alerts/
    // Listens for messages
  }
}
```

**WebSocket Endpoint:** `ws://<backend_url>/ws/alerts/`

**Message Format Expected:**
```json
{
  "type": "alert",
  "data": {
    "id": "alert-123",
    "type": "geofence",
    "title": "Geofence Breach",
    "message": "Your vessel has exited the safe zone",
    "severity": "critical",
    "status": "active",
    "created_at": "2025-10-14T10:30:00Z",
    "description": "Additional details...",
    "data": {
      "latitude": 14.5995,
      "longitude": 120.9842
    }
  }
}
```

**When Alert is Received:**
1. Parse JSON message
2. Convert to `Alert` entity
3. Add to alert stream (for UI updates)
4. **Automatically trigger email send** (fire-and-forget)

---

### 3. Email Service

**File:** `lib/services/email_service.dart`

The `EmailService` handles the actual email sending logic with two strategies:

#### Strategy 1: Backend API (Primary)

```dart
Future<EmailSendResult> sendAlertEmail(Alert alert) async {
  // Get user email from SharedPreferences
  final userEmail = StorageService.getString(StorageKeys.userEmail);
  
  // POST to backend
  final response = await _dioClient.post('/api/alerts/send_email/', data: {
    'to': userEmail,
    'subject': '[Alert] ${alert.title}',
    'body': _buildEmailBody(alert),
  });
  
  // Returns EmailSendResult with success status
}
```

**Backend Endpoint:** `POST /api/alerts/send_email/`

**Request Payload:**
```json
{
  "to": "user@example.com",
  "subject": "[Alert] Geofence Breach",
  "body": "Your vessel has exited the safe zone\n\nDetails:\nAdditional details...\n\nData:\n{latitude: 14.5995, longitude: 120.9842}\n\nReceived: 2025-10-14T10:30:00.000Z"
}
```

**Authentication:**
- Uses DI-injected `DioClient` with JWT token
- Authorization header automatically included
- Token set during login via `AuthenticationService`

#### Strategy 2: Mailto Fallback (Secondary)

If backend POST fails (network error, endpoint not available, etc.):

```dart
Future<void> _openMailClient(Alert alert, String? to) async {
  // Constructs mailto: URI
  final uri = Uri.parse('mailto:$to?subject=$subject&body=$body');
  
  // Opens device's default mail app
  await launchUrl(uri);
}
```

**Mailto URI Example:**
```
mailto:user@example.com?subject=%5BAlert%5D%20Geofence%20Breach&body=Your%20vessel%20has%20exited...
```

---

### 4. Email Body Formatting

**Method:** `EmailService._buildEmailBody(Alert alert)`

**Template:**
```
{alert.message}

Details:
{alert.description}

Data:
{alert.data}

Received: {alert.createdAt ISO8601}
```

**Example Output:**
```
Your vessel has exited the safe zone

Details:
The vessel moved beyond the designated safe perimeter at coordinates (14.5995, 120.9842).

Data:
{latitude: 14.5995, longitude: 120.9842, speed: 5.2, heading: 180}

Received: 2025-10-14T10:30:00.000Z
```

---

## Configuration

### Backend Setup (Required for Production)

To enable automatic backend email delivery, your Django/backend must implement:

**Endpoint:** `POST /api/alerts/send_email/`

**Request:**
```python
{
    "to": "string (email address)",
    "subject": "string",
    "body": "string (plain text)"
}
```

**Response (Success):**
```python
HTTP 200 OK
{
    "success": true,
    "message": "Email sent successfully"
}
```

**Implementation Example (Django):**
```python
from django.core.mail import send_mail
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def send_alert_email(request):
    to_email = request.data.get('to')
    subject = request.data.get('subject')
    body = request.data.get('body')
    
    try:
        send_mail(
            subject=subject,
            message=body,
            from_email='alerts@anchorwatch.com',
            recipient_list=[to_email],
            fail_silently=False,
        )
        return Response({'success': True, 'message': 'Email sent successfully'})
    except Exception as e:
        return Response({'success': False, 'error': str(e)}, status=500)
```

**Django Settings:**
```python
# settings.py
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'  # or your SMTP server
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'your-email@gmail.com'
EMAIL_HOST_PASSWORD = 'your-app-password'
DEFAULT_FROM_EMAIL = 'alerts@anchorwatch.com'
```

---

## Testing

### Unit Tests

**File:** `test/email_service_test.dart`

Run tests:
```bash
flutter test test/email_service_test.dart
```

**Test Coverage:**
- ✅ Email body includes message, description, data, and timestamp
- ✅ Mailto URI properly encodes subject and body
- ✅ Mailto URI includes recipient email

### Manual Testing

#### Test Backend Send:
1. Ensure backend endpoint `/api/alerts/send_email/` is running
2. Log in to the app (email stored automatically)
3. Trigger an alert from backend via WebSocket
4. Check your email inbox for the alert notification

#### Test Mailto Fallback:
1. Disable backend or use incorrect endpoint
2. Log in to the app
3. Trigger an alert
4. Device mail app should open with pre-filled email

---

## Dependency Injection

The system uses `injectable` and `get_it` for dependency injection:

**Registered Services:**
```dart
@lazySingleton
class EmailService {
  final DioClient _dioClient;
  EmailService(this._dioClient);
}

@singleton
class AlertWebSocketService {
  final EmailService _emailService;
  AlertWebSocketService(this._emailService);
}
```

**Regenerate DI Code:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Error Handling

### No User Email Stored
```dart
if (userEmail == null || userEmail.isEmpty) {
  debugPrint('EmailService: no user email stored; opening mail app');
  await _openMailClient(alert, null);
  return EmailSendResult(false, 'No user email stored; opened mail client');
}
```

**Cause:** User not logged in or email not saved  
**Action:** Opens mail client with empty recipient (user can fill in manually)

### Backend Send Failure
```dart
try {
  final response = await _dioClient.post(...);
  // Check response
} catch (e) {
  debugPrint('EmailService: backend send failed: $e');
  // Fall back to mailto
  await _openMailClient(alert, userEmail);
  return EmailSendResult(false, 'Fell back to mail client');
}
```

**Causes:**
- Network error
- Backend endpoint not implemented
- Server error (500)
- Authentication failure

**Action:** Automatically falls back to mailto client

### WebSocket Errors
- Auto-reconnect after 5 seconds
- Email send errors don't disrupt WebSocket
- Fire-and-forget approach prevents blocking

---

## Email Send Result

The `EmailSendResult` class provides feedback:

```dart
class EmailSendResult {
  final bool success;
  final String message;
}
```

**Possible Results:**
- ✅ `success: true` - Backend send succeeded
- ⚠️ `success: false, message: "No user email stored; opened mail client"`
- ⚠️ `success: false, message: "Fell back to mail client"`
- ⚠️ `success: false, message: "Unexpected error: ..."`

---

## Performance Considerations

### Non-Blocking Design
```dart
// Fire-and-forget approach
_emailService.sendAlertEmail(alert).then((result) {
  if (result.success) {
    print('Alert email sent successfully');
  } else {
    print('Alert email send fallback/result: ${result.message}');
  }
}).catchError((e) {
  print('EmailService.sendAlertEmail error: $e');
});
```

- Email sending doesn't block WebSocket message handling
- Alert appears in UI immediately
- Email delivery happens in background
- Errors are logged but don't affect app functionality

### Memory & Network
- WebSocket maintained as singleton (one connection)
- Email service reuses authenticated `DioClient`
- No polling - push-based notifications only
- Minimal battery impact

---

## Security

### Authentication
- ✅ JWT tokens required for backend API calls
- ✅ Tokens stored securely via `TokenStorageService`
- ✅ Auto-refresh on token expiration
- ✅ Logout clears all tokens and user data

### Email Privacy
- ✅ User email only stored locally in SharedPreferences
- ✅ Never sent to third parties
- ✅ Only backend sees email in send request
- ✅ Mailto fallback uses device's secure mail client

### Data Transmission
- ✅ WebSocket uses WSS (secure WebSocket) in production
- ✅ API calls use HTTPS
- ✅ Alert data encrypted in transit

---

## Troubleshooting

### Emails Not Sending

**Check 1: User Logged In?**
```dart
final email = StorageService.getString(StorageKeys.userEmail);
print('Stored email: $email');  // Should print user's email
```

**Check 2: WebSocket Connected?**
```dart
if (alertWebSocketService.isConnected) {
  print('WebSocket connected');
} else {
  print('WebSocket disconnected - check backend URL');
}
```

**Check 3: Backend Endpoint Available?**
```bash
# Test with curl
curl -X POST http://your-backend/api/alerts/send_email/ \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"to":"test@example.com","subject":"Test","body":"Test body"}'
```

**Check 4: Review Logs**
```dart
// EmailService logs all attempts
debugPrint('EmailService: backend email send succeeded');  // Success
debugPrint('EmailService: backend send failed: ...');      // Backend error
debugPrint('EmailService: launching mailto uri');           // Fallback triggered
```

### Mail Client Not Opening

**Cause:** `url_launcher` not configured properly

**Fix (iOS):**
Add to `ios/Runner/Info.plist`:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>mailto</string>
</array>
```

**Fix (Android):**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<queries>
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="mailto" />
  </intent>
</queries>
```

---

## Future Enhancements

### Possible Improvements
1. **Push Notifications:** Integrate Firebase Cloud Messaging for native push notifications
2. **Email Templates:** Support HTML email templates with branding
3. **User Preferences:** Allow users to configure email notification settings
4. **Delivery Confirmation:** Track email delivery status
5. **Batch Notifications:** Group multiple alerts into digest emails
6. **SMS Fallback:** Send SMS for critical alerts if email fails

---

## Files Modified/Created

### Core Implementation
- `lib/services/email_service.dart` - Email sending logic
- `lib/services/alert_websocket_service.dart` - WebSocket handler with email trigger
- `lib/services/authentication_service.dart` - Email storage on login

### Tests
- `test/email_service_test.dart` - Unit tests for email formatting and mailto URI

### Dependencies
- `url_launcher: ^6.2.5` - Opens mailto URIs
- `dio: ^5.4.0` - HTTP client for backend calls
- `web_socket_channel: ^3.0.3` - WebSocket connection
- `shared_preferences: ^2.2.2` - Local storage for email

---

## Support

For issues or questions:
1. Check logs in `flutter run` output
2. Run `flutter analyze` for code issues
3. Test unit tests: `flutter test test/email_service_test.dart`
4. Review backend logs for endpoint errors

---

## License

This alert email notification system is part of the AnchorWatch mobile application.

---

**Last Updated:** October 14, 2025  
**Version:** 1.0.0  
**Maintainer:** AnchorWatch Development Team
