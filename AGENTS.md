# Project instructions

Read docs/development_roadmap.md and docs/architecture.md before making changes. This is a phased Godot 3D TCG shop tycoon project. Phases 1 and 2 are complete; Phase 3 is not authorized yet. Cloud environment setup is authorized, but must not advance gameplay development.

Implement only the phase explicitly requested by the user. Stop at each phase boundary and report implemented behavior, created files, modified files, controls, exact tests, limitations, and the next phase. Wait for explicit permission before starting the next phase.

Use Godot 4.7.2 stable, typed GDScript, small composed scenes, signals, and data-driven content. Preserve GL Compatibility, Jolt physics, useful existing work, and save compatibility. Do not place unrelated gameplay systems inside the player script.

Validation commands (from the repository root, with Godot installed as godot):
- godot --headless --editor --import --quit
- godot --headless --path . res://tests/foundation_smoke.tscn
- godot --headless --path . --quit-after 30

Headless checks do not prove visual quality or real input behavior. Report manual checks separately. Never modify real user saves during tests. Keep .godot caches, exports, credentials, and local saves out of Git.

## Local delivery requirement

The user's active Godot project is C:/Users/under/OneDrive/Documents/pokemon-tcg-tycoon/. Apply all completed work for this project to that folder, including cloud changes, and validate it locally before reporting delivery. Cloud containers cannot directly access this Windows folder; explicitly hand off completed changes for local synchronization. Preserve unrelated local edits and do not advance phases without authorization.


