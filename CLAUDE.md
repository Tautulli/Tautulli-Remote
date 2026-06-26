# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tautulli Remote is a Flutter mobile app (iOS & Android) that serves as a companion for [Tautulli](https://tautulli.com/), a Plex monitoring tool. Current version: 3.5.1+183.

## Commands

```bash
# Run the app
flutter run

# Build
flutter build apk          # Android
flutter build ipa          # iOS

# Analyze / lint
flutter analyze

# Code generation (run after changing JSON models or adding features)
dart run build_runner build --delete-conflicting-outputs

# Localization codegen — BOTH commands must be run together
dart run easy_localization:generate -S assets/translations -O lib/translations
dart run easy_localization:generate -S assets/translations -s en.json -O lib/translations -f keys -o locale_keys.g.dart
# The second command requires -s en.json; omitting it generates only ~295 of 433 keys.

# Shorebird code push (production updates without app store review)
shorebird release android
shorebird release ios
```

There are no automated tests in the repository.

## Architecture

The app follows **Clean Architecture** with **BLoC** state management, organized into 19 feature modules under `lib/features/`. The `image_url` feature is a shared service (no presentation layer) that constructs Tautulli `pms_image_proxy` URLs consumed by all other features for artwork. Each feature has three layers:

```
feature_name/
├── data/
│   ├── datasources/     # API + local storage implementations
│   ├── models/          # JSON-serializable models (json_serializable codegen)
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Core domain models (no serialization)
│   ├── repositories/    # Abstract repository interfaces
│   └── usecases/        # Single-responsibility business logic; return Either<Failure, T>
└── presentation/
    ├── bloc/            # BLoC events/states/blocs
    ├── pages/           # Full-screen widgets
    └── widgets/         # Reusable UI components
        └── cupertino/   # iOS-style variants of Material widgets
```

**Dependency injection** is handled by GetIt in `lib/dependency_injection.dart`. Datasources, repositories, and usecases are registered as lazy singletons. BLoCs are mostly registered as `registerFactory` (new instance per page); only a handful (e.g. `SettingsBloc`, `ActivityBloc`) are lazy singletons. When adding a new feature, register all its components in this file.

**Functional programming:** Usecases return `Either<Failure, T>` from the `dartz` package. Failures are defined in `lib/core/error/` and mapped to user-facing messages in `lib/core/helpers/failure_helper.dart`.

**`imageUrl.getImageUrl()` is synchronous URI construction, not an HTTP call.** The `pms_image_proxy` path in `call_tautulli.dart` short-circuits before any network I/O and returns a locally-constructed `Uri` from the server's connection parameters. Sequential `await` calls on it per item are fine — there is no network round-trip.

## Dual UI (Material & Cupertino)

The app supports both Material (Android) and Cupertino (iOS) styles, controlled by the `AppStyle` setting. Key implications:

- `lib/app_framework.dart` selects between `_MaterialFramework` and `_CupertinoFramework`
- Feature widgets that differ between platforms live in a `cupertino/` subfolder alongside their Material counterpart
- Use `flutter_platform_widgets` utilities when a single widget can adapt automatically; create explicit `cupertino/` variants when the UI differs significantly
- Routes are defined in both `materialRoutes` and `cupertinoRoutes` maps in `app_framework.dart`
- **Icons:** Material widgets use `font_awesome_flutter` (`FaIcon`/`FaIconData`); Cupertino widgets use `CupertinoIcons`. `lib/core/helpers/icon_helper.dart` maps domain types (e.g. `MediaType`, playback state strings) to `FaIconData` for the Material side

When fixing a bug in a `material_style_` file, always check the corresponding `cupertino_style_` file for the same bug (and vice versa). Both UI stacks are maintained in parallel and bugs are frequently duplicated.

## State Management (BLoC)

- All state management uses `flutter_bloc`
- BLoC statuses use the `BlocStatus` type from `lib/core/types/bloc_status.dart`
- BLoCs are provided at the page level via `BlocProvider` and accessed with `context.read<>()` / `context.watch<>()`
- `Equatable` is used on all events and states for equality comparisons

**`Equatable.props` must include every field.** If a field is omitted, `BlocBuilder` will not rebuild when that field changes — the failure is silent and hard to diagnose. This applies to models, states, and events alike.

**`SettingsSuccess` framework guarantee.** Both `_MaterialFramework` and `_CupertinoFramework` gate all child content behind `if (state is SettingsSuccess)` in their `builder:` callbacks. `tautulli_remote.dart` also `await`s `stream.firstWhere((s) => s is SettingsSuccess)` before dispatching any follow-on events. No page, handler, or `initState` can be reached before `SettingsSuccess` is established. The `state as SettingsSuccess` pattern throughout the UI is intentionally safe — it is not a missing type guard.

## Key Conventions

- **Line length:** 120 characters (configured in `analysis_options.yaml`)
- **Trailing commas:** Preserved (formatter respects existing commas)
- **Const:** Prefer const constructors and declarations everywhere
- **Branches:** All PRs target `develop`, not `main`
- **Localization:** All user-facing strings must use `easy_localization` — no hardcoded English strings. Translation files are in `assets/translations/`; the codegen loader is at `lib/translations/codegen_loader.g.dart`

