#!/usr/bin/env bash
# Launch the closed-loop intent assurance demo notebook.
set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

if [ ! -d ".venv" ]; then
  echo "✗ .venv not found. Run ./setup.sh first."
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate
exec jupyter notebook notebooks/
