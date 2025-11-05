#!/usr/bin/env bash
set -e

# Activate the virtual environment
python -m venv --system-site-packages /workspace/.venv
source /workspace/.venv/bin/activate

# Install editable requirements in venv (if present)
python -m pip install --upgrade pip setuptools wheel
if [ -f /tmp/editable_requirements.txt ]; then
    pip install --no-cache-dir -r /tmp/editable_requirements.txt
fi

exec "$@"