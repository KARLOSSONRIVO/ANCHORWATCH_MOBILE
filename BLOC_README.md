# BLoC Architecture Guide

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── blocs/                       # Business Logic Components
│   ├── blocs.dart              # Barrel file for all BLoCs
│   └── counter/                # Counter feature BLoC
│       ├── counter.dart        # Counter barrel file
│       ├── counter_bloc.dart   # Counter BLoC implementation
│       ├── counter_event.dart  # Counter events
│       └── counter_state.dart  # Counter states
├── screens/                     # UI Screens
│   └── counter_screen.dart     # Counter screen
├── widgets/                     # Reusable widgets
├── models/                      # Data models
└── repositories/               # Data layer
```

## BLoC Pattern Overview

The BLoC (Business Logic Component) pattern helps separate business logic from UI code. It follows these principles:

### Events
- Define what actions can be performed
- Triggered by user interactions or system events
- Examples: `CounterIncremented`, `CounterDecremented`, `CounterReset`

### States
- Represent the current state of the feature
- Immutable objects that contain data
- Examples: `CounterState(value: 5)`

### BLoC
- Contains the business logic
- Takes events as input and outputs states
- Handles state transitions and side effects

## Usage Example

```dart
// 1. Add event to trigger state change
context.read<CounterBloc>().add(const CounterIncremented());

// 2. Listen to state changes in UI
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('${state.value}');
  },
)

// 3. Provide BLoC to widget tree
BlocProvider(
  create: (context) => CounterBloc(),
  child: MyWidget(),
)
```

## Extending for AnchorWatch

For your AnchorWatch app, you might want to create BLoCs for:

1. **Authentication BLoC**
   - Events: `LoginRequested`, `LogoutRequested`, `SignUpRequested`
   - States: `AuthenticationInitial`, `AuthenticationLoading`, `AuthenticationSuccess`, `AuthenticationFailure`

2. **Navigation BLoC** 
   - Events: `SetCurrentPosition`, `UpdatePosition`, `SetAnchor`
   - States: `NavigationState(currentLat, currentLng, anchorLat, anchorLng)`

3. **Settings BLoC**
   - Events: `UpdateSettings`, `ResetSettings`
   - States: `SettingsState(theme, language, units)`

## Best Practices

1. **Use Equatable**: All events and states should extend `Equatable` for better performance
2. **Single Responsibility**: Each BLoC should handle one feature/domain
3. **Immutable States**: States should be immutable to prevent unexpected mutations
4. **Repository Pattern**: Use repositories for data access (API, database)
5. **Testing**: Write unit tests for BLoCs to ensure business logic works correctly

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.6    # BLoC state management
  equatable: ^2.0.5       # Value equality for events/states
```