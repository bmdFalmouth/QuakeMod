#!/usr/bin/env zsh
set -euo pipefail

#compile code
sh ./compile_quake.sh

sh ./deploy_mod_assets.sh