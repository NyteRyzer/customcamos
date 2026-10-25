# Inspecting USB Information on macOS (Read-Only)

Every command in this guide **only reads** information that macOS already
collected when the camera was plugged in. None of them send commands to
the camera, write to it, mount/unmount it, or change any setting.

You can run them manually, or use the helper script
[`tools/collect-usb-info.sh`](tools/collect-usb-info.sh), which runs the
same commands and saves the output into `evidence/usb/`.

---

## 1. Before you plug in

1. Copy any media you care about off the camera's SD card first.
2. If you want the SD card left completely untouched, see
   [backup policy §4](04-preservation-and-backup-policy.md#4-sd-card-handling).
3. Take a **baseline** snapshot with the camera **unplugged**, so the
   camera's entries are easy to spot by comparison:

   ```bash
   ./research/tools/collect-usb-info.sh baseline-unplugged
   ```

## 2. Plug in and note the camera's behaviour

Many budget cameras show a menu on their screen when connected, offering
modes such as *Mass Storage / USB Disk*, *PC Camera / Webcam*, or
*Charging*. Write down exactly what appears. Each mode usually enumerates
as a **different USB device** (often a different Product ID), so capture
each one separately:

```bash
./research/tools/collect-usb-info.sh mode-mass-storage
./research/tools/collect-usb-info.sh mode-pc-camera
```

Unplug (after ejecting — see §6) between modes.

If macOS pops up **"The disk you inserted was not readable by this
computer"**, click **Ignore**. Never click *Initialize*.

## 3. The GUI way: System Information

1. Hold **Option (⌥)** and click the Apple menu → **System Information…**
2. Sidebar → **Hardware → USB**.
3. Select the camera entry and screenshot the panel.

You will see: Product ID, Vendor ID, Version, Speed, Manufacturer, Serial
Number, and (for storage) the media details.

## 4. The terminal way

### 4.1 USB device tree — `system_profiler`

```bash
# macOS 14 and earlier
system_profiler SPUSBDataType

# Newer macOS releases use a renamed data type; try this if the above is empty
system_profiler SPUSBHostDataType
```

Look for an entry that appears only when the camera is plugged in, and
record:

| Field | Example format | Meaning |
|-------|----------------|---------|
| Product ID | `0x1234` | PID — identifies the product within a vendor |
| Vendor ID | `0xabcd` | VID — identifies the USB vendor |
| Version | `1.00` | BCD device release number |
| Speed | `Up to 480 Mb/s` | USB 2.0 High-Speed, etc. |
| Manufacturer | text | Vendor string set by firmware |
| Serial Number | text | May be blank, generic, or unique |

### 4.2 Raw USB registry — `ioreg`

`ioreg` shows the same devices with more raw detail, including the
**interface class** values that tell you what kind of device the camera is
pretending to be.

```bash
# Full USB plane, no line wrapping
ioreg -p IOUSB -l -w 0

# Alternative on newer systems: list USB host devices with all properties
ioreg -r -c IOUSBHostDevice -l -w 0
```

Useful keys to search for in the output: `idVendor`, `idProduct`,
`bcdDevice`, `USB Vendor Name`, `USB Product Name`, `USB Serial Number`,
`bDeviceClass`, `bInterfaceClass`, `bInterfaceSubClass`.

Interface class values (decimal as shown by `ioreg`):

| `bInterfaceClass` | Meaning |
|-------------------|---------|
| 8 | Mass Storage (camera appears as a disk) |
| 14 | Video (UVC — camera appears as a webcam) |
| 6 | Still Image (PTP — appears in Image Capture / Photos) |
| 1 | Audio (often paired with UVC for the microphone) |
| 255 | Vendor-specific (proprietary protocol) |

> Note: `ioreg` prints `idVendor` / `idProduct` in **decimal**.
> Convert to hex for lookups: `printf '0x%04x\n' 1234`

### 4.3 Storage details — `diskutil` (read-only subcommands only)

When the camera is in mass-storage mode:

```bash
diskutil list external        # find the camera's disk identifier, e.g. disk4
diskutil info disk4           # replace disk4 with the identifier you found
```

Record: *Device / Media Name* (often contains a vendor string from the
camera's storage firmware), size, partition scheme, file system.

> ⚠️ Only use `diskutil list` and `diskutil info`. Do **not** use
> `diskutil eraseDisk`, `partitionDisk`, `repairDisk`, `repairVolume`,
> `mountDisk` options, or Disk Utility's *First Aid* / *Erase* /
> *Partition* buttons on the camera or its card.

### 4.4 Webcam mode — camera list

```bash
system_profiler SPCameraDataType
```

If the camera supports a "PC Camera" mode it should appear here with its
model name and unique ID. You can also confirm it in QuickTime Player →
*File → New Movie Recording* → camera dropdown (viewing only).

### 4.5 PTP mode — Image Capture

If the camera shows up in the **Image Capture** app but not as a disk, it
is using PTP. Viewing the device there is read-only; do not use the
*Delete* or *Import & delete* options.

### 4.6 Live connection log (optional)

To see what macOS logs as the camera connects (useful for devices that
connect briefly then vanish):

```bash
log stream --info --predicate 'eventMessage CONTAINS[c] "USB"'
```

Start it, plug the camera in, wait a few seconds, then press **Ctrl-C**.
This only reads the system log.

## 5. Looking up what you found

- **Vendor ID / Product ID:** search the Linux USB ID database
  (<http://www.linux-usb.org/usb.ids>) or <https://devicehunt.com/>.
  Search the VID:PID pair (e.g. `abcd:1234`) on the web as well — other
  owners and driver lists often mention the chip.
- Treat the result as a **hint**: some factories keep the SoC vendor's
  default IDs (very informative), others use a USB-bridge chip's IDs or
  their own (less informative). Record what the database says and mark it
  *suspected* until corroborated.

## 6. Disconnecting safely

1. In Finder, click the **eject** icon next to the camera's volume (or run
   `diskutil eject diskN` — ejecting only unmounts; it does not modify the
   device's contents).
2. Wait for the volume to disappear, then unplug.

## 7. Comparing snapshots

The helper script saves each snapshot in its own folder. To see exactly
what the camera added:

```bash
cd research/evidence/usb
diff <baseline-folder>/system_profiler_usb.txt <mode-folder>/system_profiler_usb.txt
```

## 8. Commands deliberately **not** in this guide

Anything that writes to, reformats, partitions, repairs, re-images, or
sends vendor commands to the device — including raw `dd` writes, flashing
tools, and vendor update utilities. These are out of scope for Phase 1 by
project rule.
