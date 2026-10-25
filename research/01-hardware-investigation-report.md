# Hardware Investigation Report — CreatorOS Phase 1

- **Date opened:** 2026-10-25
- **Status:** Evidence collection not yet started
- **Scope:** Identify the camera's hardware and software platform using only
  read-only, non-destructive methods. No flashing, erasing, or modification.

---

## 1. Summary

The goal of CreatorOS is a custom operating system or firmware for an
unbranded budget Wi-Fi camera. Whether that is possible depends almost
entirely on one fact we do not yet know: **which system-on-chip (SoC) the
camera is built on, and what software platform the factory firmware uses.**

Budget cameras of this type are built on many different SoC families. Some
of these platforms run Linux, many run a small real-time OS (RTOS) or
fully proprietary firmware, and the tooling, documentation, and community
support varies enormously between them. Until evidence says otherwise, this
report treats the platform as **completely unknown**.

This report lists exactly what evidence to collect, why each item matters,
and how the result will be interpreted.

## 2. What we know

| Attribute | Value | Source |
|-----------|-------|--------|
| Brand | Unknown | — |
| Model | Unknown | — |
| Purchased from | TikTok Shop | Owner |
| Wi-Fi | Present | Owner |
| Controls | Physical buttons | Owner |
| Factory UI | Basic camera menu | Owner |
| Development computer | Mac | Owner |

## 3. What we need to learn (in priority order)

| # | Question | Why it matters |
|---|----------|----------------|
| Q1 | What is the exact product (brand / model / OEM)? | Unlocks manuals, firmware updates, and other owners' findings |
| Q2 | Does it have an FCC ID or other regulatory ID? | Regulatory filings often include **internal photos** showing chip markings — identification without opening the camera |
| Q3 | What firmware version does it report? | Pins the exact software build; needed for any future backup/restore comparison |
| Q4 | How does it enumerate over USB (VID, PID, class, strings)? | The USB vendor ID often reveals the SoC vendor directly |
| Q5 | What does its Wi-Fi expose (SSID pattern, IP range, MAC OUI, companion app)? | The MAC OUI identifies the Wi-Fi chip vendor; the companion app often identifies the SoC platform family |
| Q6 | What files does it create on the SD card? | Folder structures, file names, and metadata (EXIF "Make"/"Model"/"Software") frequently carry vendor or platform strings |
| Q7 | Which SoC, flash memory, image sensor, and Wi-Fi module are on the board? | The definitive answer; everything in Phase 2 depends on it |
| Q8 | Does the vendor publish firmware updates? | An official update file is the safest possible thing to study — no device access required |

## 4. Evidence to collect

Each item lists **what to capture**, **how**, and **where to save it**.
Record every finding in [`evidence/evidence-log.md`](evidence/evidence-log.md)
with its source. Work through the
[checklist](02-hardware-identification-checklist.md) in order.

### E1 — Physical labels and markings (no tools, no opening)

Capture clear, well-lit, in-focus photos of:

- Every sticker or printed text on the body: bottom, back, sides, under the
  strap loop, around the lens ring.
- The **battery compartment**, including underneath the battery (labels are
  often hidden here).
- The **battery itself** (model, capacity, manufacturer).
- The **SD card slot** area and any covers/flaps.
- Any **ports** (USB-C / micro-USB / mini-USB) and their labels.

Look specifically for: brand, model number, serial number, **FCC ID**, CE
mark, IC ID, other regulatory IDs, manufacture date, "Made in…", lot/batch
codes, QR codes.

Save to: `evidence/photos/label-*.jpg`

### E2 — Packaging, manual, and listing

- Photos of every side of the box, including barcodes and small print.
- Photos or scans of every page of the manual / quick-start guide.
- Any included cards (warranty, app download QR code, support email).
- Screenshots of the **TikTok Shop listing** (title, specs, seller name,
  product images) and your order page.

Why: budget cameras are typically sold under many different brand names.
The same hardware may be sold elsewhere under a model name that has
documentation and an existing owner community. Manual wording, menu
screenshots in listings, and app names are strong cross-reference clues.

Save to: `evidence/photos/box-*.jpg`, `evidence/photos/manual-*.jpg`,
`evidence/photos/listing-*.png`

