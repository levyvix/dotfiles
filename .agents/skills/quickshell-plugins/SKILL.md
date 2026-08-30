---
name: quickshell-plugins
description: Build, modify, and review Omarchy Quickshell plugins and bar widgets. Use when creating Quickshell/QML plugins, Omarchy plugin manifests, panel widgets, services, IPC handlers, Process/FileView integrations, or plugin packaging inspired by OmaProton VPN.
---

# Quickshell Plugins

Use this skill for Omarchy Quickshell plugins, especially bar widgets shaped like `grichard99/omaproton-vpn`: a small manifest, one `Panel.qml` entry point, a state-owning `Service.qml`, optional JS parsers/helpers, optional Python helpers, and strict UI/runtime boundaries.

## First pass

1. Clone or inspect the target plugin/repo locally before editing. Read `manifest.json`, entry QML files, service/state QML, helper JS/Python files, and README install notes.
2. Identify the plugin kind. For a bar widget, expect:
   - `manifest.json` with `schemaVersion`, reverse-DNS `id`, `kinds: ["bar-widget"]`, and `entryPoints.barWidget`.
   - `Panel.qml` as the user interface and IPC surface.
   - `Service.qml` as the state/process/filesystem owner.
3. Keep changes surgical. Match existing QML style, imports, theme tokens, spacing helpers, and comments. Do not introduce a second architecture next to the existing one.
4. Design for Omarchy shell safety: a plugin runs unsandboxed inside the shell, so avoid speculative network calls, credential handling, broad filesystem writes, and shell string interpolation.

## Manifest pattern

Use a compact `manifest.json`:

```json
{
  "schemaVersion": 1,
  "id": "io.github.author.plugin-name",
  "name": "Plugin Name",
  "version": "0.1.0",
  "author": "author",
  "license": "MIT",
  "description": "Short user-facing description.",
  "kinds": ["bar-widget"],
  "entryPoints": { "barWidget": "Panel.qml" },
  "barWidget": {
    "displayName": "Plugin Name",
    "description": "What the widget does.",
    "category": "Network",
    "allowMultiple": false,
    "defaultSection": "right",
    "defaults": {},
    "schema": []
  }
}
```

Rules:
- Prefer a reverse-DNS `id` and use the same value for `Panel.moduleName` and IPC target.
- Add settings only for behavior users actually need to tune. Validate/clamp settings in QML before use.
- Keep `allowMultiple: false` unless the service state is explicitly instance-safe.

## QML architecture

Split responsibilities clearly:

- `Panel.qml`: presentation, keyboard/mouse interaction, panel layout, confirmation dialogs, `IpcHandler`, and calls into the service.
- `Service.qml`: durable state, external processes, polling, file reads/writes, derived state, optimistic action state, and notifications.
- `Model.js`: pure parsing/formatting helpers for CLI output and labels. Make parsers tolerant of unknown lines and future CLI changes.
- `*.py`: heavier local data extraction or protocol work when QML/JS would be brittle. Print compact JSON for QML to consume.

