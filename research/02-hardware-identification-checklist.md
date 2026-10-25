# Hardware Identification Checklist

Work top to bottom. Record each result in
[`evidence/evidence-log.md`](evidence/evidence-log.md). Everything here is
read-only; anything marked ⚠️ is a reminder of what **not** to do.

## 0. Before you start

- [ ] Copy all existing photos/videos from the SD card to the Mac (normal
      Finder copy) so nothing can be lost.
- [ ] Charge the camera fully.
- [ ] Have good lighting and a phone camera with macro / close-focus.
- [ ] ⚠️ Do not select *Format*, *Reset*, *Default settings*, or
      *Firmware update* in the camera menu at any point.

## 1. Physical labels (E1)

- [ ] Photo: bottom of camera
- [ ] Photo: back and both sides
- [ ] Photo: around lens ring / front plate
- [ ] Photo: battery compartment (battery removed)
- [ ] Photo: battery (both sides)
- [ ] Photo: SD slot area, port area, any flaps
- [ ] Recorded: brand name (if any)
- [ ] Recorded: model number (if any)
- [ ] Recorded: serial number (if any) — keep private, redact before sharing
- [ ] Recorded: **FCC ID** (if any)
- [ ] Recorded: other IDs (CE, IC, UKCA, KC, TELEC, …)
- [ ] Recorded: manufacture date / batch code
- [ ] Recorded: USB connector type (USB-C / micro-USB / mini-USB)

## 2. Box, manual, listing (E2)

- [ ] Photo: all six sides of the box
- [ ] Photo: every page of the manual
- [ ] Photo: any inserts / QR codes / support contact cards
- [ ] Screenshot: TikTok Shop listing (title, specs, images, seller)
- [ ] Screenshot: order details page
- [ ] Recorded: companion app name from manual / QR code

## 3. Camera menu & firmware version (E3)

- [ ] Recorded: firmware version string (exactly as displayed)
- [ ] Recorded: any build date / other version info
- [ ] Video: power-on sequence (watch for version on boot screen)
- [ ] Photo: every menu page (baseline of original functionality)
- [ ] Recorded: all video resolutions / frame rates offered
- [ ] Recorded: all photo resolutions offered
- [ ] Recorded: menu language list
- [ ] Noted (not used): location of Format / Reset / Update entries

## 4. USB enumeration on the Mac (E4)

See [`03-macos-usb-inspection.md`](03-macos-usb-inspection.md).

- [ ] Baseline snapshot taken with camera **unplugged**
- [ ] Recorded: what the camera shows on screen when plugged in (mode menu?)
- [ ] For each USB mode offered:
  - [ ] Snapshot taken
  - [ ] Vendor ID (VID): `0x____`
  - [ ] Product ID (PID): `0x____`
  - [ ] Manufacturer string
  - [ ] Product string
  - [ ] Serial string (if any)
  - [ ] USB class (Mass Storage / Video / Still Image / Vendor-specific)
  - [ ] USB speed
  - [ ] BCD device version
- [ ] VID looked up in the USB ID database
- [ ] Mass-storage mode: `diskutil` media name, size, file system recorded
- [ ] Webcam mode (if any): name as shown by `system_profiler SPCameraDataType`
- [ ] ⚠️ If macOS says the disk is unreadable → clicked **Ignore** (never Initialize)
- [ ] Ejected properly before unplugging

## 5. SD card contents (E5)

- [ ] Folder tree saved (`find … > sdcard-tree.txt`)
- [ ] Photo metadata saved (`mdls` / `exiftool`)
- [ ] Video metadata saved
- [ ] Recorded: EXIF Make / Model / Software strings
- [ ] Listed: any non-media files the camera created
- [ ] ⚠️ Nothing on the card was edited, renamed, or deleted

## 6. Wi-Fi (E6)

- [ ] Recorded: SSID pattern
- [ ] Recorded: default password source (manual / sticker / screen)
- [ ] Recorded: companion app name, developer, store link
- [ ] Recorded: camera IP address and Mac's assigned IP / subnet
- [ ] Recorded: camera MAC address (from `arp -a`)
- [ ] MAC OUI looked up → Wi-Fi chip vendor
- [ ] Recorded: whether `http://<camera-ip>/` shows anything
- [ ] ⚠️ No scanners, no password tools, no setting changes

## 7. Regulatory lookup (E7)

- [ ] FCC ID searched (fccid.io / FCC OET)
- [ ] Internal photos downloaded
- [ ] External photos / user manual / test report downloaded
- [ ] Chip markings read from internal photos

## 8. Vendor firmware (E8)

- [ ] Searched for official firmware update for this model
- [ ] If found: downloaded to Mac only, source URL and checksum recorded
- [ ] ⚠️ Not copied to the camera's SD card

## 9. Internal inspection (E9) — OPTIONAL, LAST RESORT

Only if sections 1–8 failed to identify the SoC.

- [ ] Decided the risk is acceptable
- [ ] Battery, SD card, USB removed
- [ ] Photos of each disassembly step
- [ ] Main SoC marking recorded
- [ ] Flash chip marking(s) recorded
- [ ] Image sensor / ribbon markings recorded
- [ ] Wi-Fi module marking recorded
- [ ] Any labelled test pads / headers photographed (not connected to)
- [ ] Reassembled; camera verified working as before

## 10. Phase 1 exit criteria

- [ ] Product identity known or best match documented
- [ ] Firmware version recorded
- [ ] USB identity recorded for every mode
- [ ] SoC identified as **confirmed** or **suspected** (per the report's
      identification rule)
- [ ] Wi-Fi chip vendor known
- [ ] Baseline of original functionality recorded (menu photos)
