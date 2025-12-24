# kirkstone

This repository contains a Yocto/OpenEmbedded workspace for building RDK-based images and components for the kirkstone release.

Environment
-----------
For local builds, you can copy `.env.example` to `.env` and adjust values (e.g., YOCTO_MACHINE, YOCTO_DISTRO, and parallel build settings). These variables are optional and intended to standardize developer environments. Do not commit your local `.env`.

Notes
-----
- This workspace aggregates multiple upstream layers; avoid mass reformatting and sweeping changes.
- Refer to MAINTAINERS.md for lightweight lint guidance (oelint-adv, shellcheck, etc.) to be used on changed files only.
- See CHANGELOG.md for a record of notable maintenance updates in this workspace.
