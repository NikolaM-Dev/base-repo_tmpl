# List available recipes
default:
    just --list

# Render README.md from the template (mechanical tokens only)
readme owner_repo branch="main":
    #!/usr/bin/env bash
    set -euo pipefail
    flags=(--owner-repo "{{owner_repo}}" --branch "{{branch}}")
    bash template/render.sh "${flags[@]}"
