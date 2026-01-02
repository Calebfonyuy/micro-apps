# Network Monitor

Monitor network activity on all active interfaces using iftop with tmux panes.

## Installation

```bash
chmod +x setup.sh network-monitor.sh
./setup.sh
```

## Usage

```bash
sudo ./network-monitor.sh
```

The script will:
1. Scan for all active network interfaces
2. Create a tmux session with one pane per interface
3. Run iftop for each interface

## Tmux Navigation

| Keys | Action |
|------|--------|
| `Ctrl+B` then arrow keys | Navigate between panes |
| `Ctrl+B` then `D` | Detach from session (keeps running) |
| `Ctrl+B` then `Z` | Zoom/unzoom current pane |
| `Ctrl+C` | Stop iftop in current pane |

## Reattach to Session

If you detach from the session:

```bash
tmux attach-session -t network-monitor
```

## Requirements

- iftop
- tmux
- Root privileges (sudo)
