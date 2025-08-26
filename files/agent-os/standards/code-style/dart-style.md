# Dart/Flutter Style Guide

## Dart Language Conventions

### Naming Conventions

- **Classes and Types**: Use PascalCase (e.g., `UserProfile`, `AuthRepository`)
- **Files**: Use snake_case for file names (e.g., `auth_repository.dart`, `user_profile.dart`)
- **Variables and Methods**: Use camelCase (e.g., `isAuthenticated`, `currentUser`, `calculateTotal`)
- **Constants**: Use lowerCamelCase for const variables (e.g., `const defaultTimeout = 30`)
- **Private Members**: Prefix with underscore (e.g., `_listeners`, `_privateMethod`)
- **Libraries**: Use lowercase_with_underscores

### Import Organization

- Group imports in the following order, separated by blank lines:
  1. Dart SDK imports (e.g., `dart:async`, `dart:convert`)
  2. Flutter imports (e.g., `package:flutter/material.dart`)
  3. Package imports (external dependencies)
  4. Project imports (relative imports)
- Sort imports alphabetically within each group

### Code Structure

- Place static members before instance members
- Order class members: fields, constructors, lifecycle methods, public methods, private methods
- Use trailing commas for better formatting and cleaner diffs
- Prefer single quotes for strings

## Flutter Widget Conventions

### Widget Structure

- Prefer `const` constructors when possible
- Always specify `key` parameter as first positional parameter
- Mark required parameters with `required` keyword
- Use named parameters for widget constructors
- Provide default values for optional parameters when appropriate

### State Management

- Use GetX for state management consistently
- Access controllers via static `to` getter: `static AuthRepository get to => Get.find<AuthRepository>();`
- Implement proper cleanup in `onClose()` methods
- Use reactive programming patterns with Rx types when appropriate

### Widget Organization

```dart
class WidgetName extends StatelessWidget {
  // Fields
  final String text;
  final void Function()? onPressed;

  // Constructor
  const WidgetName({
    super.key,
    required this.text,
    required this.onPressed,
  });

  // Build method
  @override
  Widget build(BuildContext context) {
    // Implementation
  }
}
```

## Code Patterns

### Error Handling

- Use custom failure classes for domain-specific errors
- Implement Result pattern for operations that can fail
- Return `FutureResult<Success, Failure>` for async operations with errors

### Async Programming

- Always properly await async operations
- Use `Future<void>` for async methods without return values
- Handle StreamSubscription lifecycle properly (store and cancel)

### Testing

- Write tests for business logic
- Use mockito for mocking dependencies
- Organize tests to mirror source code structure

## Formatting Rules

### Indentation

- Use 2 spaces for indentation (never tabs)
- Align wrapped parameters and arguments

### Line Length

- Maximum line length: 80 characters (soft limit)
- Break long lines at logical points

### Spacing

- Add blank lines between top-level declarations
- Single blank line between import groups
- No blank lines at start or end of blocks

### Comments

- Use `///` for documentation comments
- Use `//` for implementation comments
- Write comments above the code they describe
- Keep comments concise and valuable

## Best Practices

### Performance

- Use `const` constructors wherever possible
- Implement `Key` objects correctly for widget rebuilds
- Dispose of controllers and subscriptions properly

### Code Quality

- Follow effective Dart patterns
- Leverage Dart's type system fully
- Use named parameters for functions with multiple parameters
- Prefer composition over inheritance
- Keep methods small and focused

### Dependencies

- Minimize external dependencies
- Use well-maintained packages
- Pin package versions in pubspec.yaml
