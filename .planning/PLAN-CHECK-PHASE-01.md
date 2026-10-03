# PLAN CHECK — Phase 1: Foundation, Security & Database Setup

**Project:** Arham Autos POS & Management System v1.0.0
**Docs checked:** `docs/IMPLEMENTATION_PLAN.md`, `docs/TRD.md`, `docs/PRD.md` (read in full)
**Checked on:** 2026-10-04 · **Environment:** Windows, Flutter 3.41.6 stable, Dart 3.11.4, git 2.52, no repo/code yet
**Checker:** gsd-plan-checker (works back from the goal; nothing has been executed yet)

---

## VERDICT: **FAIL** (as written)

The plan can't be executed as written. **7 BLOCKERs** make Phase 1 either impossible to build or insecure by design. The biggest are the encryption-key bootstrap problem, an outdated encryption stack in the TRD, an undefined web scope, an undecided state-management choice, and a DB schema that Phase 1 would lock in before its known gaps are fixed. **Each BLOCKER has a concrete default resolution.** If the executor adopts the **Phase-1 Execution Contract** (§5), Phase 1 can go ahead. With the contract applied, the effective verdict is **PASS_WITH_WARNINGS**.

### Goal-backward truths (what must be TRUE when Phase 1 is done)

| # | Truth | Plan task that makes it true | Status |
|---|---|---|---|
| T1 | A Flutter app builds and runs as a Windows x64 desktop app, and the web target compiles | Task 1 | ⚠️ Web scope undefined (B3); the `&` in the workspace path is a build risk (W17) |
| T2 | The DB file is encrypted at rest with AES-256, and the app can open it on every launch without a human typing a secret | Task 2 | ❌ Key source/storage undefined (B1); TRD API is obsolete (B2) |
| T3 | The app detects first run reliably, including partial or crashed setups and a moved DB or profile | (implicit) | ❌ First-run state is stored inside the encrypted DB (B1) |
| T4 | The wizard sets language → backup folder → Master Key (+ printable certificate) → Manager account, then commits atomically | Task 3 | ⚠️ Needs pdf/printing (Phase 3) and i18n (Phase 5) pulled forward (W3, W4) |
| T5 | Credentials are stored as slow, salted hashes, and brute force is throttled | Task 2/4 | ❌ Salted SHA-256 for a 4–6 digit PIN, no lockout (B6) |
| T6 | A user logs in with a PIN (or the Manager with a password) and gets a session with a role | Task 4 | ⚠️ A PIN alone can't identify the user (W7) |
| T7 | Routes and actions are guarded by the Manager/Operator permission matrix (PRD §2) | Task 4 | ⚠️ No task creates Operator accounts, so Operator RBAC can't be tested (W6) |
| T8 | The app locks after the configured idle time (5/10/15/30 min) | **none** | ❌ Acceptance criterion with no task and no default (W2) |
| T9 | The full v1 schema exists with correct types and constraints, so later phases don't need risky migrations | Task 2 | ❌ Schema gaps and money stored as REAL (B5) |
| T10 | Tests prove T2–T8 | **none** | ❌ No test tasks (W5) |

---

## 1. Dimension results

| # | Dimension | Result |
|---|---|---|
| 1 | Requirement coverage | ❌ PRD-SEC-02 idle lock has no task. "Settings (User Management, Auto-Lock Timer)" from PRD §2 is in **no phase**. The audit logging needed for Phase 1 events is not tasked. There is no manager credential recovery. |
| 2 | Task completeness | ❌ Tasks 1–4 have no done-conditions or file deliverables. Task 2 ("implement Drift schema") doesn't say whether that means the full schema or only the security tables. |
| 3 | Dependency correctness | ❌ The Print Certificate needs `pdf`/`printing` (Phase 3). The language step needs i18n scaffolding (Phase 5). Encrypted-backup portability (Phase 5) depends on the Phase 1 key design. |
| 4 | Cross-document consistency | ❌ PIN length is 4 in the plan but 4–6 in the PRD/TRD. "16-digit" vs "16-char alphanumeric". Factory-reset table names in the PRD don't exist in the TRD. TRD §4 numbering is broken (2, 2, 3). TRD says JSON l10n while `flutter_localizations` uses ARB. "Kotsmaba" vs "Kot Samba". |
| 5 | Technical feasibility | ❌ The TRD encryption API (`open.databaseFactory` + `sqlite3_flutter_libs` compiled with SQLCipher) is obsolete. The key bootstrap has a chicken-and-egg problem. PIN hashing is weak. Web vs `dart:io`/secure storage/folder picker is unresolved. |
| 6 | Undecided choices | ❌ State management is "Bloc/Cubit or Riverpod". Excel library is "syncfusion_flutter_xlsio or csv". Credit-limit `0.0` means either "unconstrained or default threshold". The idle default is undefined. |
| 7 | Acceptance criteria | ⚠️ Not measurable ("detects first run", "locks when idle timer expires"). Needs concrete, testable statements (see Contract §5.12). |
| 8 | Scope sanity | ⚠️ One week is tight once the missing work is added (idle lock, user management, i18n scaffold, PDF certificate, tests, full schema). It fits only if web is compile-only and business-table DAOs are deferred. |

