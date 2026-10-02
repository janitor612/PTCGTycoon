# Phase 2 completion report — First-Person Player

## Implemented behavior

- Added a reusable `CharacterBody3D` first-person player with facing-relative WASD locomotion, normalized diagonal input, configurable acceleration/deceleration, gravity, collision, and Shift sprint.
- Added a focused mouse-look component with configurable sensitivity and pitch limits. Running captures the pointer; pausing releases it; resuming requests capture again.
- Added a reusable, camera-aligned detection ray with configurable reach, player-body exclusion, a target-change signal, and read-only target access. It intentionally has no use action, prompt, highlight, or interactable contract.
- Replaced the Phase 1 static camera with the player, placed from `PlayerSpawn` at session startup.
- Added a centered crosshair and extended the toggleable F3 diagnostics through a registered snapshot-provider boundary to show player position and the current raycast collider.
- Expanded the test environment into an enclosed collision room with a floor, four walls, and three colored static obstacles.
- Preserved Phase 1 lifecycle, pause, diagnostics, explicit versioned saves, GL Compatibility, and Jolt Physics.

## Files created

- `scenes/player/first_person_player.tscn`
- `scripts/player/first_person_player.gd`
- `scripts/player/mouse_look.gd`
- `scripts/interaction/interaction_ray.gd`
- `tests/phase_2_smoke.gd`
- `tests/phase_2_smoke.tscn`
- `docs/phase_2_report.md`

## Files modified

- `AGENTS.md`
- `autoload/debug_manager.gd`
- `docs/architecture.md`
- `scenes/main.tscn`
- `scenes/ui/foundation_hud.tscn`
- `scenes/world/test_environment.tscn`
- `scripts/systems/main.gd`
- `scripts/ui/foundation_hud.gd`

## Controls

- **W / A / S / D:** move relative to camera-facing yaw
- **Mouse:** look (yaw and pitch)
- **Shift:** sprint while held
- **Escape:** pause/resume and release/recapture the pointer
- **F3:** toggle diagnostics

`E` and mouse interaction actions remain reserved. Phase 2 detects colliders only and does not invoke interactions.

## Exact local testing instructions

From the repository root with Godot 4.7.2 stable available as `godot`:

```bash
godot --headless --editor --import --quit
godot --headless --path . res://tests/foundation_smoke.tscn
godot --headless --path . res://tests/phase_2_smoke.tscn
godot --headless --path . --quit-after 30
```

Then run `godot --editor project.godot`, press **F6** on `scenes/main.tscn` (or **F5**), and manually verify:

1. Pointer capture and comfortable mouse sensitivity/pitch limits.
2. Smooth acceleration, stopping, facing-relative WASD, equal diagonal speed, and faster Shift sprint.
3. The player cannot pass through the floor, walls, orange crate, blue bench, or tall marker.
4. Escape releases the pointer and freezes movement; Escape resumes and recaptures it.
5. The white crosshair remains centered at different window sizes.
6. F3 reports position and names a collider when the crosshair is aimed at a nearby obstacle.

## Tests actually performed

- Godot 4.7.2 version check.
- Headless editor import and script/resource parse.
- Existing Phase 1 foundation smoke coverage for startup, pause/resume, Input Map, save round-trip, backup, and malformed/future save rejection.
- Phase 2 smoke coverage for floor settling, raycast detection and self-exclusion, obstacle collision, normalized diagonal speed, sprint speed, paused movement, and pointer release.
- Main-scene headless startup for 30 seconds.

## Known limitations

- Headless execution cannot assess mouse feel, visual quality, real pointer recapture, crosshair appearance, or physical keyboard/mouse behavior; those require the manual checks above.
- The ray exposes collision targets only. Prompts, highlighting, use actions, and an interactable contract are intentionally deferred.
- Keyboard and mouse are implemented; controller bindings and look input remain future work.
- Placeholder geometry/materials are deliberately simple and have no production art or audio.
- Player transform is not persisted, so Phase 1 save compatibility is unchanged.

## Next phase (not started)

Phase 3 would add the reusable interactable contract/component, interaction prompts, object highlighting, a basic use action, and dedicated test interactables. It requires explicit authorization before work begins.
