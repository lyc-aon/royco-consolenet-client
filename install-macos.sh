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
SERVER_URL=${ROYCO_SERVER_URL:-wss://d12vjvobixtkef.cloudfront.net/royco}
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
SERVER_URL=\${ROYCO_SERVER_URL:-$SERVER_URL}
STATE_HOME=\${XDG_STATE_HOME:-\$HOME/.local/state}
mkdir -p "\$STATE_HOME/royco"
SESSION_PATH=\${ROYCO_SESSION_PATH:-\$STATE_HOME/royco/consolenet-session.json}
if [ -n "\${ROYCO_SERVER_ADDR:-}" ]; then
  exec "\$bin_dir/royco-tui" --interactive --x-login --server-addr "\$ROYCO_SERVER_ADDR" --session-path "\$SESSION_PATH" "\$@"
fi
exec "\$bin_dir/royco-tui" --interactive --x-login --server-url "\$SERVER_URL" --session-path "\$SESSION_PATH" "\$@"
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco-consolenet"
cat > "$LAUNCHER_BIN/royco" <<LAUNCHER
#!/bin/sh
set -eu
usage() {
  echo "Usage: royco login"
  echo "Launches roycorp™ Consolenet against $SERVER_URL and opens X login."
}
case "\${1:-login}" in
  login)
    shift || true
    case "\${1:-}" in --help|-h|help) usage; exit 0 ;; esac
    exec "$LAUNCHER_BIN/royco-consolenet" "\$@"
    ;;
  --help|-h|help) usage ;;
  *) echo "royco public client supports: royco login" >&2; exit 2 ;;
esac
LAUNCHER
chmod 0755 "$LAUNCHER_BIN/royco"
echo "roycorp™ Consolenet client installed. Run: $LAUNCHER_BIN/royco login"
