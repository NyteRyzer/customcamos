# Start Here — Camera Report in 3 Steps

No experience needed. This only **reads** information. It does not change
anything on your camera or your Mac (it just saves one text file to your
Desktop).

## Step 1 — Plug in the camera

Connect the camera to your Mac with its USB cable and choose
**Mass Storage** on the camera if it asks. Wait until **UDISK** shows up.

> If your Mac ever asks to "Initialize" the disk, click **Ignore**.

## Step 2 — Open Terminal

Press **⌘ Command + Space**, type **Terminal**, press **Return**.
A window with text appears. That's it.

## Step 3 — Copy, paste, press Return

Copy this whole line, paste it into Terminal (**⌘ Command + V**), and
press **Return**:

```bash
cd ~/Desktop && { echo "=== CAMERA REPORT $(date) ==="; sw_vers; echo; echo "=== USB DEVICES ==="; system_profiler SPUSBDataType 2>/dev/null; system_profiler SPUSBHostDataType 2>/dev/null; echo "=== USB IDS ==="; ioreg -p IOUSB -l -w 0 | grep -E '"(idVendor|idProduct|bcdDevice|USB Vendor Name|USB Product Name|USB Serial Number)"'; echo "=== EXTERNAL DISKS ==="; diskutil list external; for d in $(diskutil list external | awk '/^\/dev\//{print $1}'); do diskutil info "$d"; done; echo "=== FILES ON UDISK ==="; ls -laR /Volumes/UDISK 2>&1 | head -n 200; echo "=== WEBCAMS ==="; system_profiler SPCameraDataType; } > camera-report.txt 2>&1; open camera-report.txt
```

After a few seconds a file called **camera-report.txt** opens (it's also
on your Desktop).

## Step 4 — Send it back

Drag **camera-report.txt** into the chat, or open it, press
**⌘ Command + A**, **⌘ Command + C**, and paste it.

Then eject **UDISK** in Finder before unplugging the camera.

---

### What that line does (in plain English)

| Part | What it does |
|------|--------------|
| `system_profiler …` | Lists the USB devices your Mac can see (the System Information app, in text form) |
| `ioreg … grep …` | Picks out each device's ID numbers and name |
| `diskutil list` / `diskutil info` | Describes the disks that are plugged in (looking only, no repairs or erasing) |
| `ls /Volumes/UDISK` | Lists the file and folder names on the camera |
| `> camera-report.txt` / `open` | Saves everything to one file on your Desktop and opens it |

The report also lists other USB devices plugged into your Mac (keyboard,
hubs, etc.). That's normal and harmless to share.