### E3 — On-camera menu and firmware version

Using the camera's normal menu only:

- Find any **Version / About / System Info / Firmware / FW** entry and
  photograph it. Some cameras show version information only during startup
  — record a short video of a power-on.
- Photograph **every menu page** (all settings, all values). This is the
  baseline record of original functionality.
- Note the supported resolutions/frame rates, photo sizes, and any
  "Format", "Reset", or "Update" entries — **note them, do not select them**.

Save to: `evidence/photos/menu-*.jpg`, `evidence/photos/boot-video.mp4`
(videos are git-ignored to keep the repository small; keep them locally)

### E4 — USB enumeration (macOS, read-only)

Follow [`03-macos-usb-inspection.md`](03-macos-usb-inspection.md). For
**each** USB mode the camera offers when plugged in (commonly some of:
mass storage, "PC camera"/webcam, charge-only):

- Vendor ID (VID) and Product ID (PID)
- Manufacturer and product strings
- Serial number string (if any)
- USB class: Mass Storage, Video (UVC), Still Image (PTP), vendor-specific
- USB speed and BCD device version
- For mass storage: the disk's media name, size, and partition/file system
  as reported by `diskutil`

Save to: `evidence/usb/` (the helper script does this automatically)

### E5 — SD card contents (read-only copy)

With a card the camera has already used:

- Folder tree of the card (e.g. `DCIM/…`, any vendor folders).
- A sample photo's and a sample video's **metadata**: EXIF Make, Model,
  Software, and the video container's encoder/handler strings.
- Any non-media files the camera created (settings files, logs, hidden
  files). Do not edit or delete them.

How (on the Mac, read-only):

```bash
# List the full tree of the card (replace NAME with the volume name)
find /Volumes/NAME -print > ~/Desktop/sdcard-tree.txt

# Show metadata of a sample photo / video (built into macOS)
mdls /Volumes/NAME/DCIM/path/to/PHOTO.JPG
mdls /Volumes/NAME/DCIM/path/to/VIDEO.MP4
```

