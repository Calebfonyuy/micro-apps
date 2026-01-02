#!/bin/bash

# Network Monitor - Monitor network activity on all interfaces using iftop
# Uses tmux to create separate panes for each network interface

SESSION_NAME="network-monitor"

# Check if running as root (required for iftop)
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run with sudo"
    echo "Usage: sudo ./network-monitor.sh"
    exit 1
fi

# Check if required tools are installed
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed. Run ./setup.sh first."
    exit 1
fi

if ! command -v iftop &> /dev/null; then
    echo "Error: iftop is not installed. Run ./setup.sh first."
    exit 1
fi

# Kill existing session if it exists
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Get all active network interfaces (excluding loopback)
mapfile -t INTERFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$' | while read -r iface; do
    # Check if interface is UP
    state=$(ip -o link show "$iface" | grep -o 'state [A-Z]*' | awk '{print $2}')
    if [[ "$state" != "DOWN" ]]; then
        echo "$iface"
    fi
done)

# Check if we found any interfaces
if [[ ${#INTERFACES[@]} -eq 0 ]]; then
    echo "Error: No active network interfaces found"
    exit 1
fi

echo "Found ${#INTERFACES[@]} active interface(s): ${INTERFACES[*]}"
echo "Starting network monitor..."

# Create tmux session with first interface
tmux new-session -d -s "$SESSION_NAME" -n "monitor-${INTERFACES[0]}" "iftop -i ${INTERFACES[0]}"

# Add panes for remaining interfaces
for ((i=1; i<${#INTERFACES[@]}; i++)); do
    tmux split-window -t "$SESSION_NAME" "iftop -i ${INTERFACES[$i]}"
    # Rebalance panes after each split
    tmux select-layout -t "$SESSION_NAME" tiled
done

# Final layout adjustment
tmux select-layout -t "$SESSION_NAME" tiled

# Select first pane
tmux select-pane -t "$SESSION_NAME":0.0

# Attach to session
echo "Attaching to tmux session. Use Ctrl+B then arrow keys to navigate panes."
echo "Press Ctrl+B then D to detach, or Ctrl+C in each pane to exit."
tmux attach-session -t "$SESSION_NAME"
