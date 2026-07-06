# roycorp™ Consolenet client

Client-only download for roycorp™ Consolenet.

This repo intentionally contains only the TUI client binary plus tiny launcher scripts. It does not contain `royco-server` or server source.

Transport note: the public client uses WSS through the AWS CloudFront endpoint
below. The older raw TCP server port remains locked down and is not the public
client path.

## Source & audit

Full source (royco-server + royco-tui, one Rust workspace) is public so anyone
can verify the build and check it's safe:

- Source: https://github.com/lyc-aon/royco-consolenet

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

Default endpoint: `wss://d12vjvobixtkef.cloudfront.net/royco`.
Override if needed:

```bash
ROYCO_SERVER_URL=wss://host/path $HOME/.local/bin/royco login
```

Legacy raw TCP override for local testing:

```bash
ROYCO_SERVER_ADDR=host:port $HOME/.local/bin/royco login
```