If you have [ExifTool](https://exiftool.org/) installed, `exiftool -a -G1 FILE`
gives much more detail and is also read-only.

See [§4 of the backup policy](04-preservation-and-backup-policy.md#4-sd-card-handling)
for preventing macOS from writing its own hidden files to the card.

Save to: `evidence/usb/sdcard-tree.txt`, `evidence/usb/metadata-*.txt`

### E6 — Wi-Fi behaviour (observation only)

- The **SSID** the camera broadcasts and its default password (from manual).
- The **companion app** name, developer, and app-store link (screenshot).
- After joining the camera's network from the Mac, record (read-only):

  ```bash
  networksetup -getinfo Wi-Fi   # your IP, subnet, router (= camera) IP
  arp -a                        # camera IP and its MAC address
  ```

- The first three bytes of the camera's MAC address (the **OUI**) — look it
  up at <https://maclookup.app/> or the IEEE registry to identify the Wi-Fi
  chip vendor.
- Optionally, a web browser visit to `http://<camera-ip>/` — note whether
  any page appears. Do not submit forms or change settings.

Do **not** run port scanners, fuzzers, or password tools against the camera
at this stage. Cheap firmware can crash or misbehave under unexpected
traffic, and none of that is needed for identification.

Save to: `evidence/wifi/`

### E7 — Regulatory filing lookup (no device access)

If an **FCC ID** is found (format: grantee code + product code, e.g.
`2AXXX-ABC123`):

- Look it up at <https://fccid.io/> or the FCC's official search at
  <https://apps.fcc.gov/oetcf/eas/reports/GenericSearch.cfm>.
- Download the **Internal Photos**, **External Photos**, **User Manual**,
  and **Test Report** exhibits. Internal photos often show chip markings
  clearly enough to identify the SoC, flash, and Wi-Fi module.

Save to: `evidence/photos/fcc-*.jpg` / `.pdf`

### E8 — Vendor firmware updates (no device access)

Search for an official firmware update for the identified model (manual,
seller, brand website, app). If one exists, download it **to the Mac only**
for later offline study. Do **not** copy it to the camera's SD card — some
cameras apply an update file automatically at boot.

Save to: `evidence/firmware-downloads/` (create when needed; do not
commit vendor binaries to git — see `.gitignore`)

### E9 — Internal inspection (OPTIONAL, last resort)

Only if E1–E8 do not identify the SoC, and only if you are comfortable
accepting the risk of cosmetic damage, broken clips, or torn ribbon cables.
**Not required, and not recommended as a first step.**

- Remove the battery and SD card first; disconnect USB.
- Photograph each layer as you open it so it can be reassembled.
- Photograph chip markings at a slant under strong light (laser-etched
  markings read better at an angle). Target: the largest chip near the
  sensor ribbon (likely SoC), the 8-pin chip(s) nearby (likely flash), any
  metal-shielded module near the antenna (likely Wi-Fi), and any unpopulated
  pin headers or test pads labelled TX/RX/GND.
- Touch nothing with tools beyond what disassembly requires. Do **not**
  connect anything to test pads.

Save to: `evidence/photos/internal-*.jpg`

## 5. How evidence will be interpreted

Nothing below is an assumption about this camera — it is how each kind of
clue gets turned into a conclusion.

| Evidence | What it can tell us | Confidence |
|----------|---------------------|------------|
| FCC internal photos / direct chip markings | SoC, flash, sensor, Wi-Fi part numbers | **Definitive** |
| USB Vendor ID | Often the SoC vendor (when the factory left the chip vendor's default VID in place) — or a generic/bridge vendor | Strong hint, must be corroborated |
| USB strings / SCSI inquiry strings | Vendor or SDK names left in by the factory | Strong hint |
| Firmware update file names / headers | Platform family and SDK | Strong hint |
| EXIF "Make"/"Software" | Brand/OEM, sometimes platform | Moderate hint |
| Companion app identity | Platform family (apps are often tied to an SoC vendor's SDK) | Moderate hint |
| Wi-Fi MAC OUI | Wi-Fi chip vendor only — not the SoC | Narrow, but reliable for what it covers |
| Menu layout / fonts / folder names | Platform family, by matching against other cameras | Weak hint |

**Identification rule:** a conclusion about the SoC is recorded as
*confirmed* only with a definitive source (chip marking or regulatory
photo), or with at least two independent strong hints that agree.
Otherwise it stays *suspected*.

## 6. Decision gate after Phase 1

Once the SoC is identified, Phase 2 (open-source firmware research) begins
and answers:

1. Is the SoC's software platform Linux, an RTOS, or proprietary?
2. Is there public documentation, an SDK, or source code (e.g. GPL releases)?
3. Is there an active open-source or community firmware project for this
   SoC or for cameras built on it?
4. Is there a documented, **recoverable** method to back up and restore the
   original firmware?

| Outcome | Next step |
|---------|-----------|
| All four answers favourable | Plan a backup and an *additive* approach first (e.g. scripts/tools alongside stock firmware), with full replacement considered last |
| Some answers favourable | Limited customization within the stock firmware's documented features + external tooling |
| None favourable / SoC unidentifiable | Pursue an alternative in [`05-alternatives.md`](05-alternatives.md) |

No flashing or firmware installation is in scope for any outcome of this
report.

## 7. Risks and safeguards

| Risk | Safeguard |
|------|-----------|
| macOS writes hidden files (`.Spotlight-V100`, `.fseventsd`, `.Trashes`) to the SD card | Use a card reader with the SD lock switch engaged, or accept and document it — see backup policy §4 |
| macOS shows "The disk you inserted was not readable" | Click **Ignore**. Never click *Initialize*. Never run Disk Utility *First Aid* or *Erase* on the camera or its card |
| Accidentally choosing *Format*, *Reset*, or *Update* in the camera menu | Photograph those menus; never select them during Phase 1 |
| Placing a downloaded firmware file on the SD card triggers an auto-update | Keep downloaded firmware on the Mac only |
| Network probing crashes the camera | Observation only; no scanners in Phase 1 |
| Physical damage when opening the case | Internal inspection is optional and last resort |
| Data loss on the SD card | Copy existing media to the Mac before any investigation |
