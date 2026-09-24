#!/usr/bin/env bash
# One-shot install smoke test for a generated demo module.
#
# Ensures the local Odoo 20 Enterprise instance is up, then delegates to
# engine/docker/test_install.py (fresh DB, log analysis, Postgres assertions).
# Use this from the demo agent / /new-demo command so a single command covers
# the whole smoke test. All arguments are forwarded to test_install.py.
#
# Usage:
#   engine/docker/smoke.sh --module bt_demo_musterhandel
#
# Run it with a long tool timeout (>= 1800000 ms): the install takes minutes.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMPOSE_DIR="${ODOO_COMPOSE_DIR:-$(cd "$REPO_ROOT/.." && pwd)/odoodemo-local-20}"

if ! command -v docker >/dev/null 2>&1; then
    echo "smoke.sh: docker not found on PATH" >&2
    exit 2
fi

COMPOSE_FILE=""
for name in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
    if [ -f "$COMPOSE_DIR/$name" ]; then
        COMPOSE_FILE="$COMPOSE_DIR/$name"
        break
    fi
done
if [ -z "$COMPOSE_FILE" ]; then
    echo "smoke.sh: no docker-compose file in $COMPOSE_DIR" >&2
    echo "          set ODOO_COMPOSE_DIR to the instance directory" >&2
    exit 2
fi

echo "smoke.sh: starting instance ($COMPOSE_FILE)" >&2
docker compose -f "$COMPOSE_FILE" up -d

exec python3 "$REPO_ROOT/engine/docker/test_install.py" \
    --compose-dir "$COMPOSE_DIR" "$@"
