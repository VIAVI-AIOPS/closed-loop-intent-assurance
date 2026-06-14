#!/usr/bin/env bash
# Closed-Loop Intent Assurance — setup script.
# Mirrors the pattern used by the RAN Energy-Saving blueprint (es-blueprint-rsg).

set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

# ── 1. Pick a Python ────────────────────────────────────────────
PY=""
for candidate in python3.13 python3.12 python3.11 python3.10 python3; do
  if command -v "$candidate" >/dev/null 2>&1; then
    PY="$candidate"
    break
  fi
done
if [ -z "$PY" ]; then
  echo "✗ No Python 3.10+ found on PATH. Install via pyenv, Homebrew, or apt." >&2
  exit 1
fi
echo "✓ Using $PY ($($PY --version))"

# ── 2. Virtualenv ───────────────────────────────────────────────
if [ ! -d ".venv" ]; then
  $PY -m venv .venv
  echo "✓ Created .venv"
fi
# shellcheck disable=SC1091
source .venv/bin/activate
echo "✓ Activated .venv"

# ── 3. Dependencies ─────────────────────────────────────────────
pip install --upgrade pip setuptools wheel >/dev/null
pip install -r requirements.txt
echo "✓ Dependencies installed"

# ── 4. Jupyter kernel ───────────────────────────────────────────
python -m ipykernel install --user --name closed-loop-intent-assurance --display-name "Closed-Loop Intent Assurance" >/dev/null
echo "✓ Jupyter kernel registered"

# ── 5. .env ─────────────────────────────────────────────────────
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "⚠ Created .env from .env.example — edit it and set NVIDIA_API_KEY before running"
else
  echo "✓ .env already exists"
fi

echo ""
echo "Setup complete. Next step:"
echo "  ./run.sh"
