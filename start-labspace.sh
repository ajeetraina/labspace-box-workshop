#!/usr/bin/env bash
#
# start-labspace.sh — launch the "Box Mount Kit" Labspace locally.
#
# The guide is served by the labspace content image; the two terminals are a
# ttyd session on THIS host (port 8085). sbx runs on the host because it uses
# real microVMs and does NOT emulate.
#
# Usage:
#   bash start-labspace.sh          # start (foreground; Ctrl-C to stop)
#   bash start-labspace.sh down     # stop and clean up
#
set -euo pipefail

TTYD_PORT=8085
COMPOSE_FILE="compose.yaml"
LABSPACE_PORT=3030

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'
info()  { echo -e "${GREEN}==>${NC} $*"; }
warn()  { echo -e "${YELLOW}WARN:${NC} $*"; }
error() { echo -e "${RED}ERROR:${NC} $*"; exit 1; }

# ── down ───────────────────────────────────────────────────────
if [[ "${1:-up}" == "down" ]]; then
  info "Stopping labspace..."
  docker compose -p box-labspace -f "$COMPOSE_FILE" down 2>/dev/null || true
  lsof -ti tcp:$TTYD_PORT | xargs kill -9 2>/dev/null || true
  exit 0
fi

# ── prerequisites ──────────────────────────────────────────────
command -v docker >/dev/null 2>&1 || error "Docker not found. Install Docker/Rancher Desktop first."
docker info >/dev/null 2>&1       || error "Docker daemon not running. Start Docker/Rancher Desktop."

if ! command -v ttyd >/dev/null 2>&1; then
  error $'ttyd not found. Install it:\n    brew install ttyd        # macOS\n    sudo apt install ttyd    # Ubuntu/Debian'
fi

if ! command -v sbx >/dev/null 2>&1; then
  warn "sbx not found on PATH. The guide will still load, but the labs need it:"
  warn "    brew install docker/tap/sbx     # macOS"
fi

# ── sbx daemon (best-effort) ───────────────────────────────────
if command -v sbx >/dev/null 2>&1; then
  sbx daemon start >/dev/null 2>&1 || true
  info "sbx: $(sbx version 2>/dev/null | head -1)"
fi

# ── host terminal (ttyd) ───────────────────────────────────────
info "Clearing port $TTYD_PORT..."
lsof -ti tcp:$TTYD_PORT | xargs kill -9 2>/dev/null || true
sleep 1

SHELL_BIN="$(command -v zsh || command -v bash)"
info "Starting host terminal (ttyd) on :$TTYD_PORT using $SHELL_BIN..."
ttyd -p "$TTYD_PORT" --writable --max-clients 4 "$SHELL_BIN" &
TTYD_PID=$!
sleep 1
lsof -ti tcp:$TTYD_PORT >/dev/null 2>&1 || error "ttyd failed to start on :$TTYD_PORT"

# ── labspace ───────────────────────────────────────────────────
info "Starting Labspace..."
docker compose -p box-labspace -f "$COMPOSE_FILE" up -d

echo ""
echo "==========================================================="
echo "  📦 Box Mount Kit Labspace"
echo "  Open:  http://localhost:${LABSPACE_PORT}"
echo "  Terminals 1 & 2 → your host shell (sbx runs here)"
echo "  Stop later:  bash start-labspace.sh down"
echo "==========================================================="
echo ""
echo "Press Ctrl+C to stop."

cleanup() {
  echo ""; info "Stopping..."
  kill "$TTYD_PID" 2>/dev/null || true
  docker compose -p box-labspace -f "$COMPOSE_FILE" down 2>/dev/null || true
}
trap cleanup EXIT
wait "$TTYD_PID"
