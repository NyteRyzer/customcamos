# Evidence Log

One row per finding. **Source** = file in this folder, URL, or "observed".
**Confidence** = confirmed / suspected / unknown.

> Privacy: redact serial numbers, order numbers, addresses, and Wi-Fi
> passwords before sharing this repository publicly.

## Identity

| Item | Value | Source | Confidence |
|------|-------|--------|------------|
| Brand | | | unknown |
| Model | `CDR10` (Settings → Device info) | menu photo, 2026-10-25 | confirmed (as reported by firmware) |
| OEM / manufacturer | | | unknown |
| FCC ID / other regulatory ID | **None printed** on bottom label — FCC logo only (no ID number), plus CE, UKCA, WEEE marks | bottom label photo, 2026-10-25 (kept locally, not committed: shows serial) | confirmed for bottom label; battery bay / box / on-screen e-label not yet checked |
| Seller (TikTok Shop) | | | unknown |
| Same hardware sold as | | | unknown |
| Purchase date | | | unknown |
| Bottom label text | `DC IN-5V`, `MADE IN CHINA`, `SN:2025…` (redacted; prefix may be a 2025 build date) | bottom label photo | confirmed |

## Firmware

| Item | Value | Source | Confidence |
|------|-------|--------|------------|
| Firmware version (menu) | `V7.0` | Device info screen | confirmed |
| Version shown at boot | | | unknown |
| Firmware build date | `2024-12-24 12:00:00` ("Update Time") | Device info screen | confirmed |
| Official updates available? | | | unknown |
| EXIF "Software" string | | | unknown |

## USB (one block per mode)

### Mode: Mass storage

| Field | Value |
|-------|-------|
| On-screen mode name | |
| Finder volume name | `UDISK` (observed 2026-10-25) — generic label, weak hint only |
| Vendor ID (hex) | `0x1f3a` (decimal 7994) |
| Product ID (hex) | `0x100f` (decimal 4111) |
| Manufacturer string | `Android` |
| Product string | `IOUSBHostDevice` (macOS placeholder; device sent none) |
| Serial string | `20080411` |
| Interface class(es) | One interface only: class 8 / subclass 6 / protocol 80 = Mass Storage, SCSI, Bulk-Only. 1 configuration. **No ADB interface** (255/66/1) in this mode |
| Speed | Up to 480 Mb/s (USB 2.0 High-Speed) |
| bcdDevice / Version | `0x0409` / 4.09 |
| diskutil media name (storage) | `File-Stor Gadget`, FAT32, 31.3 GB, exposed **read-only** to the Mac |
| Snapshot folder | `usb/20261025-0755-mode-mass-storage/` |
| VID lookup result | `0x1f3a` = Allwinner Technology |

## SD card

| Item | Value | Source |
|------|-------|--------|
| File system / size | FAT32, 31.3 GB (1.1 GB used) | usb/20261025-0755-mode-mass-storage |
| Top-level folders | `.data/` (empty), `DCIM/` | same |
| Photo naming pattern | not yet seen (no photos on card) | same |
| Video naming pattern / container | `DCIM/100MEDIA/ANMRnnnn.mp4` | same |
| EXIF Make / Model | | |
| Video metadata strings | Only `VideoHandler` (track handler name used by FFmpeg-derived MP4 writers, incl. Allwinner CedarX); no chip/SDK names. Other matches were random bytes | `strings` on ANMR0003.mp4, 2026-10-25 |
| Non-media files created by camera | `DCIM/.thumb/ANMRnnnn.thm` + `ANMRnnnn.sec` (per-video, 3–25 MB `.sec`, purpose unknown) | same |

## Wi-Fi

| Item | Value | Source | Confidence |
|------|-------|--------|------------|
| SSID pattern | | | |
| Camera IP | | | |
| Mac IP / subnet | | | |
| Camera MAC OUI (first 3 bytes only) | | | |
| OUI vendor (Wi-Fi chip) | | | |
| Companion app (name / developer) | | | |
| Web page at camera IP? | | | |

## Hardware

| Component | Marking | Source (FCC photo / internal photo) | Confidence |
|-----------|---------|-------------------------------------|------------|
| SoC | Allwinner (exact model unknown); runs Linux kernel 4.9 | USB evidence, see Conclusions | vendor **confirmed**, model unknown |
| Flash memory | | | unknown |
| RAM (if separate) | | | unknown |
| Image sensor | | | unknown |
| Wi-Fi module | | | unknown |
| Test pads / headers seen | | | unknown |

## Conclusions

| Date | Conclusion | Based on |
|------|------------|----------|
| 2026-10-25 | SoC vendor is **Allwinner** | (1) USB VID `0x1f3a` is Allwinner's; (2) `UDISK` is the user-data volume name used in Allwinner's SDKs; (3) serial `20080411` is a known Allwinner BSP gadget default |
| 2026-10-25 | Camera runs a **Linux** kernel, version **4.9** | `File-Stor Gadget` is the Linux kernel USB mass-storage gadget's product name; Linux sets the gadget's bcdDevice to the kernel version → `0x0409` = 4.9; Manufacturer `Android` is the Allwinner Linux gadget driver's default string |
| 2026-10-25 | Model `CDR10` gives no public matches yet; "CDR" is a common abbreviation for *car digital recorder*, consistent with Allwinner's car-DVR/IP-camera V-series software lineage | Device info screen + web search (no CDR10 hits) — **hint only** |
| 2026-10-25 | Not the camera: Sunplus `0x1bcf:0x08a0` and SEMICO keyboard | Low-speed (1.5 Mb/s) devices behind the same hub — mouse/keyboard, not the camera |

## Risk acceptance (future modification only)

Leave empty unless and until the go/no-go criteria in
`04-preservation-and-backup-policy.md` §6 are all met.
