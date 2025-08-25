# Development Best Practices

## Context

Global development guidelines for Agent OS projects.

<conditional-block context-check="core-principles">
IF this Core Principles section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Core Principles already in context"
ELSE:
  READ: The following principles

## Core Principles

### Keep It Simple

- Implement code in the fewest lines possible
- Avoid over-engineering solutions
- Choose straightforward approaches over clever ones

### Optimize for Readability

- Prioritize code clarity over micro-optimizations
- Write self-documenting code with clear variable names
- Add comments for "why" not "what"

### DRY (Don't Repeat Yourself)

- Extract repeated business logic to private methods
- Extract repeated UI markup to reusable components
- Create utility functions for common operations

### File Structure

- Keep files focused on a single responsibility
- Group related functionality together
- Use consistent naming conventions
</conditional-block>

<conditional-block context-check="flutter-architecture" task-condition="flutter-development">
IF current task involves Flutter/Dart development:
  IF Flutter Architecture section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Flutter Architecture already in context"
  ELSE:
    READ: The following principles
ELSE:
  SKIP: Flutter section not relevant to current task

## Flutter/Dart Clean Architecture

### Module Organization Pattern

Structure features using clean architecture layers:

```
modules/[feature]/
├── data/
│   ├── models/
│   │   ├── entities/     # Domain models + DTOs
│   │   ├── failures/      # Typed error unions
│   │   ├── requests/      # Request DTOs
│   │   └── responses/     # Response DTOs
│   ├── repositories/      # Abstract + concrete implementations
│   └── usecases/         # Business logic orchestration
└── presentation/
    ├── [feature]_binding.dart
    ├── [feature]_controller.dart
    ├── [feature]_view.dart
    └── screens/          # Nested screens with own MVC
```

### R-Prefix Base Classes

All framework classes use R-prefix naming:

- **RController**: Base GetX controller with lifecycle logging
- **RFormController**: Form validation and loading states
- **RRepository**: Service layer with automatic cleanup
- **RUseCase<I,O,F>**: Business logic with comprehensive logging
- **RColors, RSizes, RDurations**: Design system constants

### Value Objects vs Entities

#### Value Objects (Immutable Identity)

- Objects where any change creates new identity
- Examples: EmailAddress, PhoneNumber, UserId
- Factory creation with validation
- No setters, immutable after creation

#### Entities (Mutable Properties)

- Objects maintaining identity despite property changes
- Examples: User, Client, Consultation
- Composed of Value Objects for type safety
- Can update properties while keeping same ID

### Result Pattern and Functional Programming

Use monadic `Result<Success, Failure>` for error handling:

- **Never throw exceptions**: Return Result.err() instead
- **Monadic operations**: map, bind, bimap for transformations
- **Async support**: mapOkAsync, bindAsync for async chains
- **Combination utilities**: combine2-8 for multiple results
- **Function composition**: pipe, compose for building operations

### Three-Layer Validation Pattern

1. **Raw Input**: String values from UI
2. **Value Objects**: Type-safe validated objects
3. **Request DTOs**: Combined validated data
4. **Repository**: External service interaction

### Repository Pattern with Isolation

- Abstract repositories define contracts
- Concrete implementations isolate external services
- External types never leak beyond repository
- Private _call method for consistent error handling
- Built-in retry with exponential backoff

### UseCase Pattern

- Extends RUseCase<Input, Output, Failure>
- Encapsulates business logic
- Automatic timing and logging
- Obscured values for sensitive data
- Static .to getter for dependency access

### GetX State Management

- Observable state with .obs extension
- Static accessors: `static T get to => Get.find<T>()`
- Proper cleanup in onClose() methods
- Lazy initialization with Bind.lazyPut()
- Stream subscription management in repositories

### Nested Navigation with GetRouterOutlet

- Parent view with GetRouterOutlet for child routes
- Shared animations in parent controller
- Route structure: /parent with /child nested routes
- Middleware protection for auth flows

### Dependency Injection Pattern

- Module-level bindings for shared dependencies
- Screen-level bindings for specific controllers
- Lazy loading for performance
- Static .to pattern for access

### Error Handling Best Practices

- Typed failure classes using Freezed unions
- Exhaustive error handling with pattern matching
- Localized error messages via .tr getters
- No exceptions in business logic layer
- Meaningful error propagation through Result

### Testing Strategy

- Handler-based mocking for repositories
- GetX test mode initialization
- Comprehensive cleanup in tearDown
- Result pattern testing for all scenarios
- Value object validation testing

### Development Workflow

After code changes:

1. Run `just basic-lint` for formatting
2. Run `just test` to verify tests pass
3. Generate code with `just build` if needed
4. Check i18n with `just i18n` for new strings

### Performance Optimization

- Use const constructors wherever possible
- Implement proper key usage for widget rebuilds
- Dispose controllers and subscriptions properly
- Lazy load heavy operations
- Use isolates via computeOk/computeErr for CPU-intensive tasks

### Code Quality Standards

- Self-documenting code without comments
- R-prefix for all framework classes
- Private constructors for utility classes
- Freezed for immutable models
- Part files for large module organization
</conditional-block>

<conditional-block context-check="dependencies" task-condition="choosing-external-library">
IF current task involves choosing an external library:
  IF Dependencies section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Dependencies guidelines already in context"
  ELSE:
    READ: The following guidelines
ELSE:
  SKIP: Dependencies section not relevant to current task

## Dependencies

### Choose Libraries Wisely

When adding third-party dependencies:

- Select the most popular and actively maintained option
- Check the library's GitHub repository for:
  - Recent commits (within last 6 months)
  - Active issue resolution
  - Number of stars/downloads
  - Clear documentation
</conditional-block>