---

## 2. Verification of the parent's suspected issues

| Suspected issue | Verdict | Evidence / nuance |
|---|---|---|
| SQLCipher vs web incompatibility | **CONFIRMED (with nuance)** | Since drift 2.32 / sqlite3 3.x, encryption on native comes from build hooks (`hooks: user_defines: sqlite3: source: sqlite3mc` or `sqlcipher`). `sqlcipher_flutter_libs` is obsolete. A `sqlite3mc.wasm` also exists for the web. **But** on the web there is no secure place for the key, no real file system, no `getDirectoryPath`, and no `VACUUM INTO` to a user folder. An encrypted offline web build is not meaningful for v1. → B3 |
| Key source unclear / chicken-and-egg | **CONFIRMED** | TRD §4: "PBKDF2 … using a secret salt established during the first-run wizard". No passphrase source is named and no key storage is defined. First-run state (`system_configs`) is inside the encrypted DB. Backups encrypted with a machine-bound key can't be restored after hardware loss. → B1 |
| Salted SHA-256 for a 4–6 digit PIN is brute-forceable | **CONFIRMED** | At most 10⁶ PINs means instant offline cracking with fast hashes. No lockout is specified anywhere. → B6 |
| PIN length inconsistency | **CONFIRMED** | Plan Task 3 Step 4 says "4-digit". PRD-SEC-01 and TRD `users.pin_hash` say "4–6 digit". → W1 |
| Idle auto-lock in acceptance criteria but no task or default | **CONFIRMED** | The PRD gives options 5/10/15/30 but no default. The TRD mentions a "Window-level hook", which isn't needed (an app-level listener is enough). → W2 |
| Print Certificate needs pdf/printing (Phase 3); i18n (Phase 5) | **CONFIRMED** | Cross-phase dependencies. → W3, W4 |
| State management undecided | **CONFIRMED** | TRD §1 layer 2. → B4 |
| Money as REAL, missing schema items, TRD numbering | **CONFIRMED + extended** | Every amount column is REAL. Missing: part category, unit, employee CNIC, payroll, defective/claims stock, payments with mode, cost snapshot on sale lines (COGS impossible without it), GRN status, credit-override audit field, return-claim reference on ledgers. TRD §4 items are numbered 2, 2, 3. → B5, W13 |
| No testing tasks | **CONFIRMED** | → W5 |

---

## 3. Issues table

