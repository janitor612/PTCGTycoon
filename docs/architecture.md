# Architecture and conventions

Target: Godot 4.7 project format; validated with the installed 4.7.2 stable engine. Preserve GL Compatibility and Jolt Physics.

Use typed GDScript, tabs, snake_case files/functions/variables, PascalCase node and class names, and UPPER_CASE constants. Prefer small composed scenes and signal-based boundaries. Content belongs in Resources or data files, not player logic. Add systems only in their scheduled phase.

- scenes/main.tscn owns startup and composes the test environment and HUD.
- GameManager owns BOOTING/RUNNING/PAUSED lifecycle. It always processes so resume remains possible.
- DebugManager owns diagnostic visibility and snapshots. HUD refreshes visible diagnostics at 4 Hz.
- SaveManager owns the versioned JSON envelope, explicit save/load APIs, error signals, and backup rotation. It never auto-saves or auto-loads. Empty load results also represent errors; subscribers should use operation_failed to distinguish them.
- The environment inherits pausable processing. Main and HUD remain active while paused.
- user://save_v1.json is the default future save location, outside res://. Payload ownership and migration rules will be added when real persistent systems exist. Unknown versions are rejected without rewriting them. A .bak file is retained; automatic recovery and power-loss guarantees are not implemented.
- Main composes a reusable first-person `CharacterBody3D` and places it from `PlayerSpawn`. Locomotion, mouse look, and camera-aligned collision detection are separate responsibilities.
- The interaction ray exposes collider detection and target changes only. Interactable semantics, prompts, highlighting, and use actions remain Phase 3 work.
- DebugManager accepts named snapshot providers, keeping the HUD and diagnostics autoload independent of the player scene.
- assets/environment and assets/materials are replacement-art destinations; data is reserved for future content. Empty directories have .gitkeep markers.

No CardDatabase or EconomyManager singleton is added yet: they have no Phase 1 responsibility and belong to later phases.

## Inputs

Active: WASD movement; mouse look; Shift sprint; Escape pause/resume; F3 debug overlay.
Reserved: E interact; left/right mouse primary/secondary; Q/R rotate; wheel up/down inspection zoom. No use-action or object-interaction code exists yet. Future controller bindings should use these actions in Input Map.

## Validation

Open tests/foundation_smoke.tscn and press F6, or run:
Godot --headless --path <project-directory> res://tests/foundation_smoke.tscn

The test exits with failure count and uses only user://foundation_test.json plus temporary/backup siblings. It removes its test files afterward. Never point it at a real save.

## Phase 3 interaction boundaries
GameManager handles Escape in its always-active _input callback so GUI consumption and pausing cannot disable resume. Main uses an explicit always-process property, while the player is explicitly pausable. InteractableComponent attaches directly beneath a collision object and exposes used and presentation_changed signals. InteractionController resolves only the nearest collider, manages focus and prompts, and invokes use with the actor. TestSwitch owns its state independently. Main wires prompt signals to the HUD. Material overlays are restored after focus leaves. Object handling remains Phase 4.

