#!/usr/bin/env zsh
set -euo pipefail

VK_QUAKE_PATH="/Users/bm199305/dev/git/vkQuake/build/"
MOD_PATH="../mymod"
MOD_NAME="mymod"
START_MAP_NAME="test"

echo "Copy Mod directory to VK_QUAKE_PATH"
cp -r "$MOD_PATH" "$VK_QUAKE_PATH"

#run vkquake
VK_QUAKE_PATH=$VK_QUAKE_PATH"vkquake"
echo "Run vkQuake"
$VK_QUAKE_PATH "-game" $MOD_NAME " +map " $START_MAP_NAME