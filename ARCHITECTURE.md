# Architecture

This document explains how the `dpp` app is put together — what each folder is
for, how a screen ends up on your device, and where data comes from. It
assumes no prior Flutter experience; Flutter/Dart-specific terms are
explained the first time they show up.

A companion visual is at [`docs/module-map.html`](docs/module-map.html) —
open it in a browser for a diagram of everything described below.

## What this app is

**dpp** ("Digital Product Passport") shows the environmental footprint of
3D-printed parts and the materials used to make them: energy used, CO₂
emissions, recycled-material percentage, and so on. A user scans a QR code
or browses a list to pull up a **Product** (a manufactured part) or a
**Material** (the filament/feedstock it was made from), each backed by a
data sheet compliant with the **AAS** standard (Asset Administration Shell —
an industry format for describing a physical asset's data digitally; see
[Key concepts](#key-concepts) below).

The app works two ways, chosen automatically at every launch:

- **Online** — pulls live data from a BaSyx server (the reference
  implementation of the AAS standard) on the local network.
- **Offline** — if that server doesn't answer, it transparently falls back
  to a small set of bundled sample products so the app is never empty. A
  status badge in the **More** tab shows which mode is currently active.

## Three-minute Flutter primer

If you've never touched Flutter, here's the minimum vocabulary to read this
codebase:

- **Dart** is the programming language; **Flutter** is the UI framework.
  Every `.dart` file under `lib/` is Dart source.
- A **widget** is a piece of UI — as small as a single piece of text, as
  large as an entire screen. Screens are built by nesting widgets inside
  each other, similar to nesting HTML elements.
- **`lib/main.dart`** is the single entry point — this is where the app
  starts, exactly like `main()` in most other languages.
- This project uses a package called **GetX** (imported as `package:get`)
  for three jobs at once: page routing (moving between screens),
  state management (widgets automatically redrawing when data changes, via
  small reactive values called `Rx`/`.obs`, watched in the UI with a
  wrapper called `Obx`), and dependency injection (`Get.put`/`Get.find`,
  used to make one shared instance of a class reachable from anywhere,
  without having to pass it down through every widget by hand).
- **Hive** is a small local database (like a lightweight key-value store)
  used to persist things across app restarts — login session, theme
  preference, scan history.
- **l10n** is short for "localization" — the app supports English and
  German; every piece of user-facing text is looked up by key from
  generated translation files instead of being hardcoded.

## Startup sequence

Everything begins in [`lib/main.dart`](lib/main.dart), in order:

1. `ProductService.init()` and `MaterialService.init()` load the bundled
   sample catalog (JSON files under `assets/data/`) into memory.
2. `BasyxSyncService().syncOnAppStart()` tries the real server, falls back
   to offline mock data if it's unreachable, and folds whatever it found
   into the same `ProductService`/`MaterialService` catalog — see
   [Data flow: the BaSyx sync](#data-flow-the-basyx-sync) below.
3. `HiveService.init()` opens the local database boxes.
4. A handful of controllers (theme, auth, locale, history) are registered
   with GetX as app-wide singletons via `Get.put(..., permanent: true)`.
5. `runApp(MyApp(...))` finally hands off to Flutter to draw the first
   frame, landing on the onboarding screen, sign-in screen, or straight to
   the home shell, depending on whether onboarding has been seen before and
   whether a session is already saved in Hive.

## Two layers of navigation

This app has **two different, independent navigation mechanisms** — worth
understanding up front so the folder names below make sense:

1. **Top-level routing** (real GetX routes, defined in
   [`lib/app/routes/app_pages.dart`](lib/app/routes/app_pages.dart)):
   `Onboarding` → `SignIn` → the home shell (route name
   `NAVIGATION_HOME`, path `/`). Only three destinations exist at this
   level.
2. **The bottom tab bar**, entirely inside that single home-shell route.
   Tapping Home / History / Profile / More does **not** navigate to a new
   route — it just swaps which widget `AppHomeController.tabBody` (an
   `Rx<Widget>`) is currently holding, and the screen listens to that value
   via `Obx` and redraws. The floating scan button in the middle *is* a
   real `Navigator.push`, since it's a one-off full-screen flow rather than
   a persistent tab.

## Folder-by-folder guide

```
lib/
  main.dart                  — app entry point, startup sequence above
  app/
    routes/                  — the 3 top-level GetX routes
    modules/                 — one folder per screen/feature (see below)
    services/                — non-UI logic: data loading, sync, storage
    data_model/              — plain Dart classes describing the app's data
  config/                    — theme, small reusable UI/animation helpers
  l10n/                      — translation source (.arb) + generated code
assets/                      — bundled images, sample data, fonts, icons
test/                        — automated tests (standard Flutter location)
ios/, android/, windows/, …  — one folder per platform Flutter can build for
```

### `lib/app/modules/` — one folder per screen or feature

| Folder | What it holds |
|---|---|
| `footprint/` | The home **shell** itself (`AppHomeScreen`/`AppHomeController`/`AppHomeBinding`, the tab-swapping logic described above, and the bottom bar) **plus** most of the actual detail screens: Product detail, Material detail, History/Favorites, Profile, and More. The name comes from the app's subject matter (carbon *footprint*), not from "footer" or anything navigation-related. |
| `home/` | Just the **content** of the Home tab (the dashboard view) — kept separate from `footprint/` since it's swapped in as one of several tab bodies. |
| `auth/` | Sign-in screen + `AuthController` (see [Auth](#auth-there-is-no-backend-login) below). |
| `onboarding/` | The first-run carousel. |
| `scanner/` | The QR-scan screen pushed by the bottom bar's scan button. |
| `history/` | Just the controller (`HistoryController`) for scan history/favorites — the actual screen lives under `footprint/views/history/`. |
| `settings/` | `ThemeController` (light/dark mode) and `LocaleController` (EN/DE). |
| `navigation/drawer_links/` | Help / Feedback / Invite-a-friend screens, reachable from the More tab. Named `navigation` because the app used to have a slide-out drawer menu; that drawer is gone (everything moved into the More tab), but the destination screens it used to open kept this folder name. |

Each module generally has some subset of `controllers/` (GetX logic +
state), `views/` (the widgets/screens themselves), and `bindings/`
(wires up which controller a view needs — only `footprint/` currently
uses one).

### `lib/app/services/` — logic with no UI

| Folder | What it holds |
|---|---|
| `catalog/` | `ProductService` and `MaterialService` — the in-memory catalog every screen reads from. Loaded once at startup (bundled samples) and added to as sync brings in more. `machineServiceJson55.dart` is an older, narrower JSON reader kept only because a test still exercises it. |
| `basyx/` | Everything about talking to (or standing in for) a BaSyx server — see the next section. |
| `hive/` | `HiveService` — the local database: session, theme/locale prefs, onboarding-seen flag, and history/favorites. |

### `lib/app/data_model/` — plain data classes

| Folder | What it holds |
|---|---|
| `product/` | `Product` — a manufactured part, plus the logic to build one from an AAS JSON response. |
| `material/` | `Material` — a filament/feedstock passport, structured as 7 sections (identification, manufacturer, composition, physical data, sustainability, data quality, documents). |
| `history/` | `HistoryEntry` — one row of scan/view history, with a `HistoryItemType` (`product` or `material`). |
| `api/` | The generic AAS/Submodel JSON shapes (`base_aas_model.dart`, `generic_submodel.dart`) that `Product`/`Material` are parsed out of. The `.g.dart` files next to them are code-generated (by `json_serializable`, a build-time tool) — never hand-edit those, they're regenerated from the `.dart` file next to them. |

### `lib/config/`

`theme/` holds the light/dark `ThemeData` and a small color-extension
helper; `utils/` holds small standalone helpers — responsive breakpoints,
animation curves/durations, and the bottom-tab icon list.

## Data flow: the BaSyx sync

This is the most "backend-shaped" part of the app, so it's worth walking
through end to end. All of it lives in `lib/app/services/basyx/`:

```
BasyxRepository            (abstract: fetchShellList / fetchShellPackage / fetchThumbnail)
   ├── BasyxRemoteRepository   — real HTTP calls to a BaSyx server
   └── BasyxMockRepository     — same three methods, reading bundled JSON assets instead
```

`BasyxSyncService.syncOnAppStart()` (called once, from `main.dart`) does
this every time the app opens:

1. Try `BasyxRemoteRepository().fetchShellList()` against `BasyxConfig.baseUrl`,
   with a 10-second timeout.
2. **Succeeds** → keep using the remote repository for the rest of this
   sync, set `BasyxSyncService.isOnline = true`.
3. **Fails** (server down, wrong network, timeout, ...) → switch to
   `BasyxMockRepository`, which reads `assets/basyx_mock/shells_index.json`
   and the package files it points to, set `isOnline = false`.
4. For each "shell" (BaSyx's term for one product's top-level record) it
   downloads the full package, caches it to disk via `BasyxLocalCache` (so
   next launch can skip re-downloading anything still within
   `BasyxConfig.cacheTtl`), and registers it into `ProductService` — and,
   if the package includes a recognizable material-data submodel, into
   `MaterialService` too.
5. If *even the fallback* fails (mock assets missing, cache directory
   unavailable, etc.), it falls back one level further to whatever was
   cached from the last successful sync, so the app still shows something
   instead of nothing.

`BasyxSyncService.isOnline` is a static `Rx<bool?>` — any widget can watch
it directly (no dependency injection needed for this one value); the More
screen's status badge is the only current reader.

## Auth: there is no backend login

`AuthController` checks credentials against a single hardcoded
username/password (`admin`/`admin`) — there is no login server. A signed-in
session is saved to Hive and restored on next launch. A "continue as
guest" path is also available; guest sessions are deliberately **not**
persisted, and a guest's scan history/favorites live in memory only for
that session (see `HistoryController._reload`).

## Key concepts

- **AAS (Asset Administration Shell)** — the industry-standard JSON format
  this app's data comes in. Think of it as "a standardized digital
  datasheet for one physical thing." One AAS can reference several
  **submodels** (e.g. `Nameplate`, `CarbonFootprint`,
  `MaterialData_DINSPEC91481`), each holding a group of related fields.
  `lib/app/data_model/api/` models this generically; `Product`/`Material`
  know how to pull the specific fields they care about out of it.
- **Shell** (in `BasyxRepository`/`ShellDescriptor`) — BaSyx's word for one
  top-level AAS record in the "menu" you get back from `fetchShellList()`,
  before you've fetched its full content.
- **BaSyx** — the specific open-source server implementation of the AAS
  standard this app talks to (or mocks).
- **Product vs. Material** — a `Product` is a finished/in-progress part; a
  `Material` is what it's made from. A product optionally links to a
  material via `Product.materialId`.

## Running / building

Standard Flutter commands apply — `flutter pub get`, `flutter run`,
`flutter build ios` / `flutter build apk`, `flutter test`. There's no
custom build tooling beyond what Flutter provides out of the box.

### Rebuilding on iOS after an edit

Start a session once — `flutter run -d <device-id>` (find the id with
`flutter devices`) — and leave it running; it watches your files instead of
needing to be restarted per edit. While it's running:

| Key | Does | Use when you changed |
|---|---|---|
| `r` | **Hot reload** — patches the running app in ~1s, state kept | Dart code in `lib/` — most edits |
| `R` | **Hot restart** — reruns `main()` fresh, state resets | Dart that only runs once at startup, or `r` didn't take |
| `q` | Quit the session | done for now |

`r`/`R` only patch Dart code. Stop the session and run `flutter run` again
from scratch after editing anything under `ios/` (`AppDelegate.swift`,
`Info.plist`, `project.pbxproj`, `Podfile`), after changing `pubspec.yaml`
dependencies, or after adding a native plugin.

`flutter build ios --no-codesign` compiles without installing/running —
useful to check "does it build" without touching a device. `flutter clean`
clears build caches; reach for it only when something's stuck, since
everything rebuilds from scratch afterward.

If a build ever fails with `database is locked` / "two concurrent builds",
a previous `flutter run`/`xcodebuild` didn't fully exit — check
`ps aux | grep -iE "xcodebuild|flutter run"` and kill any stale ones.
