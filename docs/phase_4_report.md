# Phase 4 completion report

Implemented directly in C:/Users/under/OneDrive/Documents/pokemon-tcg-tycoon/. Phase 5 has not started.

## Implemented

Reusable CarryableComponent connects physical bodies to existing interactions. ObjectHandling is a composed player child, separate from locomotion and mouse look. E picks up an eligible object. Held objects smoothly follow the camera, stop at collision geometry using shape sweeps, and rotate in 15-degree yaw steps. Only one object can be held. Physics, interaction availability, and player collision exceptions are restored on drop or placement.

Left click opens a visual placement preview. It is green on a clear horizontal support surface within reach and red for invalid support or overlap. A second left click places the object only if validation passes. Right click cancels preview or drops a carried object. Placement excludes the held body, but checks the player and world collisions. Pause retains ownership and freezes movement, hides the preview, and prevents use/drop/place. Two reusable physical parcel placeholders are available beside the spawn. Prior switches, movement, pause and save functionality remain.

## Files created

- scripts/objects/carryable_component.gd
- scripts/objects/object_handling.gd
- scenes/objects/test_parcel.tscn
- tests/phase_4_smoke.gd
- tests/phase_4_smoke.tscn
- docs/phase_4_report.md
- Godot-generated .gd.uid sidecars for the new scripts.

## Files modified

- scripts/interaction/interaction_controller.gd (targeting suspension during carrying)
- scenes/player/first_person_player.tscn (composed handling node)
- scenes/main.tscn (two parcel instances)
- scripts/systems/main.gd (handling hint signal to HUD)
- scenes/ui/foundation_hud.tscn (phase title)
- scripts/ui/foundation_hud.gd (debug title)
- AGENTS.md (phase boundary)
- docs/architecture.md

## Controls

- E: pick up targeted parcel; drop when carrying.
- Q / R: rotate carried object or placement preview by 15 degrees.
- Left click: begin placement preview; click again to confirm a valid placement.
- Right click: cancel placement preview; otherwise drop.
- WASD, mouse, Shift, Escape and F3 retain their previous behavior.

## Exact manual test

1. Stop any old running instance with F8. Open this folder's project.godot in Godot 4.7.2 and press F5.
2. Look down at either yellow parcel beside the spawn and approach within three meters. Aim at it and press E when Pick up appears.
3. Walk and turn. The parcel should follow smoothly. Move toward a wall; it should stop rather than pass through it. Press Q/R to rotate.
4. Press Escape twice to verify pause/resume with an object held. Ownership should be retained and motion should freeze while paused.
5. Aim down at clear floor within four meters and left click. Expect a translucent green preview. Rotate with Q/R and left click to place; the parcel should settle under physics and become pickable again.
6. Try previewing against a wall or an occupied space. Expect red feedback or no preview when there is no surface. Left click must not release the parcel at an invalid position.
7. Right click during preview to cancel. Right click again, or E, to drop. Pick it up again and repeat with the other parcel.
8. Confirm switches still respond to E while empty-handed and F3 diagnostics still toggle.

## Validation

Godot 4.7.2 editor import and main startup passed. Foundation, Phase 2, Phase 3, Escape regression, and Phase 4 smoke tests all passed with zero failures. Phase 4 verifies pickup ownership, one-object restriction, smooth movement, rotation, pause, valid placement, restoring physics, re-pickup, wall rejection, invalid confirmation rejection, and drop cleanup.

The sandbox reports its existing certificate-store warning. Visual rendering and real mouse/input feel still need the manual play-test; headless tests do not verify appearance.

## Limitations

One convex collision shape and one mesh per carryable are supported initially, with unit body scale and an explicitly configured bottom offset. Rotation is yaw-only. Placement accepts nearly horizontal surfaces, without grids or furniture snapping. Carrying is frozen-body motion rather than a physical spring. Final placement snaps to the validated preview; carrying interpolates smoothly. No throw, hand animation, audio, inventory, persistence, or card content is introduced. Newly added local card images were preserved and are not used in this phase.

## Next phase

Phase 5 would add data-driven card/set schemas, rarity and variant definitions, databases, and small sample content. It requires explicit authorization.
