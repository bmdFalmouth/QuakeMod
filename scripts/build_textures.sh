#!/usr/bin/env zsh
set -euo pipefail

# Usage:
#   ./build_textures.sh <input_dir> <wad_out> <gamedir> [map_name]
#
# Example (global replacement in id1):
#   ./build_textures.sh ./textures ./mytextures.wad /path/to/quake/id1
#
# Example (map-specific replacement in a mod folder):
#   ./build_textures.sh ./textures ./mytextures.wad /path/to/quake/mymod mymap

if (( $# < 3 )); then
  echo "Usage: $0 <input_dir> <wad_out> <gamedir> [map_name]"
  exit 1
fi

INPUT_DIR="$1"
WAD_OUT="$2"
GAMEDIR="$3"
MAP_NAME="${4:-}"   # Optional

# Paths to quake-export tools
Q_MIP="/Users/bm199305/dev/quake/quake-tools/miptex-export"
Q_WAD="/Users/bm199305/dev/quake/quake-tools/wad-export"

MAX_SIZE=512

# Check dependencies
command -v magick >/dev/null || { echo "ImageMagick not found. Install: brew install imagemagick"; exit 1; }
command -v "$Q_MIP" >/dev/null || { echo "quake-miptex-export not found in PATH."; exit 1; }
command -v "$Q_WAD" >/dev/null || { echo "quake-wad-export not found in PATH."; exit 1; }

# Check input dir
if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Error: Input directory '$INPUT_DIR' does not exist."
  exit 1
fi

typeset -a IMG_GLOBS
IMG_GLOBS=( "$INPUT_DIR"/*.png(N) "$INPUT_DIR"/*.tga(N) "$INPUT_DIR"/*.jpg(N) "$INPUT_DIR"/*.jpeg(N) )
if (( ${#IMG_GLOBS} == 0 )); then
  echo "No images found in $INPUT_DIR (png/tga/jpg)."
  exit 1
fi

# Temp dirs
TMP_DIR=$(mktemp -d)
FIX_DIR=$(mktemp -d)

# External replacement dir
if [[ -n "$MAP_NAME" ]]; then
  REPL_DIR="${GAMEDIR}/textures/${MAP_NAME}"
else
  REPL_DIR="${GAMEDIR}/textures"
fi
mkdir -p "$REPL_DIR"

nearest_mul8_down() {
  local n=$1
  (( n < 8 )) && echo 8 && return
  echo $(( (n/8)*8 ))
}

echo "== Normalizing images for WAD (≤${MAX_SIZE}, multiples of 8, strip alpha)…"
for f in "${IMG_GLOBS[@]}"; do
  base="${f:t:r}"
  short="${base[1,${#base} < 15 ? ${#base} : 15]}"
  read w h <<<"$(magick identify -format "%w %h" "$f")"
  (( w = w > MAX_SIZE ? MAX_SIZE : w ))
  (( h = h > MAX_SIZE ? MAX_SIZE : h ))
  w8=$(nearest_mul8_down $w)
  h8=$(nearest_mul8_down $h)
  fixed_png="${FIX_DIR}/${short}.png"
  magick "$f" -alpha off -strip -resize ${w8}x${h8}\! -define png:color-type=2 "$fixed_png"
  echo "   $f -> ${fixed_png} (${w8}x${h8})"
done

echo "== Converting to MIPTEX with quake-miptex-export…"
for p in "${FIX_DIR}"/*.png(N); do
  name="${p:t:r}"
  out_mip="${TMP_DIR}/${name}.mip"
  "$Q_MIP" --name "$name" --input "$p" --output "$out_mip"
  echo "   ${name} -> ${out_mip}"
done

echo "== Packing WAD with quake-wad-export…"
"$Q_WAD" --output "$WAD_OUT" "${TMP_DIR}"/*.mip
echo "   WAD written: $WAD_OUT"

echo "== Copying ORIGINAL hi-res images for vkQuake external replacements…"
for f in "${IMG_GLOBS[@]}"; do
  base="${f:t:r}"
  short="${base[1,${#base} < 15 ? ${#base} : 15]}"
  case "${f:l}" in
    *.png|*.tga)
      cp -f "$f" "${REPL_DIR}/${short}.${f:e:l}"
      ;;
    *.jpg|*.jpeg)
      magick "$f" -strip "${REPL_DIR}/${short}.png"
      ;;
  esac
done
echo "   Replacements copied to: $REPL_DIR"

echo "== All done! =="
echo "1) Add ${WAD_OUT} to TrenchBroom (Map → Map Properties → Texture Wads)"
if [[ -n "$MAP_NAME" ]]; then
  echo "2) In vkQuake, replacements will load only for map: ${MAP_NAME}"
else
  echo "2) In vkQuake, replacements will apply globally in ${GAMEDIR:t}"
fi
echo "3) Use 'restart' in vkQuake console or restart engine to reload textures."
