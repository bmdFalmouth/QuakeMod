#!/usr/bin/env zsh
set -euo pipefail

LOG=../../mymod/compile.log
PROG_SRC_DIR=../src/quakec/progs.src
mkdir -p ../../mymod

if fteqcc -O3 "$PROG_SRC_DIR" >"$LOG" 2>&1; then
  echo "✅ Compile OK"
  tail -n 50 "$LOG"
  exit 0
else
  echo "❌ Compile FAILED"
  echo "---- fteqcc output ----"
  tail -n 50 "$LOG"
  exit 1
fi
