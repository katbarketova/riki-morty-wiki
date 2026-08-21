# AGENTS.md

## Goal
Build this Flutter app using a clear feature-first Clean Architecture:
Presentation coordinates UX, Domain owns product rules, Data owns technical
details, and DI wires dependencies together.

Prefer small, scoped changes. Do not introduce parallel architecture patterns
unless the user explicitly asks for a migration.

## Architecture Flow

Use this dependency direction:

```text
Page / Widgets
  -> Cubit
  -> Use Case
  -> Repository Interface
  -> Repository Implementation
  -> Data Source
  -> Backend / Local DB / SDK
```

DI binds the graph:

```text
Cubit -> Use Case -> Repository Interface -> Repository Implementation
```

Never invert this flow. Presentation must not call APIs directly. Domain must
not know about HTTP, databases, DTOs, Flutter widgets, or DI containers.

## Feature Structure

Prefer this structure for each feature:

```text
lib/features/<feature>/
  presentation/
    pages/
    widgets/
    cubit/
  domain/
    entities/
    params/
    errors/
    usecases/
    repository/
  data/
    datasources/
    dto/
    mappers/
    repository/
```

Use existing folders when the project already has a close equivalent, but do
not create a second competing pattern for the same feature.

## Presentation Layer

Presentation owns UX:

- show loading, empty, error, and success UI;
- render domain data;
- handle user actions;
- perform navigation, snackbars, dialogs, and bottom sheets in widgets/listeners.

Allowed here:

- `Page`;
- feature widgets;
- `Cubit`;
- `State`;
- `Effect`.

Rules:

- Use Cubit by default for screen-level scenarios.
- Use Bloc only when event streams, event transformers, or complex event
  orchestration are needed.
- Do not mix Cubit and Bloc inside one screen scenario without a clear reason.
- A Cubit coordinates the screen scenario and calls use cases.
- A Cubit must not call API clients, data sources, local storage, Dio,
  Retrofit services, or repository implementations directly.
- Widgets must stay focused on rendering and user input.
- Do not put networking, persistence, or heavy mapping logic in widgets.
- Do not introduce another state management pattern unless explicitly requested.

### Cubit vs Bloc

- Cubit exposes methods and emits state directly.
- Bloc receives events and transforms an event stream into states.
- Use Cubit for simple imperative screen actions.
- Use Bloc when event ordering, concurrency, debounce, restartable, droppable,
  or sequential processing matters.

## State And Effect

State stores durable UI data that must survive rebuilds:

- loaded data;
- form values;
- loading flags;
- field validation errors;
- selected tabs, filters, and lists.

Effect represents one-time UI actions:

- navigate to another screen;
- show a snackbar or dialog;
- open or close a bottom sheet;
- request a transient UI action.

Rules:

- Do not store one-time events in State.
- Do not add flags such as `showSnackbar`, `navigateToDetails`, or
  `closeBottomSheet` to State.
- Emit effects separately from State.
- Widgets listen to effects and execute UI-only actions.
- Do not pass `BuildContext`, `Navigator`, `ScaffoldMessenger`, or dialog logic
  into Cubit, Domain, or Data.

## Patterns

Presentation patterns:

- Use debounce in Cubit/Bloc when coordinating fast UI input, such as search
  text, filters, or repeated taps.
- Use take-latest/restartable behavior in Cubit/Bloc when only the newest UI
  request should update the screen.
- For Bloc, prefer event transformers for debounce and restartable/take-latest
  behavior.
- For Cubit, implement equivalent orchestration with timers, request tokens, or
  cancellation, then call a use case.
- Side effects belong to the Effect flow. Widgets listen to effects and execute
  UI-only actions.
- Do not implement UI input debounce inside repositories or data sources.

Data patterns:

- Repository implementations coordinate data sources and mappers.
- DTOs, request/response models, and mappers belong to Data.
- Retry, timeout handling, request cancellation, and API rate-limit protection
  belong to Data or repository implementations when they handle technical
  failures.
