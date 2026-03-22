#!/bin/bash
# A2 Simulation Environment Setup
# Source this file, don't execute it: source setup.sh

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
WS_ROOT=$(realpath "$SCRIPT_DIR/../../..")

# --- ROS2 ---
source /opt/ros/jazzy/setup.bash

# --- Workspace install ---
if [ -f "$WS_ROOT/install/setup.bash" ]; then
    source "$WS_ROOT/install/setup.bash"
    echo "[a2_ros] Sourced workspace: $WS_ROOT"
else
    echo "[a2_ros] WARNING: Workspace not built yet."
    echo "  Run:  cd $WS_ROOT && colcon build --symlink-install"
fi

# --- ROS2 middleware ---
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export ROS_DOMAIN_ID=1

echo "[a2_ros] ROS_DOMAIN_ID=$ROS_DOMAIN_ID  RMW=$RMW_IMPLEMENTATION"
echo "[a2_ros] Ready."
