# Phase 2 — Open-Source Firmware Research

- **Date:** 2026-10-25
- **Input from Phase 1:** Allwinner SoC (4 independent clues), Linux kernel
  4.9, model `CDR10`, firmware `V7.0` (2024-12-24), companion app *iDC CAM*
  by Shenzhen Sunchip Technology. **Exact chip model still unknown.**
- **Scope:** Research only. Nothing in this document is to be run against
  the camera. No flashing or installation steps are included.

---

## 1. Summary (plain English)

- Your camera is built on a chip family that **does** have open-source
  activity. That's the good news.
- Community firmware for these chips is **early-stage and chip-specific**.
  Some chips have working pieces; none has a polished "install and go"
  replacement for cameras like yours.
- Two things decide whether replacement is ever realistic: **which exact
  Allwinner chip** it is, and **what kind of memory chip** holds the
  firmware. Both need either a seller/manufacturer answer or a look at the
  circuit board.
- Even in the best case, replacing the firmware would likely **lose image
  quality**, because the picture-tuning software for the specific camera
  sensor is closed and vendor-supplied.
- Recommendation: keep the original firmware, pursue the **safe, no-device
  steps** in §7, and build CreatorOS as a companion app (alternative A/B in
  `05-alternatives.md`) in parallel.

## 2. Which Allwinner chip could it be?

Allwinner's camera chips are the **V-series**. Our evidence (Linux **4.9**,
USB high-speed mass-storage gadget, Wi-Fi, "CDR" car-recorder naming,
Sunchip as designer) narrows the field. Allwinner's own SDK docs list
kernel 4.9 for these camera parts:

| Candidate | Kernel 4.9 in vendor SDK? | Notes | Fit with our evidence |
|-----------|--------------------------|-------|-----------------------|
| **V851s / V853** | Yes (Tina Linux 5.0 offers 4.9 and 5.4) | V851s = V853 die with built-in 64/128 MB RAM; very popular in budget cameras | Plausible |
| **V831 / V833** | Yes (official 4.9) | AI-video chips; V833 boards run Tina Linux | Plausible |
| **V536** | Yes (listed with 4.9 in Tina camera guide) | 4K dashcam / action-cam chip | Plausible (fits "CDR") |
| **V316** | Not confirmed | Low-cost "true 4K30" camera chip | Possible, unverified |
| V3 / V3s | Usually older 3.4 kernel ("Camdroid") | Sunchip has shipped V3 cameras before | Less likely given 4.9 |