- Data may use HTTP-level cancellation such as Dio cancel tokens, but Cubit/Bloc
  still owns which screen request is current.

Shared patterns:

- Use Dependency Injection for object graph wiring.
- Use Singleton or Lazy Singleton only for stateless services, API clients,
  repositories, and other dependencies that are safe to share.
- Do not make Cubits, States, Effects, params, DTOs, or entities singletons.
- Use functional error handling through the project result type, currently
  `DataState<T>`.

## Domain Layer

Domain owns product rules and is independent from UI and APIs.

Allowed here:

- entities;
- params;
- domain errors/failures;
- use cases;
- repository interfaces.

Rules:

- A use case performs one business action.
- A use case depends only on repository interfaces and other domain types.
- Repository interfaces describe what data is needed, not how it is fetched.
- Domain must not import Flutter, Dio, Retrofit, json annotations, DTOs, data
  sources, repository implementations, or DI setup.
- Domain models should be immutable unless mutation is clearly required.

## Data Layer

Data owns technical implementation:

- REST requests;
- local database or storage access;
- SDK integrations;
- DTO/request/response models;
- mapping between DTOs and entities;
- conversion of network/storage errors into domain-facing failures.

Rules:

- Repository implementations live in Data and implement Domain repository
  interfaces.
- Repository implementations call data sources and mappers.
- DTOs must not leak into Domain or Presentation.
- Repositories expose domain entities, params, and failures at their boundary.
- Keep serialization and parsing inside Data.
- Handle API failures explicitly; do not silently swallow exceptions.

## Mapping

Use explicit mapping between Data and Domain:

```text
DTO <-> Mapper <-> Entity
```

Rules:

- Do not make DTO classes extend domain entities.
- Prefer explicit `toEntity()` / mapper functions over inheritance.
- Keep API field names and JSON annotations in DTOs only.
- Keep product-facing names and rules in Domain entities.

## Dependency Injection

Use GetIt + Injectable for dependency wiring when DI is needed.

Rules:

- Register Cubits, use cases, repository bindings, data sources, and external
  clients through DI.
- Bind each repository interface to its Data implementation.
- Do not instantiate repositories, use cases, or data sources manually inside
  widgets.
- Keep DI setup out of Domain.

## Imports

Use `package:riki_morty_wiki/...` imports for Dart files inside `lib`.

Use relative paths only for `part` files, for example:

```dart
part 'character_dto.g.dart';
```

## Flutter And Dart

- Use null-safe, strongly typed Dart.
- Prefer `const` constructors and widgets where useful.
- Keep widgets focused and composable.
- Extract repeated or substantial UI into widgets.
- Use trailing commas where they improve formatting.
- Avoid unnecessary abstractions and redundant variables.
- Document only public APIs or non-obvious decisions. Do not add comments that
  merely repeat the code.

## UI And Performance

- Match the existing theme, spacing, navigation, and component style.
- Use lazy lists such as `ListView.builder` for larger collections.
- Avoid expensive work in `build()`.
- Avoid unnecessary rebuilds; use focused Bloc builders/listeners where useful.
- Avoid hardcoded strings when the project uses localization.

## Testing

- Add or update tests when behavior changes.
- Prefer unit tests for use cases, mappers, repositories, and Cubits.
- Prefer widget tests for UI rendering and interaction.
- Keep tests scoped to the behavior being changed.
- Do not remove tests just to make the suite pass unless explicitly requested.

## Dependencies

- Prefer dependencies already present in `pubspec.yaml`.
- Do not add packages unless the task requires it.
- When adding a package, explain why and choose a maintained option.
- Run `flutter pub get` after dependency changes.

## Verification

Before finishing code changes:

- format changed Dart files;
- run `flutter analyze` or a focused analyzer command;
- run relevant tests when practical;
- clearly state what was and was not verified.

## Response Expectations

When reporting completed work:

- summarize what changed;
- list important files touched;
- mention assumptions or tradeoffs;
- state verification results.
