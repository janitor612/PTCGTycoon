# Cloud setup handoff

This repository is a Godot 4.7.2 stable project, with Phase 1 completed. Do not begin Phase 2 during environment setup.

In the cloud environment setup request, ask Codex to install the official Godot 4.7.2 stable Linux x86_64 executable as `godot` on PATH, preserve the current GL Compatibility renderer and Jolt physics, then run the three commands in AGENTS.md. Do not silently substitute an older distribution package. No export templates, API keys, or gameplay network services are needed for these headless checks.

Publish the environment only after the import, foundation smoke test, and main-scene startup succeed. Visual play-testing remains local in Godot. Read AGENTS.md and docs/development_roadmap.md at the start of cloud coding tasks.

The original Windows folder is not automatically synchronized by a cloud environment. Push committed local changes to GitHub before cloud tasks; review and pull cloud changes before continuing locally.

Official setup guide: https://learn.chatgpt.com/docs/cloud
