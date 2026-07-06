# roycorp™ Consolenet client

Client-only download for roycorp™ Consolenet.

This repo intentionally contains only the TUI client binary plus tiny launcher scripts. It does not contain `royco-server` or server source.

## Linux

```bash
./install-linux.sh
royco login
```

## macOS Apple Silicon

```bash
sh install-macos.sh
royco login
```

The first launch opens X login. Your chat name is your X handle.

Default server: `100.59.208.143:7767`.
Override if needed:

```bash
ROYCO_SERVER_ADDR=host:port royco login
```
