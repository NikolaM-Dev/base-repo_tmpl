# List available recipes
default:
    just --list

# Render README.md from the template (mechanical tokens only)
readme owner_repo branch="main" no_star="":
    #!/usr/bin/env bash
    set -euo pipefail
    flags=(--owner-repo "{{owner_repo}}" --branch "{{branch}}")
    if [ "{{no_star}}" = "no-star" ]; then flags+=(--no-star-history); fi
    bash template/render.sh "${flags[@]}"