Sources: [Tina Linux v5.0 – V853](https://docs.aw-ol.com/v853/en/study/study_1tina/),
[Lindenis V833 wiki](http://wiki.lindeni.org/index.php/Lindenis_V833),
[CNX: V833 board runs Tina Linux](https://www.cnx-software.com/2021/09/01/allwinner-v833-ai-video-development-board-runs-tina-linux-or-melis-rtos/),
[Tina Linux Camera guide](https://zhuanlan.zhihu.com/p/610025228),
[LKML: V853 support series](https://lkml.iu.edu/hypermail/linux/kernel/2502.0/04878.html),
[CNX: V316](https://www.cnx-software.com/?p=66020),
[CNX: V3 action cameras](https://www.cnx-software.com/2015/04/02/allwinner-v3-soc-targets-1080p60-action-cameras-supports-linux-or-camdroid-os/).

**We cannot pick one from the evidence we have.** Treat every row as
*suspected* until a chip marking or official statement confirms it.

## 3. Open-source projects that matter

| Project | What it is | Relevant chips | Maturity for a camera like this |
|---------|-----------|----------------|-------------------------------|
| **Allwinner Tina Linux SDK** | Allwinner's own Linux SDK (an OpenWrt fork) that this camera's firmware is almost certainly built from | V853/V851s, V833, V536, … | Vendor SDK. V851s SDK is public ([Yuzukilizard V851s Tina SDK](https://github.com/DongshanPI/Yuzukilizard-v851s-TinaSDK)); docs public for V853. The vendor's camera app and picture tuning are **not** included |
| **OpenIPC** | Open firmware for IP cameras | V851s, V83x (also V3s U-Boot work) | V851s: camera-tested bootloader image, reaches a shell. V831: kernel boots to a shell. Much of it is still open pull requests. **No ready solution for a handheld camera with screen and buttons** ([PR #72](https://github.com/OpenIPC/u-boot/pull/72), [PR #73](https://github.com/OpenIPC/u-boot/pull/73), [PR #65](https://github.com/OpenIPC/u-boot/pull/65), [SoC support](https://deepwiki.com/OpenIPC/firmware/5-soc-support)) |
| **linux-sunxi / mainline Linux** | Community upstream support for Allwinner chips | V3s merged; V853/V851s and V831/V833 work in progress; V536 not listed | Not usable as a full camera OS yet; no video encoder/ISP support comparable to the vendor's ([Mainlining Effort](https://linux-sunxi.org/Mainlining_Effort)) |
| **sunxi-tools (`sunxi-fel`)** | Talks to the chip's built-in USB recovery mode ("FEL") | Many; per-chip support varies | Can *read* SPI flash on supported chips — a potential future **backup** path. V536 support is an unmerged, single-device PR ([PR #254](https://github.com/linux-sunxi/sunxi-tools/pull/254), [issue #148](https://github.com/linux-sunxi/sunxi-tools/issues/148), [man page](https://manpages.debian.org/unstable/sunxi-tools/sunxi-fel.1)) |
| **sunxi-fw** | Inspects and extracts Allwinner firmware image files | All | Useful **offline**, on a downloaded update file — no camera needed ([apritzel/sunxi-fw](https://github.com/apritzel/sunxi-fw)) |

## 4. What similar devices teach us

| Device | What people did | Lesson |
|--------|-----------------|--------|
| Allwinner V3 action/dash cams | Root shell via ADB in a charging mode; partition dumps over ADB ([DashCamTalk thread](https://dashcamtalk.com/forum/threads/hacking-q3h-allwinner-v3-camdroid.20507/), [F60 Action Camera](https://linux-sunxi.org/F60_Action_Camera)) | Older generation; **our camera shows no ADB** in mass-storage mode |
| Tina Linux rear-view-mirror dashcam | Found a serial console (UART) on the board showing a Tina Linux login ([Hackaday project](https://hackaday.io/project/192585-cheapy-rearview-mirror-dashcamcarplayaauto-dev)) | Newer Tina devices are often only reachable by opening the case and using test pads |
| Yi cameras (Allwinner) | Community firmware add-ons installed from SD card ([yi-hack-Allwinner-v2](https://github.com/roleoroleo/yi-hack-Allwinner-v2/wiki/Dump-your-backup-firmware-(SD-card))) | "Add features on top of stock" has worked better than full replacement |

## 5. Recovery: the safety net question

Allwinner chips have a **FEL** recovery mode built into the chip's ROM. It
is used for factory programming and recovery over USB, and appears as USB
ID `1f3a:efe8` ([linux-sunxi FEL](https://linux-sunxi.org/FEL)). It's
entered when no valid boot image is found, or via a recovery button on
boards that have one.

What this means for us:

- It's a promising **backup and recovery** route **if** our chip and flash
  type are supported by the tools, and **if** the camera can be put into
  FEL without opening it (unknown — cameras rarely expose a FEL button).
- It is **not** a guarantee. Reports show official flashing tools hanging
  on some devices, and per-chip support varies.
- Our camera currently appears as `1f3a:100f` (normal Linux mode), not FEL.
  No public source lists `100f`; it is consistent with a vendor-configured
  mass-storage gadget.

No FEL steps are proposed at this stage. Per the backup policy, a firmware
backup counts only when it is read-only, verified twice, and paired with a
known restore path.

## 6. Feasibility verdict (current evidence)

| Goal | Feasible? | Why |
|------|-----------|-----|
| Full custom OS replacing stock firmware | **Not realistic now** | Exact chip unknown; community firmware for these chips is early; camera sensor tuning, screen and button drivers are vendor-specific and closed; high brick risk |
| Add-on features on top of stock firmware | **Unknown, possibly** | Depends on finding a supported entry point (e.g., an official update file to study). Needs the exact chip and a verified backup first |
| CreatorOS companion app (Mac/phone) | **Yes, now** | Works with the camera's files and existing Wi-Fi app link; zero risk |
| Firmware backup (future) | **Possibly** | Depends on chip + flash type + FEL/tool support |

This matches decision gate outcome **"Some answers favourable"** in the
investigation report: limited customization within stock features plus
external tooling.

## 7. Safe next steps (no device modification)

In priority order. None of these touch the camera's firmware.

1. **Ask the seller and Sunchip which chip it uses, and for a firmware
   file and source code.** The Linux kernel is GPL-licensed, so the
   manufacturer is obliged to provide its kernel source on request. Send
   the message in §8. An official firmware file can be studied offline
   with `sunxi-fw`, which would also reveal the exact chip.
2. **Study the iDC CAM app (offline) to learn how it talks to the
   camera.** This feeds directly into the CreatorOS companion app (Wi-Fi
   control, live preview, downloads) without modifying the camera.
3. **Optional: read the chip marking.** Opening the case is the only
   guaranteed way to get the exact chip and flash type. Still optional, and
   only with the precautions in the investigation report (E9).
4. **Re-evaluate** with the exact chip: check OpenIPC, linux-sunxi and
   sunxi-tools support for that specific part and its flash type.

## 8. Message template — ask the seller / manufacturer

> Hello,
>
> I own your camera, model **CDR10**, software version **V7.0**
> (2024-12-24), which uses the **iDC CAM** app by Shenzhen Sunchip
> Technology. Could you please tell me:
>
> 1. Which processor (SoC) the camera uses (for example, Allwinner V-series
>    model number)?
> 2. Whether a firmware update file is available for this model?
> 3. As the camera runs the Linux kernel (GPL v2), please provide the
>    corresponding kernel source code, or tell me where to download it.
>
> Thank you.

Send it via the TikTok Shop order chat, and/or through the iDC CAM app's
feedback/contact option or Sunchip's contact details.
