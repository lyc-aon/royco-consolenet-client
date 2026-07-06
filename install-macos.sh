#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ARCH=$(uname -m)
case "$ARCH" in
  arm64) PLATFORM=macos-arm64 ;;
  *) echo "royco installer: unsupported macOS arch: $ARCH" >&2; exit 1 ;;
esac
PREFIX=${ROYCO_INSTALL_PREFIX:-$HOME/.local/royco}
INSTALL_BIN=${ROYCO_INSTALL_BIN:-$PREFIX/bin}
LAUNCHER_BIN=${ROYCO_LAUNCHER_BIN:-$HOME/.local/bin}
SERVER_ADDR=${ROYCO_SERVER_ADDR:-174.129.60.2:7767}
mkdir -p "$INSTALL_BIN" "$LAUNCHER_BIN"
install -m 0755 "$ROOT/bin/$PLATFORM/royco-tui" "$INSTALL_BIN/royco-tui"
rm -f "$INSTALL_BIN/royco-server" "$INSTALL_BIN/royco"
cat > "$LAUNCHER_BIN/royco-consolenet" <<LAUNCHER
#!/bin/sh
set -eu
bin_dir="$INSTALL_BIN"
if [ ! -t 0 ] || [ ! -t 1 ]; then
  exec open -a Terminal "\$0" "\$@"
fi
SERVER_ADDR=\${ROYCO_SERVER_ADDR:-$SERVER_ADDR}
STATE_HOME=\${XDG_STATE_HOME:-\$HOME/.local/state}
mkdir -p "\$STATE_HOME/royco"
SESSION_PATH=\${ROYCO_SESSION_PATH:-\$STATE_HOME/royco/consolenet-session.json}
exec "\$bin_dir/royco-tui" --interactive --x-login --server-addr "\$SERVER_ADDR" --session-path "\$SESSION_PATH" "\$@"
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco-consolenet"
cat > "$LAUNCHER_BIN/royco" <<LAUNCHER
#!/bin/sh
set -eu
case "\${1:-}" in
  login|'') shift || true; exec "$LAUNCHER_BIN/royco-consolenet" "\$@" ;;
  *) echo "royco public client supports: royco login" >&2; exit 2 ;;
esac
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco"
echo "roycorp™ Consolenet client installed. Run: $LAUNCHER_BIN/royco login"
