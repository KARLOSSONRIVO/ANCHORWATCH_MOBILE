# AnchorWatch Navigation System

## Overview
This project now uses a comprehensive routing system built on top of the BLoC architecture for state management and navigation.

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point with routing
├── blocs/                              # Business Logic Components
│   ├── authentication/                # Authentication BLoC
│   └── blocs.dart                     # BLoC barrel file
├── routes/                            # 🆕 Navigation system
│   ├── app_routes.dart               # Route constants
│   ├── app_router.dart               # Route generation logic
│   ├── route_guard.dart              # Authentication guards
│   └── routes.dart                   # Routes barrel file
├── screens/                          # UI Screens
│   ├── login_screen.dart            # Authentication screen
│   ├── home_screen.dart             # Main dashboard
│   └── profile_screen.dart          # 🆕 User profile
├── widgets/                          # Reusable components
├── models/                           # Data models
└── repositories/                     # Data access layer
```

## 🚀 Features

### 🔐 **Authentication-Based Navigation**
- **Route Guards**: Automatically redirects based on authentication status
- **Protected Routes**: Home, Profile, Settings require authentication
- **Public Routes**: Login, Splash screen accessible to all

### 🧭 **Navigation System**
- **Named Routes**: Clean, maintainable route definitions
- **Route Generation**: Centralized route handling
- **Deep Linking**: Ready for URL-based navigation
- **Error Handling**: 404 screen for unknown routes

### 📱 **User Experience**
- **Navigation Helpers**: Consistent snackbars, dialogs, loading states
- **Confirmation Dialogs**: Logout confirmation for better UX
- **Smooth Transitions**: MaterialPageRoute with proper animations

## 🎯 **Available Routes**

### **Authentication Routes**
- `/` - Splash Screen (initial loading)
- `/login` - Login Screen

### **Protected Routes** (Require Authentication)
- `/home` - Main Dashboard
- `/profile` - User Profile
- `/settings` - App Settings (planned)
- `/anchor-map` - Anchor Map View (planned)
- `/anchor-history` - Anchor History (planned)
- `/weather` - Weather Information (planned)

## 🔧 **How to Use**

### **Navigation in Code**
```dart
// Navigate to a specific route
Navigator.of(context).pushNamed(AppRoutes.profile);

// Navigate and clear stack
AppRouter.navigateToHome(context);
AppRouter.navigateToLogin(context);

// Show messages
NavigationHelper.showMessage(context, 'Success!');
NavigationHelper.showMessage(context, 'Error!', isError: true);

// Show confirmation
final confirmed = await NavigationHelper.confirmLogout(context);
```

### **Adding New Routes**
1. **Add route constant** in `app_routes.dart`
2. **Create screen widget** in `screens/`
3. **Add route case** in `app_router.dart`
4. **Import screen** in router
5. **Navigate using** `Navigator.pushNamed(AppRoutes.newRoute)`

### **Authentication Flow**
1. **App starts** → Shows splash screen
2. **Check auth status** → AuthenticationBloc determines state
3. **Route accordingly**:
   - ✅ Authenticated → Home Screen
   - ❌ Not authenticated → Login Screen
   - ⏳ Loading → Splash Screen

### **Route Protection**
- Routes are automatically protected based on `AppRoutes.protectedRoutes`
- RouteGuard listens to authentication changes
- Automatic redirection on auth state changes

## 🧪 **Testing the System**

1. **Run the app**: `flutter run`
2. **Login flow**: Use demo credentials (demo/password)
3. **Navigate**: Use profile menu → Profile screen
4. **Logout**: Confirm logout dialog works
5. **Route protection**: Direct navigation to protected routes redirects to login

## 🔮 **Ready for Extension**

The routing system is ready for your AnchorWatch features:

### **Planned Screens**
- **Anchor Map**: Real-time GPS and anchor position
- **Weather Dashboard**: Marine weather conditions
- **Settings**: User preferences and configurations
- **History**: Past anchor positions and logs

### **Easy to Extend**
- Add new BLoCs for additional features
- Create new screens following the same pattern
- Routes automatically work with authentication
- Navigation helpers provide consistent UX

## 🎨 **BLoC Integration**

The routing system is fully integrated with BLoC:
- **Authentication state** drives navigation decisions
- **Route Guards** respond to BLoC events
- **Screens** use BLoC for state management
- **Navigation helpers** work with any BLoC

This creates a robust, scalable foundation for your AnchorWatch maritime application! 🚢⚓