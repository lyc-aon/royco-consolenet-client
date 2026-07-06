#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64) PLATFORM="linux-x86_64" ;;
  *) echo "royco installer: unsupported Linux arch: $ARCH" >&2; exit 1 ;;
esac
INSTALL_BIN="${ROYCO_INSTALL_BIN:-$HOME/.local/royco/bin}"
LAUNCHER_BIN="${ROYCO_LAUNCHER_BIN:-$HOME/.local/bin}"
SERVER_ADDR="${ROYCO_SERVER_ADDR:-174.129.60.2:7767}"
mkdir -p "$INSTALL_BIN" "$LAUNCHER_BIN"
install -m 0755 "$ROOT/bin/$PLATFORM/royco-tui" "$INSTALL_BIN/royco-tui"
rm -f "$INSTALL_BIN/royco-server" "$INSTALL_BIN/royco"
cat > "$LAUNCHER_BIN/royco-consolenet" <<LAUNCHER
#!/usr/bin/env bash
set -euo pipefail
# Generated launcher opens the live chat UI, not a one-shot snapshot.
ROYCO_BIN="\${ROYCO_BIN:-$INSTALL_BIN}"
SERVER_ADDR="\${ROYCO_SERVER_ADDR:-$SERVER_ADDR}"
STATE_HOME="\${XDG_STATE_HOME:-\$HOME/.local/state}"
mkdir -p "\$STATE_HOME/royco"
SESSION_PATH="\${ROYCO_SESSION_PATH:-\$STATE_HOME/royco/consolenet-session.json}"
exec "\$ROYCO_BIN/royco-tui" --interactive --x-login --server-addr "\$SERVER_ADDR" --session-path "\$SESSION_PATH" "\$@"
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco-consolenet"
cat > "$LAUNCHER_BIN/royco" <<LAUNCHER
#!/usr/bin/env bash
set -euo pipefail
case "\${1:-}" in
  login|'') shift || true; exec "$LAUNCHER_BIN/royco-consolenet" "\$@" ;;
  *) echo "royco public client supports: royco login" >&2; exit 2 ;;
esac
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco"
echo "roycorp™ Consolenet client installed. Run: $LAUNCHER_BIN/royco login"
