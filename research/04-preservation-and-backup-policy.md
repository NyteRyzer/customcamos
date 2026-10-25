# Preservation and Backup Policy

The original camera must keep working exactly as it did when purchased.
This policy defines what is allowed now, and what must be true before any
future change could even be proposed.

## 1. Allowed in Phase 1

- Looking at, photographing, and filming the camera.
- Using the camera normally (taking photos/videos, browsing menus).
- Plugging it into the Mac and reading USB / disk information.
- Copying files **from** the SD card **to** the Mac.
- Joining the camera's Wi-Fi network and observing addresses.
- Looking up public information (regulatory filings, listings, manuals).

## 2. Not allowed in Phase 1

- Flashing, erasing, updating, or downgrading firmware.
- Selecting *Format*, *Reset*, or *Firmware update* in the menu.
- Placing any downloaded file on the camera's SD card.
- Connecting anything to internal test pads, headers, or chips.
- Writing to the camera's storage from the Mac.
- Active network probing (scanners, fuzzers, password tools).

## 3. Baseline record of original functionality

Before Phase 2, the evidence folder must contain:

- [ ] Firmware version string
- [ ] Photos of every menu page with default/current values
- [ ] A sample photo and video at each resolution, with metadata saved
- [ ] USB identity for every USB mode
- [ ] Wi-Fi SSID / IP / app behaviour notes

This is what "working as before" is measured against.

## 4. SD card handling

The SD card is removable media, not the camera's firmware, but treating
it carefully avoids surprises:

- **Copy media off first.** Ordinary Finder copy to the Mac.
- **macOS adds hidden files** (e.g. `.Spotlight-V100`, `.fseventsd`,
  `.Trashes`) to most volumes it mounts. These are harmless to the camera
  in nearly all cases, but they *are* writes. To avoid them entirely,
  read the card in a USB/SD card reader with the card's physical **lock
  switch** slid to the locked position — macOS will then mount it
  read-only.
- **Card image backup (optional, recommended).** A full image of the card
  can be made with Disk Utility: select the card's device (not the volume)
  → *File → New Image → Image from "…"* → save to the Mac. This only reads
  the card. Record the image's SHA-256:
  `shasum -a 256 ~/path/to/card.dmg`
- **Never let macOS "Initialize" or "repair" the card.**

## 5. Firmware backup — definition only (no procedure yet)

The camera's firmware almost certainly lives in a flash chip on the main
board, not on the SD card. Backing it up is **not** part of Phase 1, and
no procedure is provided here, because the correct, safe method depends
entirely on the identified SoC and flash chip.

For the project, a firmware backup only counts as valid when **all** of
the following are true:

1. It was obtained by a **read-only** method documented for the identified
   hardware.
2. At least **two independent reads** produce **identical** checksums.
3. The image has been inspected and looks plausible (expected size,
   recognizable structure, not all `0xFF`/`0x00`).
4. A **restore path** is documented and understood — including what to do
   if the camera no longer boots — before anything is ever written.
5. Copies are stored in at least two places off the camera.

Until those conditions are met, the project stays read-only.

## 6. Go / no-go for any future modification

A future modification may only be *proposed* (not performed) when:

- [ ] SoC confirmed (definitive source)
- [ ] Valid firmware backup per §5
- [ ] Documented recovery method that works even if the camera won't boot
- [ ] Owner explicitly accepts the risk of permanent damage in writing in
      `evidence/evidence-log.md`