**`PrimaryScrollController` ownership:** When a widget uses `PrimaryScrollController.of(context)` rather than creating its own controller, do not call `.dispose()` on it — the ancestor owns it. Assign the reference in `didChangeDependencies()`, not `build()`, and only call `.removeListener()` in dispose.

## SSL Certificate Pinning

`lib/main.dart` overrides `HttpClient` with a custom `MyHttpOverrides` that allows self-signed certificates by comparing the PEM hash against a user-configured allowlist. This is how users with self-hosted Tautulli instances using custom certs connect without errors.

## Notifications & App Lifecycle

`lib/tautulli_remote.dart` handles app-level initialization: OneSignal push notifications, FLog structured logging, Shorebird code-push update checks, and device re-registration. OneSignal notification actions (e.g., "watched") are routed to specific pages from here.

## Persistence (Two-Tier Storage)

- **SQLite** (`lib/core/database/`) — stores server configurations (connection addresses, tokens, custom headers). Managed by `DBProvider` singleton using `sqflite`.
- **SharedPreferences** (`lib/core/local_storage/`) — stores all other app settings (theme, app style, active server, etc.).

When adding server-level fields, update the SQLite schema and `ServerModel`. When adding global app settings, use `LocalStorage`/SharedPreferences.

## Multi-Server & Connection Failover

Each server has a primary and optional secondary connection address. `lib/core/api/tautulli/connection_handler.dart` transparently fails over to the secondary address when the primary fails and updates `primaryActive` on the server record. All API calls go through `ConnectionHandler` → `CallTautulli`. Individual Tautulli API endpoints live in `lib/core/api/tautulli/endpoints/`, one file per API command.

## Shared Core Widgets

`lib/core/widgets/` contains shared UI primitives used across features:
- `base/` — platform-agnostic widgets (e.g., `ImageGradientBackground`, `MediaTypeIcon`, `SensitiveText`)
- `material/` and `cupertino/` — platform-specific variants of shared components

Prefer these over reimplementing similar functionality inside a feature.

## API Response Parsing

**`Cast` utility** (`lib/core/utilities/cast.dart`) — all coercions from raw API strings/ints to domain types (enums, booleans, etc.) go through static methods here (e.g., `Cast.castStringToMediaType`, `Cast.castToBool`). Use `Cast` methods in `@JsonKey` annotations and model constructors rather than writing ad-hoc parsing logic.

**Datasource return convention** — datasources that call Tautulli return `Tuple2<T, bool>` from `dartz`, where the `bool` indicates whether the **primary** connection was active for that response. Repository implementations use this to update `primaryActive` on the server record.

**`Tuple2` success flags** — when a datasource returns `Tuple2<bool, bool>`, `value1` is the operation success flag and `value2` is `primaryActive`. Reaching the `Right` branch only means the HTTP call succeeded, not that Tautulli's operation itself succeeded. Always check `value1` before emitting a success state from a BLoC.

## Custom Package Forks

Three dependencies are private Git forks maintained in the `TheMeanCanEHdian` GitHub org:
- `f_logs` — structured logging (branch: `tautulli-remote`)
- `flutter_inner_drawer` — inner navigation drawer
- `simple_moment` — relative time formatting (branch: `tautulli-remote`)

If these packages need changes, fork or modify them in their respective repos; don't vendor the source directly.

## Code Generation

Several files are auto-generated and should not be manually edited:
- `lib/translations/codegen_loader.g.dart` — localization loader (generated by `easy_localization:generate`)
- `lib/translations/locale_keys.g.dart` — localization key constants (generated by `easy_localization:generate`)
- `*.g.dart` files alongside models — JSON serialization via `json_serializable`

## Recurring Pitfalls

These are non-obvious issues that have caused real bugs in this codebase. Check for them when writing or reviewing code in the affected areas.

**`copyWith` null is a no-op.** All `copyWith` methods use `value ?? this.field`. Passing `null` as a named argument preserves the existing field value — it does not clear it. If you need to clear a nullable field, the current `copyWith` signatures cannot express it; you must construct a new object directly or add a sentinel wrapper.

**`Either.fold` closure variable shadowing.** If an outer variable is named `failure` and the fold closure parameter is also named `failure`, any assignment inside the closure (`failure = someValue`) is a self-assignment — the outer variable is never updated and `state.failure` will always be null on error. Rename the outer variable (e.g. `emittedFailure`) to avoid this. This exact pattern caused C-8 (`UserStatisticsBloc`) and H-14 (`LibraryStatisticsBloc`).

**Dart type promotion does not apply to globals or class fields.** Null-checking a file-level variable or instance field does not promote its type inside the `if` block. Copy it to a local variable first: `final id = globalIdCache; if (id == null) return; // id is non-null here`.

**`throw SomeException` throws the `Type`, not an instance.** Always use `throw SomeException()`. Throwing a `Type` object is caught by generic `catch (e)` but not by typed catch clauses, so the error is silently mishandled.
