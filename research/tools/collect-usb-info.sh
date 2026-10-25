#!/usr/bin/env bash
#
# collect-usb-info.sh — READ-ONLY snapshot of USB, camera, and disk info on macOS.
#
# Usage:
#   ./research/tools/collect-usb-info.sh <label>
#
# Examples:
#   ./research/tools/collect-usb-info.sh baseline-unplugged
#   ./research/tools/collect-usb-info.sh mode-mass-storage
#
# Output goes to research/evidence/usb/<timestamp>-<label>/
#
# Every command below only reads information macOS already holds. Nothing is
# sent to, written to, mounted, unmounted, or changed on any connected device.

set -u

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <label>   (e.g. baseline-unplugged, mode-mass-storage)" >&2
  exit 1
fi

label="$(printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_')"
script_dir="$(cd "$(dirname "$0")" && pwd)"
out_dir="$script_dir/../evidence/usb/$(date +%Y%m%d-%H%M%S)-$label"
mkdir -p "$out_dir"

run() {
  local file="$1"
  shift
  {
    echo "\$ $*"
    echo
    "$@" 2>&1
  } > "$out_dir/$file"
  echo "  saved $file"
}

echo "Writing snapshot to: $out_dir"

run sw_vers.txt                  sw_vers
run system_profiler_usb.txt      system_profiler SPUSBDataType
run system_profiler_usbhost.txt  system_profiler SPUSBHostDataType
run system_profiler_camera.txt   system_profiler SPCameraDataType
run ioreg_iousb.txt              ioreg -p IOUSB -l -w 0
run ioreg_usbhostdevice.txt      ioreg -r -c IOUSBHostDevice -l -w 0
run diskutil_list.txt            diskutil list

# Pull out the most useful fields for quick reading.
grep -E '"(idVendor|idProduct|bcdDevice|USB Vendor Name|USB Product Name|USB Serial Number|bDeviceClass|bInterfaceClass|bInterfaceSubClass)"' \
  "$out_dir/ioreg_iousb.txt" "$out_dir/ioreg_usbhostdevice.txt" \
  > "$out_dir/summary_ioreg_fields.txt" 2>/dev/null
echo "  saved summary_ioreg_fields.txt"

echo
echo "Done. Compare against your baseline with, for example:"
echo "  diff <baseline-folder>/system_profiler_usb.txt $out_dir/system_profiler_usb.txt"
