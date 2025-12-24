# Maintenance and Lint Guidance

This workspace is a monolithic Yocto/OE build with many upstream layers. Avoid mass code reformatting.

Recommended lightweight checks:
- BitBake recipes: use `oelint-adv` locally where applicable for new/changed recipes.
- Shell scripts: `shellcheck` for new/edited scripts.
- Python test tooling: `ruff`/`flake8` for local edits only; do not sweep-rewrite vendor code.

Examples:
- oelint: `oelint-adv -r -f path/to/recipe.bb`
- shellcheck: `shellcheck scripts/*.sh`

Note: CI/build systems may provide their own linters. Run checks only on changed files to keep diffs minimal.