| ID | Severity | Dimension | Location | Finding | Recommended resolution (default) |
|---|---|---|---|---|---|
| B1 | BLOCKER | Feasibility / Security | TRD §4.2 (first "2."), §2.1 `system_configs`; Plan P1 T2 | The source and storage of the DB encryption key are undefined ("PBKDF2 with secret salt" from what passphrase?). First-run state lives inside the DB it is needed to open. Backups encrypted with a machine-bound key become unrecoverable after hardware or Windows-profile loss. | Use **envelope encryption**. Generate a random 256-bit DEK at setup and store it with `flutter_secure_storage` (Windows: AES-GCM file whose key sits in Windows Credential Manager). Wrap the DEK with a KEK = PBKDF2-HMAC-SHA256(Master Key, salt) into a plaintext `keystore.json` stored next to the DB. Detect first run from **outside** the DB (presence of DB file, DEK and temp files). Phase 5 backups must carry `keystore.json`. Full state machine in Contract §5.4. |
| B2 | BLOCKER | Feasibility / Consistency | TRD §1 Data layer, §4 "open.databaseFactory … sqlite3_flutter_libs compiled with SQLCipher"; Plan W1 "SQLCipher" | Obsolete API and package. As of drift ≥2.32 + sqlite3 3.x, `sqlcipher_flutter_libs` is no longer needed and `open.databaseFactory` doesn't exist. SQLite3MultipleCiphers' **default cipher is ChaCha20-Poly1305, not AES-256**, which would silently break the PRD's AES-256 promise. | Use `drift` 2.35.x + `sqlite3` 3.x with `hooks: user_defines: sqlite3: source: sqlite3mc`. Before the key, run `PRAGMA cipher='sqlcipher'; PRAGMA legacy=4;` (SQLCipher-v4 format: AES-256-CBC + HMAC-SHA512). Verify at runtime that `PRAGMA cipher` is non-empty and **throw** (not just assert) if it isn't. Do not add `sqlcipher_flutter_libs` or `sqlite3_flutter_libs`. |
| B3 | BLOCKER | Feasibility / Scope | Plan P1 T1 "Windows Desktop and Web"; TRD §1, §5.2 | Web scope is undefined. `dart:io`, `NativeDatabase`, secure key storage, the folder picker and file backups don't work (or aren't secure) in a browser. Writing shared code without platform seams will break `flutter build web`. | v1 web = **compile-readiness only**. `flutter build web` must succeed. On web the app boots to a localized "Desktop edition required for v1.0" screen. All `dart:io` and native DB code sits behind conditional imports (`connection_native.dart` / `connection_web.dart`). Domain and presentation layers import only interfaces (repository pattern, as TRD §5.2 intends). |
| B4 | BLOCKER | Undecided choice | TRD §1 layer 2 "Bloc / Cubit or Riverpod" | Undecided. This shapes every file in Phase 1. | **Riverpod**: `flutter_riverpod` 3.x without code generation (only drift uses build_runner). Pair it with `go_router` and guards in `redirect` driven by a session provider. |
| B5 | BLOCKER | Consistency / Feasibility | TRD §2 (all tables) vs PRD §3.4–3.8; Plan P1 T2 | Phase 1 Task 2 implements the schema, but the TRD schema: (a) stores money as REAL; (b) lacks PRD fields and tables (part category, unit, employee CNIC, payroll ledger, defective/claims stock, payments with mode, supplier payment vouchers); (c) has no cost snapshot on `sale_items`, so COGS and gross profit (PRD-DSH-01, REP-01) can't be computed correctly once moving-average cost changes; (d) `sale_items ON DELETE CASCADE` contradicts invoice immutability; (e) `customer_ledger_entries` can't reference a return claim; (f) GRN has no draft/posted status even though the plan says "auto-update stock upon posting"; (g) no field records the credit-limit Manager override. | Implement the **full corrected v1 schema in Phase 1** (schemaVersion 1, drift schema export enabled), using the corrections in Contract §5.7. Money is an INTEGER in **paisa**. Add the missing tables and columns, immutability triggers and indexes. Business DAOs stay in their own phases. |
| B6 | BLOCKER | Security | TRD §2.1 `users.pin_hash` "Salted SHA-256"; TRD §4.3 Master Key "hashed with SHA-256" | Fast hashes for low-entropy secrets and no lockout. The unsalted SHA-256 of the Master Key is also used as a verifier and can't double as a KEK. | PINs and passwords use **PBKDF2-HMAC-SHA256**, 16-byte salt, ≥210,000 iterations (benchmark: 200–800 ms in release on the client PC), run in `Isolate.run`, stored as a PHC-style string. Add **persistent lockout**: after 5 failures lock for 60 s, doubling to a 15-min cap (`users.failed_attempts`, `users.locked_until`), with audit entries. Master Key: salted PBKDF2 verifier plus a separately salted PBKDF2 KEK (see §5.5). Compare in constant time. |
| B7 | BLOCKER | Task completeness / Acceptance | Plan P1 tasks & acceptance criteria | No task has a deliverable or done-condition, and the acceptance criteria aren't measurable. The executor can't know when Phase 1 is done. | Adopt the deliverables and done-conditions in Contract §5.11–5.12. |
| W1 | WARNING | Consistency | Plan P1 T3 Step 4 "4-digit PIN" vs PRD-SEC-01, TRD users "4–6" | PIN length conflict. | PRD wins: **4–6 digits**, numeric only. Reject PINs with all digits the same and strictly ascending or descending runs. |
| W2 | WARNING | Coverage | Plan P1 acceptance "locks when idle timer expires"; PRD-SEC-02; TRD §1 "Window-level Pointer & Keyboard Hook" | Idle lock has no task and no default. A Win32 global hook is unnecessary. | Add Task 5 "IdleLockService". Use an app-level `Listener` plus `HardwareKeyboard.instance.addHandler`. Read the threshold from `system_configs.idle_lock_minutes` ∈ {5,10,15,30}, **default 5**. Locking shows a lock overlay that keeps the app state; unlock with the current user's PIN or "Switch user" (logs out). The Manager can change the threshold in a minimal Settings screen. |
| W3 | WARNING | Dependency | Plan P1 T3 Step 3 "Print Certificate" vs Phase 3 `pdf`/`printing` | Cross-phase dependency. A "force print" can't be verified. | Pull `pdf` + `printing` (and `file_selector.getSaveLocation` for "Save as PDF") into Phase 1. Gate "Next" on a "Print" or "Save PDF" action **plus** a checkbox "I have stored this key safely" **plus** re-typing the last 4-character group of the key. Keep the certificate in English, Latin script only (see I5). |
| W4 | WARNING | Dependency / Consistency | Plan P1 T3 Step 1 vs Phase 5 localization; TRD §5.3 "flutter_localizations with JSON (en.json, ur.json)" | Language selection needs i18n now. `flutter_localizations` uses ARB/gen-l10n, not JSON. | Phase 1: `flutter_localizations` + `intl` + `gen-l10n` (`l10n.yaml`, `lib/l10n/app_en.arb`, `app_ur.arb`) covering only wizard, login, lock and shell strings. Setting `MaterialApp.locale` to `ur` flips to RTL automatically (no manual `Directionality`). **Bundle** Noto Nastaliq Urdu / Noto Naskh Arabic fonts as assets: the app is offline, so don't use `google_fonts` runtime fetching. Full translation and RTL polish stay in Phase 5. |
| W5 | WARNING | Coverage | Plan P1 (no tests) | No tests for security-critical code. | Add Task 6 "Phase 1 test suite" (list in §5.11). |
| W6 | WARNING | Coverage | PRD §2 "Settings (User Management, Auto-Lock Timer)"; no phase has it | Operator accounts are never created, so Operator RBAC can't be verified. | Add minimal **User Management** to Phase 1 (Manager only): create Operator (username, display name, PIN), deactivate/reactivate, reset PIN. No hard delete. |
| W7 | WARNING | Feasibility / UX | Plan P1 T4 "PINpad login" | A PIN alone can't identify the user unless PINs are unique, and enforcing uniqueness leaks other users' PINs. | Login = pick a user (tiles of active users, or type a username) → PIN pad. "Use password" toggle for the Manager. Never require PINs to be unique. |
| W8 | WARNING | Coverage / Security | PRD-SEC-01/03; no recovery flow | If the only Manager forgets their PIN or password, the app is bricked. | Add "Forgot PIN/password" on login: enter the Master Key → verify → reset Manager credentials. Audit it as `MANAGER_CREDENTIAL_RESET`. |
| W9 | WARNING | Consistency / Security | TRD §4.3; PRD-SEC-01 "16-digit alphanumeric", example `A9F4-88C1-X77B-03Q2` | "Digit" vs alphanumeric. The generation method isn't specified, which risks modulo bias. | 16 chars from `A–Z0–9` (≈82.7 bits) using `Random.secure()` with **rejection sampling**. Display as 4×4 groups with dashes. Normalize input (uppercase, strip `-`/spaces) before verification. Call it "16-character Master Key" in the UI. |
| W10 | WARNING | Security / Consistency | TRD §2.1 `audit_logs` "Immutable … survives data wipe" | Immutability isn't enforced. The FK to `users` breaks if users are ever wiped. Phase 1 events aren't defined. | Add `BEFORE UPDATE` / `BEFORE DELETE` triggers on `audit_logs` → `RAISE(ABORT)`. Add `username_snapshot` and `role_snapshot` columns. Users are never hard-deleted. Phase 1 logs: SETUP_COMPLETE, LOGIN, LOGIN_FAILED, LOCKOUT, LOGOUT, IDLE_LOCK, UNLOCK, USER_CREATE, USER_DEACTIVATE, PIN_RESET, SETTINGS_CHANGE, PERMISSION_DENIED, MASTER_KEY_RECOVERY, MANAGER_CREDENTIAL_RESET. |
| W11 | WARNING | Consistency | PRD-SEC-03 wipes `purchases`, `khata_entries` vs TRD `purchases_grn`, `purchase_items_grn`, `customer_ledger_entries`, `supplier_ledger_entries` | Table names don't exist. The reset scope for customers, suppliers, returns, adjustments, employees and routes is undefined. This affects FK design now. | Adopt TRD names. Define the Phase 5 wipe set now (all operational and master-data tables except `users`, `system_configs`, `audit_logs`). FKs must not cascade into `audit_logs`. Delete in child-to-parent order inside one transaction. |
| W12 | WARNING | Undecided choice | TRD `customers.credit_limit` "0.0 means unconstrained or default threshold" | Ambiguous, and it decides the column definition now. | `credit_limit_paisa INTEGER NULL`: **NULL = unlimited**, **0 = cash only (no credit)**, >0 = hard limit. |
| W13 | WARNING | Consistency | TRD §4 numbering "2., 2., 3."; "PBKDF2 64,000 iterations" | Numbering error. 64k is the old SQLCipher v3 default and doesn't apply to a random DEK. | Treat as: 4.1 SQLCipher config, 4.2 Backup, 4.3 Master Key. Replace the 64k figure with the KDF parameters in §5.5. Fix in the next doc revision. |
| W14 | WARNING | Feasibility | TRD §2 general | `PRAGMA foreign_keys` is off by default in SQLite. The durability ("zero corruption") claim needs explicit pragmas. | In the `setup` callback, after the key: `PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL; PRAGMA synchronous=FULL; PRAGMA busy_timeout=5000;`. |
| W15 | WARNING | Feasibility | Plan P1 T3 (no atomicity) | A crash mid-wizard leaves a half-initialized encrypted DB. | Collect all wizard data in memory and commit once, with the atomic rename as the commit point (§5.4). |
| W16 | WARNING | Feasibility | PRD-SEC-01 Step 2 | Backup folder not validated. | Validate that the folder exists and is writable (create and delete a probe file). Warn if it's on the same drive as `%APPDATA%`. Store it as `system_configs.backup_dir`. Use `file_selector.getDirectoryPath()` on Windows. |
| W17 | WARNING | Feasibility | Workspace path `…\Arham Autos Desktop & Web Suite` | The `&` and spaces in the path can break CMake/MSBuild, `flutter.bat` or native-asset hooks on Windows. | In Task 1 run `flutter build windows` straight after scaffolding. If it fails, build from a `subst`-mapped drive or a junction to a path without `&`. Don't rename the docs workspace. |
| W18 | WARNING | Scope | Plan W1 | With the added tasks (idle lock, users, i18n scaffold, PDF certificate, recovery, tests, full schema) one week is tight. | Keep web compile-only. Deliver tables, triggers and indexes for all modules, but DAOs/repositories only for the security domain. If behind schedule, move user-management polish and the password-recovery UI to the first day of Phase 2 — never skip tests or the key design. |
| W19 | WARNING | Feasibility | Phase 4 TRD `syncfusion_flutter_xlsio` | The Syncfusion Community License has revenue and team-size limits (otherwise it's commercial). | Not Phase 1. Decide before Phase 4; the default alternative is the MIT `excel` package plus `csv`. |
| I1 | INFO | Feasibility | sqlite3 hooks | Build hooks download prebuilt `sqlite3mc` binaries from GitHub releases at build time (sha256-pinned). The build machine needs internet, or use `url_pattern` with an internal mirror. | Note in the README. |
| I2 | INFO | Feasibility | Windows toolchain | Needs Visual Studio "Desktop development with C++". `flutter_secure_storage` (Windows) may also need the ATL component. | Run `flutter doctor -v` in Task 1. |
| I3 | INFO | Consistency | PRD-DSH "≤ 10" vs PRD-INV-01 per-part threshold | Use `current_stock <= min_stock_alert` (default 10). | — |
| I4 | INFO | Consistency | TRD §3 "Bagobhar Road Kotsmaba" vs TRD routes default "Kot Samba" | Spelling inconsistency. | Confirm with the client. Store shop header fields in `system_configs` (`shop_name`, `shop_address`, `shop_phone`). |
| I5 | INFO | Feasibility | TRD §3 Noto Nastaliq in PDF | The `pdf` package's complex-script shaping for Nastaliq is limited. | Phase 1 certificate: English only. Phase 3: spike Urdu rendering early, falling back to Noto Naskh Arabic. |
| I6 | INFO | Feasibility | TRD §4.2 backup "VACUUM INTO / Online Backup API" | Confirm in a Phase 5 spike that the backup output stays encrypted with sqlite3mc. | Phase 5: the backup must ship with `keystore.json`. |
| I7 | INFO | Wording | Plan P1 acceptance "stores encrypted credentials" | Credentials are **hashed**; the DB is encrypted. | — |
| I8 | INFO | Feasibility | Desktop | Two app instances against the same DB and session can cause confusing locks. | Optional: single-instance guard (named mutex) and a minimum window size via `window_manager`. |
| I9 | INFO | Feasibility | Phase 3/6 search perf (<50 ms on 50k SKUs) | Needs indexes and FTS. | Create indexes and an FTS5 table for parts in the Phase 1 schema (§5.7). The default sqlite3mc build includes `SQLITE_ENABLE_FTS5`. |
| I10 | INFO | UX | "Antigravity UI Design System" undefined | No design tokens exist. | Phase 1: a minimal `ThemeData` + `ScrollbarThemeData` (8 px thumb, always-visible track) in `lib/app/theme/`. |
| I11 | INFO | Reuse | Phase 3 credit override, Phase 4 returns | A Manager PIN step-up will be needed again later. | Build a reusable `ManagerAuthDialog` in Phase 1 (`features/auth`). |

---

## 4. Uncovered requirements (relevant to Phase 1)

1. PRD-SEC-02 idle lock (task, default threshold, Settings control). → W2
2. PRD §2 "Settings (User Management, Auto-Lock Timer)" is in no phase. → W6, W2
3. Audit logging for login, logout, lock and setup (needed so that "immutable audit trail" is true from day 1). → W10
4. Manager credential recovery (implied by "system recovery" in PRD-SEC-01). → W8
5. PRD-SEC-01 "detects no existing database configuration": needs bootstrap detection outside the DB. → B1
6. Encrypted backup portability (PRD vision "AES-256 encrypted backups"): needs a key-wrapping design now. → B1

---

## 5. Phase-1 Execution Contract

Binding decisions for the executor. Where docs conflict, this contract wins until the docs are revised.

### 5.1 Repository & scaffold
1. `git init` at the workspace root with a Flutter `.gitignore` (also ignore `*.db`, `*.db-wal`, `*.db-shm`, `keystore.json`, `build/`). Commit docs first.
2. `flutter create --project-name arham_autos --org codes.alphasync --platforms=windows,web .` at the workspace root (docs/ and .planning/ stay alongside). Immediately run `flutter build windows` and `flutter build web` as a smoke test (W17). If the `&` path breaks the build, use `subst` or a junction.
3. Lints: `flutter_lints` (or `very_good_analysis`), with `analysis_options.yaml` checked in.

### 5.2 Dependencies (use `flutter pub add` to resolve the latest compatible versions; majors shown)
- Runtime: `drift` (^2.35), `sqlite3` (^3.x), `path_provider`, `path`, `flutter_secure_storage`, `cryptography` (^2.x; Pbkdf2, AesGcm), `flutter_riverpod` (^3.x), `go_router`, `file_selector`, `pdf`, `printing`, `intl`, `flutter_localizations` (sdk), `uuid`.
- Dev: `drift_dev`, `build_runner`, `flutter_test`, `fake_async`, `mocktail`.
- **Forbidden:** `sqlcipher_flutter_libs`, `sqlite3_flutter_libs`, `google_fonts` runtime fetching, `flutter_bloc` (one state solution only).
- `pubspec.yaml` must contain:
  ```yaml
  hooks:
    user_defines:
      sqlite3:
        source: sqlite3mc
  ```
- Bundle fonts under `assets/fonts/` (Noto Sans/Inter + Noto Nastaliq Urdu + Noto Naskh Arabic; all OFL).

### 5.3 Architecture & file layout (feature-first Clean Architecture)
```
lib/
  main.dart                      # ProviderScope + bootstrap
  app/ app.dart, router.dart (go_router + redirect guards), theme/
  core/
    bootstrap/  bootstrap_service.dart, bootstrap_state.dart, keystore_file.dart, secure_key_store.dart
    crypto/     kdf.dart (PBKDF2 PHC strings, Isolate.run), master_key.dart (gen/normalize/verify), key_wrap.dart (AES-GCM)
    db/         app_database.dart, tables/*.dart, triggers.dart, connection/{connection.dart, connection_native.dart, connection_web.dart}, daos/{users_dao, configs_dao, audit_dao}.dart
    security/   permissions.dart (enum Permission + rolePermissions), session_controller.dart, idle_lock_service.dart, lockout_policy.dart
    platform/   platform_capabilities.dart
    money/      money.dart (int paisa value type + formatting)
  features/
    setup_wizard/ (presentation/, application/, data/)
    auth/         login_screen, lock_overlay, manager_auth_dialog, recovery_screen
    users/        user_management_screen (Manager)
    settings/     settings_screen (idle threshold, language)
    shell/        home_shell (role-aware nav with placeholder routes for later modules), web_unsupported_screen
  l10n/ app_en.arb, app_ur.arb   (+ l10n.yaml)
test/ (mirrors lib/)
```
Presentation and domain code must never import `dart:io`, `drift/native.dart` or `sqlite3` directly; only `core/db/connection/connection.dart` (a conditional export) may.

### 5.4 Key management & bootstrap (resolves B1)
- Data dir: `getApplicationSupportDirectory()` → `…\data\arham_autos.db` and `…\data\keystore.json`.
- **DEK**: 32 bytes from `Random.secure()`. It is stored in `flutter_secure_storage` under key `arham_autos.dek.v1` (hex) and never written in plaintext anywhere else.
- **keystore.json** (plaintext, no secrets): `{version:1, dbId:uuid, kdf:"pbkdf2-sha256", iterations, salt_b64, wrap:"aes-256-gcm", nonce_b64, ct_b64, createdAt}`, where `ct` = AES-GCM(KEK, DEK) and KEK = PBKDF2(normalizedMasterKey, salt_kek).
- **Startup state machine** (`BootstrapService.resolve()`):
  1. A `*.setup` temp DB exists → delete it and any stale DEK → `firstRun`.
  2. No DB and no DEK → `firstRun` (wizard).
  3. DB + DEK → open. If the open fails (wrong key) → `recoveryRequired`.
  4. DB exists but no DEK → `recoveryRequired`: enter Master Key → unwrap DEK from keystore.json → re-store in secure storage → audit `MASTER_KEY_RECOVERY`.
  5. DEK but no DB → `dataMissing` screen: "Start fresh setup" (clears the DEK; confirmation required). Restore from backup comes in Phase 5.
  6. DB opened but `system_configs.setup_complete != 'true'` → treat as corrupt partial setup → delete the DB, keystore and DEK → `firstRun`.
- **Wizard commit order**: generate DEK → create `arham_autos.db.setup` → migrate → one transaction writing configs, Manager user, master-key verifier, audit `SETUP_COMPLETE`, then `setup_complete='true'` → close → write `keystore.json` → store DEK → **atomic rename** `.setup` → `.db`. The rename is the commit point.
- The DB opens at app start without user input (DEK from secure storage), so `language` and `idle_lock_minutes` can be read before login.

### 5.5 Encryption & crypto parameters (resolves B2, B6)
- `NativeDatabase.createInBackground(file, setup: (db) { … })` in this exact order:
  1. Assert sqlite3mc: `db.select('PRAGMA cipher').isNotEmpty` else **throw** `StateError`.
  2. `PRAGMA cipher='sqlcipher'; PRAGMA legacy=4;` (AES-256-CBC + HMAC-SHA512).
  3. `PRAGMA hexkey='<64-hex DEK>';`
  4. `SELECT count(*) FROM sqlite_master;` (fails fast on a wrong key).
  5. `PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL; PRAGMA synchronous=FULL; PRAGMA busy_timeout=5000;`
- PIN/password hashing: PBKDF2-HMAC-SHA256, 16-byte random salt, **iterations ≥ 210,000** (benchmark in release; target 200–800 ms), encoded `pbkdf2-sha256$<iter>$<salt_b64>$<hash_b64>`, run in `Isolate.run`, constant-time compare. Iterations are read from the stored string, so they can be raised later.
- Master Key: 16 chars `A–Z0–9` via `Random.secure()` with rejection sampling, shown as `XXXX-XXXX-XXXX-XXXX`. The verifier is stored in `system_configs.master_key_verifier` (PBKDF2, own salt, PHC string). The KEK uses a **different salt** (held in keystore.json). The key is shown once and never stored in plaintext.
- PIN policy: 4–6 digits. Reject all-same and strictly sequential runs.
- Lockout (per user, persisted): 5 consecutive failures → `locked_until = now+60s`, doubling every further 5 failures up to 15 min. Reset on success. Audit `LOGIN_FAILED` and `LOCKOUT`.

### 5.6 State, routing, RBAC, session, idle lock
- Riverpod providers: `bootstrapStateProvider`, `databaseProvider`, `sessionControllerProvider` (`Notifier<SessionState>`: `signedOut | active(user, role) | locked(user)`), `idleLockServiceProvider`, `localeProvider`.
- `enum Permission` covers **every row of PRD §2** (e.g. `dashboardExecutive, dashboardOperator, stockAlertsView, stockAlertsManage, posBilling, creditOverride, catalogView, catalogEdit, barcodeStudio, purchasesGrn, khataLedgers, returnsInitiate, returnsApprove, returnsDirectOverride, expensesPayroll, routesManage, reports, settingsUsers, settingsAutoLock, backupRestore, auditLogView, factoryReset, about`), with `const Map<Role, Set<Permission>> rolePermissions` matching the matrix exactly.
- Enforce in 3 layers: go_router `redirect` (each `GoRoute` declares a required `Permission`); a `PermissionGate` widget for buttons; and `requirePermission()` in application services. Denials are audited as `PERMISSION_DENIED`.
- Routes: `/setup`, `/recovery`, `/data-missing`, `/login`, `/home`, `/users`, `/settings`, `/about`, plus placeholder routes for later modules (guarded) so RBAC is testable now.
- Idle lock: a root `Listener` (pointer down/move/signal) plus a `HardwareKeyboard` handler resets a `Timer`. The threshold comes from `system_configs.idle_lock_minutes` ∈ {5,10,15,30}, **default 5**. When it expires → `session.lock()` → a full-screen lock overlay above the Navigator (state preserved). Unlock with the same user's PIN; "Switch user" → logout. Add a manual lock shortcut (`Ctrl+L`). The timer is disabled during the wizard and on the login screen.
- `ManagerAuthDialog` (Manager username + PIN step-up, lockout-aware) is a reusable component.

### 5.7 Database schema v1 (resolves B5) — implement ALL tables now, DAOs only for the security domain
General rules:
- **Money:** `INTEGER` paisa, with columns suffixed `_paisa`.
- Quantities: INTEGER.
- Timestamps: drift `DateTimeColumn` (unix int, UTC) with `clientDefault`/`currentDateAndTime`.
- Booleans: drift `BoolColumn`.
- Enums: drift `textEnum<>()`.
- Users and parts are soft-delete only.

Changes vs TRD:
1. `users`: + `display_name`, `pin_hash` (PHC), `password_hash` (NOT NULL for MANAGER, enforced in the app), `failed_attempts INT DEFAULT 0`, `locked_until DATETIME NULL`, `last_login_at`, `updated_at`.
2. `system_configs`: keep key/value. Reserved keys: `setup_complete`, `language` (`en|ur`), `backup_dir`, `idle_lock_minutes`, `master_key_verifier`, `db_id`, `shop_name`, `shop_address`, `shop_phone`, `next_bill_number`, `low_stock_default`.
3. `audit_logs`: + `username_snapshot`, `role_snapshot`; `user_id` FK has no cascade; triggers block UPDATE/DELETE.
4. `part_categories` (id, name_en, name_ur, is_active) + `parts.category_id` FK; `parts.unit TEXT DEFAULT 'PCS'`; `parts.avg_cost_paisa` (moving average, replaces `cost_price`); `parts.defective_stock INT DEFAULT 0`. Indexes on `code`, `barcode`, `name_en`, `category_id`. FTS5 table `parts_fts(code, name_en, name_ur, brand, model_compatibility)` kept in sync by triggers.
5. `stock_movements` (part_id, movement_type `GRN_IN|SALE_OUT|RETURN_IN|RETURN_DEFECTIVE|ADJUSTMENT|SUPPLIER_CLAIM_OUT`, qty_change, unit_cost_paisa, ref_table, ref_id, user_id, created_at): a single inventory ledger.
6. `stock_adjustments`: keep; reason enum maps to PRD labels.
7. `employees`: + `cnic TEXT`, `monthly_salary_paisa`. New `payroll_entries` (employee_id, period YYYY-MM, entry_type `SALARY|ADVANCE|DEDUCTION|BONUS`, amount_paisa, payment_mode, notes, recorded_by, created_at).
8. `customers`: `credit_limit_paisa INTEGER NULL` (NULL = unlimited, 0 = cash only), `current_balance_paisa`.
9. `customer_ledger_entries`: amounts in paisa; + `return_claim_id` FK, + `payment_id` FK.
10. `payments` (party_type `CUSTOMER|SUPPLIER`, party_id, direction `IN|OUT`, amount_paisa, payment_mode `CASH|BANK|CHEQUE|OTHER`, reference, recorded_by, created_at). The supplier ledger gets `payment_id`.
11. `suppliers`/`supplier_ledger_entries`: paisa; supplier ledger + `supplier_claim_id`.
12. `purchases_grn`: + `status` `DRAFT|POSTED`, `posted_at`, `posted_by`; amounts in paisa.
13. `sales`: amounts in paisa; + `payment_mode`, + `credit_override_by` FK users NULL, + `credit_override_at`. Remove `ON DELETE CASCADE` from `sale_items`. Triggers block UPDATE/DELETE on `sales` and `sale_items` (rows are only inserted once finalized; carts live in memory).
14. `sale_items`: + `unit_cost_paisa` (cost snapshot at the time of sale, used for COGS), + `rate_source` `RETAIL|WHOLESALE|MANUAL`.
15. `return_claims`/`return_claim_items`: paisa; + `approved_at`; disposition `SELLABLE|DEFECTIVE_CLAIM`.
16. `supplier_claims` + `supplier_claim_items` (defective pool sent back to the vendor; status `OPEN|SENT|SETTLED`).
17. `expenses`: `category` as an enum `RENT|ELECTRICITY|TEA_MEALS|FUEL|MAINTENANCE|MISC`; `amount_paisa`.

Also: set `schemaVersion = 1` and run `dart run drift_dev make-migrations` from day one, with schema dumps under `drift_schemas/`.

### 5.8 Setup Wizard (Task 3)
- Step 1 Language (`en`/`ur`): switches locale live, held in memory.
- Step 2 Backup folder via `file_selector.getDirectoryPath()`. Validate writability. Warn if it's on the same drive as the app data.
- Step 3 Master Key: generate, show once with the PRD warning text. Print (`Printing.layoutPdf`) or Save PDF (`getSaveLocation`). Gate "Next" on (print or save) + "I stored it safely" checkbox + re-typing the last group.
- Step 4 Manager: username (3–32, `[a-z0-9_.]`), password (min 8), PIN 4–6 entered twice.
- Finish → commit order from §5.4 → `/login`.

### 5.9 Auth (Task 4)
- Login = select user (tiles) or username → PIN pad, with an on-screen keypad and keyboard digits. "Use password" for the Manager.
- "Forgot PIN/password" (Manager) → Master Key → reset (audited).
- Lockout per §5.5.
- Logout clears the session.

### 5.10 Web build behaviour
- `connection_web.dart` throws `UnsupportedError`.
- `PlatformCapabilities.isDesktopSupported == false` on web routes to `web_unsupported_screen`.
- `flutter build web --release` must succeed in CI or locally.

### 5.11 Tasks & done-conditions
| Task | Deliverable | Done when |
|---|---|---|
| T1 Scaffold | repo, pubspec (hooks), lints, l10n.yaml, theme, fonts | `flutter analyze` clean; `flutter build windows` and `flutter build web` succeed; initial commit |
| T2 DB + crypto + bootstrap | `core/db`, `core/crypto`, `core/bootstrap` | DB file header ≠ `SQLite format 3\0`; opening with the wrong key fails; `PRAGMA cipher` = `sqlcipher`; all §5.7 tables and triggers exist; state machine handles all 6 states |
| T3 Setup Wizard | `features/setup_wizard` | Fresh machine → wizard forced; any other route redirects to `/setup`; certificate prints or saves; crash before rename → wizard restarts cleanly |
| T4 Auth + RBAC | `features/auth`, `core/security`, router guards | Operator can't reach any Manager-only route (redirect + audit); lockout triggers after 5 failures and survives restart |
| T5 Idle lock + Settings | `idle_lock_service.dart`, `features/settings` | Lock after N minutes with no input (N from config, default 5); input resets the timer; unlock needs a PIN; state is preserved |
| T6 Users (minimal) | `features/users` | Manager creates, deactivates and resets an Operator; deactivated users can't log in |
| T7 Tests | `test/**` | Unit: KDF round-trip and PHC parsing; master key generator (length, alphabet, normalization, rejection sampling); key wrap/unwrap; PIN policy; lockout policy; `rolePermissions` vs PRD matrix (table-driven); bootstrap state machine (fake FS + fake secure store); idle timer (`fake_async`); audit triggers block UPDATE/DELETE; immutability triggers on `sales`. Integration: real encrypted DB in a temp dir (header check, wrong-key failure). Widget: wizard happy path, route guard redirects. `flutter test` green |

### 5.12 Measurable Phase-1 acceptance criteria (replaces plan text)
1. On a machine with no app data, launching the app always shows the Setup Wizard, and every other route redirects to it.
2. After the wizard: the DB file isn't readable by stock SQLite (header check); `users` has exactly one MANAGER with a PBKDF2 PHC `pin_hash`; `system_configs.setup_complete='true'`; `keystore.json` exists; an audit row `SETUP_COMPLETE` exists.
3. Restart → login screen, not the wizard. Deleting the DEK from secure storage → recovery screen; entering the correct Master Key restores access.
4. 5 wrong PINs → locked for ≥60 s, which persists across restart and is audited.
5. An Operator session can't open any route whose permission is Manager-only per PRD §2 (verified by a table-driven test).
6. With `idle_lock_minutes=5`, 5 min without pointer or keyboard input shows the lock overlay; unlocking with the PIN returns to the same screen.
7. `flutter analyze` has 0 errors; `flutter test` passes; `flutter build windows` and `flutter build web` succeed.

### 5.13 Explicitly deferred (not Phase 1)
Business DAOs and screens (catalog, POS, khata, GRN, returns, expenses, reports), backup/restore and factory reset execution (Phase 5 — but they must ship `keystore.json`), full Urdu translation and RTL polish, the Excel library decision (Phase 4: `excel` + `csv` by default unless a Syncfusion license is confirmed), and the installer.
