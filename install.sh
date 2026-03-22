#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
WS_ROOT=$(realpath "$SCRIPT_DIR/../../..")
MUJOCO_VERSION="3.5.0"
MUJOCO_DIR="$HOME/.mujoco/mujoco-${MUJOCO_VERSION}"

echo "=== A2 Sim install ==="
echo "Workspace: $WS_ROOT"

# --- MuJoCo ---
if [ ! -d "$MUJOCO_DIR" ]; then
    echo "Installing MuJoCo ${MUJOCO_VERSION}..."
    mkdir -p "$HOME/.mujoco"
    TMP=$(mktemp -d)
    wget -q --show-progress \
        "https://github.com/google-deepmind/mujoco/releases/download/${MUJOCO_VERSION}/mujoco-${MUJOCO_VERSION}-linux-x86_64.tar.gz" \
        -O "$TMP/mujoco.tar.gz"
    tar -xzf "$TMP/mujoco.tar.gz" -C "$HOME/.mujoco/"
    rm -rf "$TMP"
    echo "MuJoCo installed to $MUJOCO_DIR"
else
    echo "MuJoCo already installed at $MUJOCO_DIR"
fi

# Re-point symlink in a2_mujoco
SYMLINK="$SCRIPT_DIR/external/a2_mujoco/mujoco"
if [ -L "$SYMLINK" ] || [ -e "$SYMLINK" ]; then
    rm "$SYMLINK"
fi
ln -s "$MUJOCO_DIR" "$SYMLINK"
echo "Symlink set: $SYMLINK -> $MUJOCO_DIR"

# --- System packages ---
echo "Installing system packages..."
sudo apt-get install -y \
    ros-jazzy-joy \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-rviz2 \
    libyaml-cpp-dev \
    libboost-program-options-dev \
    libfmt-dev \
    libglfw3-dev

# --- Python packages ---
echo "Installing Python packages..."
pip install torch numpy --quiet

# --- Unitree SDK2 check ---
if [ ! -d "/opt/unitree_robotics" ]; then
    echo ""
    echo "WARNING: Unitree SDK2 not found at /opt/unitree_robotics"
    echo "Install it manually: https://github.com/unitreerobotics/unitree_sdk2"
fi

# --- Build ---
echo ""
echo "Building workspace..."
cd "$WS_ROOT"
source /opt/ros/jazzy/setup.bash
colcon build --symlink-install

echo ""
echo "Done. In each new terminal run:"
echo "  source $SCRIPT_DIR/setup.sh"
