# Research Folder

| File | Purpose |
|------|---------|
| [`01-hardware-investigation-report.md`](01-hardware-investigation-report.md) | Main report: what is known, what is unknown, exactly which evidence to collect, and how it will be interpreted |
| [`02-hardware-identification-checklist.md`](02-hardware-identification-checklist.md) | Tick-box checklist to work through with the camera in hand |
| [`03-macos-usb-inspection.md`](03-macos-usb-inspection.md) | Safe, read-only ways to inspect USB information on a Mac |
| [`04-preservation-and-backup-policy.md`](04-preservation-and-backup-policy.md) | Rules that protect the original camera and define what "backed up" means |
| [`05-alternatives.md`](05-alternatives.md) | Realistic paths if full firmware replacement is not feasible |
| [`06-open-source-firmware-research.md`](06-open-source-firmware-research.md) | Phase 2: Allwinner chip candidates, open-source projects, recovery options, feasibility verdict, safe next steps |
| [`evidence/evidence-log.md`](evidence/evidence-log.md) | Fill-in log where every finding is recorded with its source |
| [`tools/collect-usb-info.sh`](tools/collect-usb-info.sh) | Read-only macOS script that snapshots USB/disk/camera info into `evidence/usb/` |

## Phase plan

| Phase | Goal | Touches the camera? | Status |
|-------|------|---------------------|--------|
| 1 | Identify brand, model, firmware version, SoC, Wi-Fi module | Read-only observation only | **Mostly done** — Allwinner / Linux 4.9 / CDR10 V7.0; exact chip model open |
| 2 | Research existing open-source / community firmware for the identified SoC | No | **First pass done** (family level) |
| 3 | Feasibility decision: replace firmware vs. build an alternative | No | **Provisional:** full replacement not realistic now; companion app recommended |
| 4 | Backup plan (verified, restorable) — planning only | Planning only | Not started |
| 5 | Any modification | Only after explicit go/no-go review | Not planned |

## Evidence folder layout

```
evidence/
  evidence-log.md   ← the single source of truth for findings
  photos/           ← label, box, manual, menu-screen photos
  usb/              ← output from tools/collect-usb-info.sh
  wifi/             ← SSID, IP, app screenshots, network notes
```

Name photos descriptively, e.g. `photos/label-bottom-01.jpg`,
`photos/menu-version-screen.jpg`.
