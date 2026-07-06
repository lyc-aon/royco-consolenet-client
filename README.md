# roycorp™ Consolenet client

Client-only download for roycorp™ Consolenet.

This repo intentionally contains only the TUI client binary plus tiny launcher scripts. It does not contain `royco-server` or server source.

Transport note: the current Royco server protocol is raw TCP, not TLS. The AWS
demo server is IP-allowlisted while TLS is pending; do not treat this as a
secure public service yet.

## Linux

```bash
./install-linux.sh
$HOME/.local/bin/royco login
```

## macOS Apple Silicon

```bash
sh install-macos.sh
$HOME/.local/bin/royco login
```

If `$HOME/.local/bin` is already on your `PATH`, bare `royco login` works too.

The first launch opens X login. Your chat name is your X handle.

If the X handle is not approved yet, login records the request and exits with a
pending-approval message. A Royco admin can approve it in the console with:

```text
/x permit @handle
```

Admins can review pending handles in the Admin pane.

Default server: `174.129.60.2:7767`.
Override if needed:

```bash
ROYCO_SERVER_ADDR=host:port $HOME/.local/bin/royco login
```