Good import baseline:

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model
```

Only import modules the file uses.

## UI patterns

Prefer Omarchy/Quattro primitives and theme tokens:

- Use `Panel`, `BarIconButton`, `KeyboardPanel`, `PanelKeyCatcher`, `PanelHero`, `ActionRow`, `InfoPair`, `CopyPair`, `ToggleSwitch`, `PanelSectionHeader`, `PanelSeparator`, `BorderSurface`, `Button`, and `ConfirmDialog` when available.
- Use `Color.foreground`, `Color.accent`, `Color.urgent`, `Style.space(...)`, `Style.font.*`, `Style.cornerRadius`, `Style.controlFill(...)`, and `Border.controlSpec(...)`; avoid hard-coded colors, fonts, radii, and bitmap-only icons.
- Keep bar icons small, readable, and theme-colored. Dim inactive state; do not rely only on color for meaning.
- For panel lists, use `Flickable` with explicit wheel handling when precise row navigation matters.
- Preserve keyboard control: centralize focus section/index state, keep a cursor inside existing rows, let `Esc` back out before closing, and avoid single-letter destructive actions.
- Ask for confirmation before actions that disconnect, expose traffic, open inbound ports, sign out, delete data, or otherwise surprise the user. Default the safe/cancel option.

## Runtime/process rules

- Use `Process` with argv arrays: `command = ["tool", "arg"]`. Do not build shell strings unless a real TTY shell is required.
- If a shell boundary is unavoidable, whitelist user input first and quote it deliberately.
- Use `StdioCollector { waitForEnd: true }` for command output and parse on `onExited`.
- Gate long or conflicting commands with explicit `busy`/pending flags. External CLIs may rewrite shared caches or config files; serialize probes and actions when the upstream tool has no locking.
- Separate cheap high-frequency probes from expensive detail probes. Example: use a fast system command for bar status, and run slow CLI detail only when the panel is open, on demand, or after actions.
- Use optimistic UI state only while an action is in flight, then reconcile against fresh observed state. Add a safety valve for stale optimistic state.
- Validate every value before passing it to a command. Prefer allowlists for config keys/values and strict regexes for IDs, country codes, server names, paths, ports, and usernames.

## Filesystem and persistence

- Own plugin state under `$XDG_STATE_HOME/<plugin-name>` or `~/.local/state/<plugin-name>`. Create it owner-only (`0700`) when it can reveal behavior or history.
- Use `FileView` for watched or atomic QML-side files. Use `atomicWrites: true` for plugin state and carefully modified config files.
- When editing another app's config, read it fresh, mutate only the owned section, preserve every other key, and never create the file unless the upstream app documents that as safe.
- Store labels, recent choices, dismissed nudges, and UI preferences; do not store secrets, tokens, passwords, or account identifiers unless explicitly required and justified.

## IPC and debug

Expose minimal IPC through `IpcHandler`:

```qml
IpcHandler {
  target: root.ipcTarget
  function open(): void { root.open() }
  function close(): void { root.close() }
  function toggle(): void { root.toggle() }
  function refresh(): string { service.refresh(); return "ok" }
  function status(): string { return service.displayStatus }
  function debug(): string { return JSON.stringify({ installed: service.installed, busy: service.busy, lastError: service.lastError }) }
}
```

Rules:
- IPC can be called by local processes as the user. Do not expose secrets or account identifiers in `debug()`.
- Make debug output useful for bug reports: installed/probed state, active status, pending action, counts, and last error.
- View-only IPC may change panel view state; action IPC should be named plainly and return a simple status string.

## Helper scripts

- Prefer `python3` helpers for local cache parsing, protocol packets, desktop-entry scanning, or bulky data transforms.
- Helpers should have a narrow CLI, tolerate missing files, and print JSON (`[]` or `{}` on absent data).
- Do not perform network calls unless that is the core feature and documented. If a helper contacts a local gateway/socket, state exactly where it sends data.
- For Python in this environment, run scripts through `uv` during development/verification when invoking them yourself.

## Packaging and user docs

Document install/update/remove commands:

```sh
omarchy plugin add https://github.com/author/plugin --enable
omarchy plugin enable io.github.author.plugin right
omarchy plugin update io.github.author.plugin
omarchy plugin remove io.github.author.plugin
```

README should cover prerequisites, first-run flow, actions for each mouse button, keyboard behavior, external commands used, network calls, files written, privacy/security notes, and troubleshooting/debug IPC.

## Verification checklist

Before calling a Quickshell plugin change done:

- [ ] `manifest.json` is valid JSON and points at existing entry points.
- [ ] QML imports match used symbols; no unused helper files or orphaned entry points remain.
- [ ] Every external command uses argv arrays or justified/quoted shell use.
- [ ] Settings are clamped/validated and defaults match the manifest.
- [ ] Process concurrency is safe; slow probes do not race mutating actions.
- [ ] File writes are scoped, atomic where needed, and do not write secrets.
- [ ] UI uses theme tokens and works from keyboard and mouse.
- [ ] Dangerous actions have confirmation or a two-step affordance.
- [ ] IPC debug output excludes secrets.
- [ ] Run the most specific available smoke check: plugin validation/lint if present, JSON parse for manifest, helper scripts with harmless inputs, and `omarchy-shell <plugin-id> debug` or a panel launch when available.
