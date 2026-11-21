# Dell XPS 14 DA14260 — Hardware Notes

## Hardware

- **Camera sensor:** OmniVision OV08F4 (`OVTI08F4:00`)
- **ISP:** Intel IPU7 (`PCI 0000:00:05.0`, device `0xb05d`)
- **Firmware:** `intel/ipu/ipu7ptl_fw.bin`

## Kernel Drivers

| Module | Status |
|---|---|
| `intel_ipu7` | Loaded (staging) |
| `intel_ipu7_isys` | Loaded (staging) |

Both are staging modules. At boot the kernel logs:

```
intel-ipu7 0000:00:05.0: Found supported sensor OVTI08F4:00
intel-ipu7 0000:00:05.0: Connected 1 cameras
intel-ipu7 0000:00:05.0: CSE authenticate_run done
```

So the kernel side works: IPU7 initialises, authenticates with CSE, and detects the sensor.

## USB Bridge

- **Synaptics SVP7500** (`06CB:0701`) — USB MIPI bridge between the sensor and the IPU7
- Present on bus: `Bus 003 Device 002: ID 06cb:0701 Synaptics, Inc SVP7500`
- Module `ipu_bridge` is loaded (used by `intel_ipu7` and `intel_ipu7_isys`)
- Modules `intel_skl_int3472_discrete` / `intel_skl_int3472_tps68470` are loaded

## Problem (original diagnosis — now RESOLVED on DA14260)

Before the fix, `libcamera` (v0.7.0 in nixpkgs) reported:

```
SimplePipeline simple.cpp: No sensor found for /dev/media0
```

The root cause was a **missing `intel-cvs` driver** — the SVP7500 bridge requires the `intel_cvs` kernel module (from `intel/vision-drivers`) to perform "transfer of ownership" so the IPU7 can talk to the sensor. Without it, the sensor (`ov08x40`) never binds to ISYS and libcamera finds nothing.

> Note: nixpkgs libcamera 0.7.0 has **no dedicated IPU7 pipeline handler**, but this turned out not to matter — the **`simple` pipeline handler + software ISP (`IPASoft`)** drives the IPU7 ISYS raw stream just fine. See "Resolution" below.

## Reference: community fix pack

[`jibsta210/svp7500-camera-fix-pack`](https://github.com/jibsta210/svp7500-camera-fix-pack) targets exactly this hardware stack. It was developed on Dell XPS **16** DA**16**260 (Panther Lake, same as our **14** DA**14**260) and confirmed working. It ships 5 DKMS modules + a udev rule:

| Component | What it fixes |
|---|---|
| `intel-cvs` DKMS | IRQ bug in SVP7500 bridge init; adds MIPI config payloads |
| `int3472-patched` DKMS | GPIO type `0x02` (IR LED) + ACPI namespace fallback for `_DEP` |
| `ipu-bridge-patched` DKMS | Adds IR sensor (`HIMX1092`) to `supported_sensors[]` |
| `hm1092` DKMS | v4l2 driver for Himax HM1092 IR sensor |
| `ov05c10` DKMS | RGB sensor driver for OV05C10 variant boards |
| udev rule | Disables USB autosuspend on `06CB:0701` to prevent bridge wedge |

Our sensor `OVTI08F4` is the OmniVision OV08F4, same family as their OV08x40 — likely covered by the same driver path.

## Devices

- `/dev/video0`–`/dev/video31` — all owned by the `ipu7` PCI device
- `/dev/media0` — media controller

## Key findings from community debugging (gist `jibsta210/8316b6a0bc58910891512945c4e91a08`)

Months of reverse-engineering on identical hardware (XPS 16 DA16260, same silicon):

### `intel-cvs` IRQ bug — root cause of bridge wedging

The upstream `intel_cvs` driver in `intel/vision-drivers` calls `devm_request_irq()` (hardirq-only) but passes `IRQF_ONESHOT`, which is only valid for threaded handlers. The kernel warns and IRQ delivery becomes unreliable, causing the SVP7500 bridge to wedge after idle (observed from 3 to 52 minutes). Fix is a one-liner:

```diff
- ret = devm_request_irq(icvs->dev, icvs->irq, cvs_irq_handler,
-                        IRQF_ONESHOT | IRQF_NO_SUSPEND, ...);
+ ret = devm_request_irq(icvs->dev, icvs->irq, cvs_irq_handler,
+                        IRQF_NO_SUSPEND, ...);
```

This fix is what the `intel-cvs` DKMS module in the fix pack ships.

### SVP7500 bridge protocol — only two commands

The bridge only needs two opcodes:
- `0x0830` — `HOST_SET_MIPI_CONFIG` (256-byte payload with MIPI lane config)
- `0x0800` — `GET_DEVICE_STATE` (2 bytes — polls bridge state)

Bridge state `0x06` = idle/configured, `0x07` = MIPI tunnel armed. RGB camera works at `0x06`.

### Camera path

```
OVTI08F4 (OV08F4, I2C 0x36) → SVP7500 CVS (USB 06CB:0701, I2C 0x76) → IPU7 CSI-2 port 0 → /dev/media0
```

IR camera (HM1092, I2C 0x24) → same bridge → IPU7 CSI-2 port 2 — **still not working upstream**, requires additional Windows-only MIPI payload.

### What works after fix pack install (confirmed on DA16260)

- RGB front-facing camera streams at 28.57 fps via libcamera
- IR camera probes correctly but MIPI forwarding from bridge is still blocked (separate unsolved problem)

## RGB camera confirmed working on Linux (intel/vision-drivers#37)

`@tverhaeghe` independently verified on **Fedora 44 Silverblue** (kernel 7.0.4, DA16260, Secure Boot enabled):

1. Compiled `intel_cvs.ko` from `intel/vision-drivers` against kernel headers
2. Enrolled a MOK key and signed the module for Secure Boot
3. Loaded the module: `sudo modprobe intel_cvs`
4. Result:

```
LIBCAMERA_IPA_MODULE_PATH=/usr/lib64/libcamera/ipa cam -l
Available cameras:
1: Internal front camera (_SB_.LNK1)

cam -c 1 --capture=10
10 frames captured at 28.57 fps, 3856x2176 — stable, full sensor resolution
```

So **the only missing piece for RGB is the `intel_cvs` kernel module**. libcamera 0.7.1 on Fedora 44 already has IPU7 pipeline support built in.

**V4L2 app compatibility** (Teams, browsers) needs `v4l2loopback` on top — `cam` streaming works but apps expect a standard V4L2 device node, not the raw libcamera pipeline.

## Resolution — RGB camera working on DA14260 (2026-06-15)

Packaged `intel_cvs` as a NixOS out-of-tree kernel module (`intel-cvs/default.nix`) with the
`IRQF_ONESHOT` fix applied via `substituteInPlace`. After `nixos-rebuild switch` + reboot:

**Driver side — works.** dmesg shows the bridge initialising cleanly (no IRQ warning):

```
intel_cvs: loading out-of-tree module taints kernel.
Intel CVS driver i2c-INTC10E1:00: cvs_common_probe: probed as i2c device
Intel CVS driver i2c-INTC10E1:00: cvs_get_device_cap:Device protocol is 2.2
Intel CVS driver i2c-INTC10E1:00: cvs_get_device_cap:Device capability is 0xd200
Intel CVS driver i2c-INTC10E1:00: cvs_common_probe:Transfer of ownership success
intel_ipu7_isys.isys: bind ov08x40 14-0036 nlanes is 2 port is 0
intel_ipu7_isys.isys: All sensor registration completed.
```

**libcamera — works.** `cam --camera=1 --capture=5` captures frames:

```
Using camera \_SB_.LNK1 as cam0
cam0: Capture 5 frames
922.585 (0.00 fps)  cam0-stream0 seq: 000000 bytesused: 33492992
922.620 (28.57 fps) cam0-stream0 seq: 000001 bytesused: 33492992
...
```

28.57 fps at 3848×2176 — identical to the Fedora result. The `Unable to get rectangle ...
Inappropriate ioctl` / `IPASoft: Failed to create camera sensor helper for ov08x40` lines are
**non-fatal warnings** (the ov08x40 staging driver lacks crop/selection ioctls and libcamera has no calibration profile for it) — streaming works regardless.

### V4L2 app compatibility — solved via v4l2-relayd

`cam` works, but **apps that only speak V4L2 (cheese, Firefox, Chrome, Teams) see nothing** — the raw IPU7 ISYS `/dev/video*` nodes don't emit usable frames (the soft ISP debayering only happens inside libcamera). Symptom: opening cheese flashes the camera LED for ~1s then it goes dark.

Fix in `default.nix`: a hand-rolled **`systemd.services.ipu7-camera-relay`** running **v4l2-relayd** — a GStreamer `libcamerasrc` pipeline feeding a `v4l2loopback` device labelled "Intel IPU7 Camera" (`/dev/video32`), which any V4L2 app can open. (The stock `services.v4l2-relayd` module is *not* used — see gotchas 4–5: it can't set the loopback buffer count or add a `queue`/`sync=false` to the output, both required for full framerate.)

**Gotchas hit during setup:**

1. **`v4l2loopback` must be loaded before the relay starts.** The first `nixos-rebuild switch` failed (`unable to open control device '/dev/v4l2loopback'`) because `boot.kernelModules` only loads the module at boot — a **reboot** (not just switch) is needed the first time.

2. **Bare caps in `input.pipeline` break v4l2-relayd → permanent black image** *(this was the root cause of the "recognised but black" symptom — now resolved)*. The relay parses `input.pipeline` with the single-string `gst_parse_launch` (not the argv form `gst-launch` uses), which **mis-tokenizes a bare caps filter**: `... ! video/x-raw,format=YUY2,...` is read as an element named `video` plus a URI `/x-raw,...`:

   ```
   ERROR GST_PIPELINE grammar.y: no element "video"
   ERROR GST_PIPELINE grammar.y: no source element for URI "/x-raw,format=YUY2,..."
   ERROR V4L2_RELAYD backend_pipeline_create: no element "video"
   ```

   `backend_pipeline_create()` returns NULL → `input_pipeline_get()` is NULL → `input_pipeline_enable()` calls `gst_element_set_state(NULL, PLAYING)` → `GStreamer-CRITICAL: assertion 'GST_IS_ELEMENT (element)' failed`. The live pipeline never plays; consumers only ever get v4l2-relayd's built-in **black splash** (a `pngdec` placeholder).

   **Fix:** drop the trailing caps filter. v4l2-relayd already applies `format`/`width`/`height` to its internal `appsink` (caps copied from the output `appsrc`), which drives negotiation:

   ```
   pipeline = "libcamerasrc ! videoconvert ! videoscale";
   ```

   Verified: a `v4l2src`/`v4l2-ctl` consumer then reads live 1280×720 frames at ~80 mean luma (real image) instead of one black splash frame.

3. **`ffmpeg`/`ffplay` cannot read this v4l2loopback — test with real apps.** `ffmpeg -f v4l2` and `ffplay` read **0 frames** even from a known-good `videotestsrc ! v4l2sink` producer (v4l2loopback lacks `VIDIOC_CREATE_BUFS`, which libav's v4l2 demuxer mishandles). `v4l2-ctl --stream-mmap` and GStreamer `v4l2src` read fine. So **cheese, Firefox/Chrome and conferencing apps work; `ffplay` is not a valid test** for this device.

4. **~2–3 fps until the loopback has more buffers AND the output has a `queue`** *(root cause of the "low fps" symptom — resolved)*. The input side sustains ~20–23 fps (`libcamerasrc ! videoconvert ! videoscale` benchmarks at 20 fps, same as raw soft-ISP). The bottleneck was the **output → v4l2loopback** side. Measured end-to-end (timing 90–120 frames via `v4l2-ctl --stream-mmap`):

   | output config | loopback buffers | fps |
   |---|---|---|
   | `appsrc ! videoconvert ! v4l2sink` (stock) | 2 (default) | **3** |
   | `appsrc ! queue ! videoconvert ! v4l2sink` | 2 | 3 |
   | `appsrc ! videoconvert ! v4l2sink` (no queue) | 16 | 4 |
   | `appsrc ! queue ! videoconvert ! v4l2sink sync=false` | **8** | **22** |
   | same | 16 | 23 |

   Both fixes are needed: a GStreamer **`queue`** *and* **≥4 device buffers**. Symptoms when missing: `gstv4l2allocator: buffer N was not queued, this indicate a driver bug` and `basesink: Pipeline construction is invalid, please add queues`. Buffers are set per-device with `v4l2loopback-ctl add -b 4` (no module-param/reboot needed). The stock `services.v4l2-relayd` module only adds a `queue` when input/output formats differ and always creates the device with the default 2 buffers — hence the hand-rolled service.

   > **Lag follow-up.** `-b 8`/`-b 16` sustain full fps but add visible **latency**: deep buffers let the producer build a backlog so the viewer reads stale frames. Dropping to **`-b 4`** plus a **`queue leaky=downstream max-size-buffers=3`** (drops old frames instead of queueing them) keeps full fps while the viewer always gets the latest frame — no more lag.

5. **Sensor is mounted upside-down** — corrected in-pipeline with `videoflip`, placed *after*
   `videoscale` so it flips the small 1280×720 frame (flipping the full 3840×2160 frame drops fps
   from 23 → 13). `method=rotate-180` gives an upright, non-mirrored image; we use
   `method=vertical-flip` to get the upright **mirror/selfie** view (a horizontal mirror on top of
   rotate-180 reduces to a single vertical flip).

6. **Soft-ISP image is flat/washed-out** *(obsolete — superseded by the hardware ISP, see below)*
   — the `IPASoft` software ISP has no `ov08x40` tuning file, so colour came out desaturated. A
   `videobalance saturation=1.8` in the input pipeline was a crude global boost, not real colour
   calibration — white balance was still inaccurate and colours often looked outright weird. This
   hack is now removed: the hardware ISP's AIQ tuning does real colour correction.

## Hardware ISP — colour + stability fixed (2026-08-22)

The soft-ISP path above worked but was unstable (CPU-bound debayering) and produced weird colours
(no sensor tuning). Both are fixed by switching the relay input from `libcamerasrc` (software ISP)
to **`icamerasrc`** — Intel's GStreamer element on top of the **Intel camera HAL**, which drives
the IPU7's **hardware ISP (PSys)** with per-sensor AIQ tuning (real AWB/AE/colour matrices).

This is the stack from [nixpkgs PR #542085](https://github.com/NixOS/nixpkgs/pull/542085)
(`hardware.ipu7`), tested working on this exact laptop by @aoli-al (nixos-hardware PR #1912
comments). Since that PR is not merged yet, the four pieces are **vendored** into this profile
(same pattern as `intel-cvs/`) and should be dropped in favour of
`hardware.ipu7 = { enable = true; platform = "ipu75xa"; }` once it lands:

| Vendored package | Role |
|---|---|
| `ipu7-drivers/` | `intel-ipu7-psys` kernel module — the hardware ISP device (`/dev/ipu7-psys0`); kernels ≥ 6.17 only ship the core + ISys in staging, no PSys |
| `ipu7-camera-bins/` | IPU firmware + proprietary AIQ tuning blobs (**unfree**, Intel license) |
| `ipu7-camera-hal/` | Intel camera HAL built for `ipu75xa` (Panther Lake) |
| `icamerasrc/` | GStreamer source element wrapping the HAL |

Profile changes on top of the vendoring:

- `hardware.firmware` gains `ipu7-camera-bins` + `ivsc-firmware`
- udev rule `SUBSYSTEM=="intel-ipu7-psys", MODE="0660", GROUP="video"` so the HAL can open PSys
- relay input pipeline is now `icamerasrc ! videoconvert ! videoscale ! videoflip
  method=vertical-flip` — the `videobalance saturation=1.8` hack is gone (AIQ does real colour)
- `GST_PLUGIN_PATH` swaps `libcamera` for the vendored `icamerasrc`

**Unfree note:** `ipu7-camera-bins` and `ivsc-firmware` require allowing unfree, e.g.:

```nix
nixpkgs.config.allowUnfreePredicate =
  pkg:
  builtins.elem (lib.getName pkg) [
    "ipu7-camera-bins"
    "ivsc-firmware"
  ];
```

(`ivsc-firmware` is kept for parity with the tested `hardware.ipu7` config; this machine's sensor
sits behind a Synaptics SVP7500 rather than Intel IVSC, so it may prove droppable.)

The stock `services.v4l2-relayd` instance that `hardware.ipu7` would create is not used here for
the same buffer-count/queue reasons as before (gotcha 4) — the hand-rolled relay stays.

## Kernel ≥ 7.2: in-tree intel_cvs replaces the vendored one (2026-08-22)

First boot of the hardware-ISP stack on kernel **7.2.0** produced *no camera at all*: the HAL
logged `CameraParserInvoker: parseSensors: No sensors available`, there were no `v4l-subdev`
nodes, and dmesg was missing the `bind ov08x40 ... port is 0` / `All sensor registration
completed.` lines that appear on 7.1.4.

**Root cause (kernel change, not a stack problem):** kernel 7.2 added `INTC10E1` (PTL — exactly
this machine's CVS ACPI device) to `ipu-bridge`'s IVSC/CVS companion list and gained a **new
in-tree `intel_cvs` driver** (`drivers/media/i2c/cvs/`, `CONFIG_VIDEO_INTEL_CVS`) that registers
a V4L2 subdev to arbitrate CSI-2 link ownership. On 7.2 the sensor's fwnode graph is routed
*through* that CVS subdev, and the ISYS async notifier waits for it. The vendored out-of-tree
`intel_cvs` from `intel/vision-drivers` registers **no** V4L2 subdev, and because it has the same
module name and lives in depmod's higher-priority `updates/` directory, it shadowed the in-tree
driver — the notifier waited forever and the sensor never bound.

**Fix:** the profile now includes the vendored `intel-cvs/` module only when
`config.boot.kernelPackages.kernel.version < 7.2`; on newer kernels the in-tree driver binds
instead and completes the media graph. (The HAL copes with the extra hop: its
`MediaControl::checkHasSource` walks intermediate entities recursively, the same mechanism used
for IVSC setups.)

## Kernel ≥ 7.2, part 2: HAL must be CVS-aware (2026-08-22)

With the in-tree `intel_cvs` binding, the sensor registered (`bind ov08x40`, subdev nodes
present) but streaming still failed. The 7.2 media graph is:

```
ov08x40 17-0036  →  Intel CVS (MEDIA_ENT_F_VID_IF_BRIDGE)  →  Intel IPU7 CSI2 0
```

The release HAL (`20260629_1`) assumes the entity feeding the CSI-2 receiver *is* the sensor. It
computed the I2C bus by chopping the sensor-name prefix off `"Intel CVS"` → bus `"S"`
(`resolveCsiPortAndI2CBus: I2CBus:S`), failed the `ov08x40 S ==> Intel IPU7 CSI2 0` link setup,
and `VIDIOC_STREAMON` died with EPIPE (link validation).

Upstream fixed this in `intel/ipu7-camera-hal` PR #59 ("Enable ov08x40 CVS media path", merged
2026-08-12): `MediaControl` now recurses through the `Intel CVS` entity for the I2C bus and
reroutes configured links through it. But the PR only converted the **ipu8** sensor config to the
CVS topology. So the profile now:

- builds `ipu7-camera-hal/` from master (`11d8aff0`, 2026-08-12) instead of the release tag
- carries `ipu7-camera-hal/ipu75xa-ov08x40-cvs.patch`, which applies the same change as the
  ipu8 config to `config/linux/ipu75xa/sensors/ov08x40-uf.json`: `Intel CVS` pad formats
  (pads 0/1, same Bayer format) and the split `sensor → Intel CVS → CSI2` links. The
  sensor→CVS link is created `ENABLED|IMMUTABLE` by the kernel, so enabling it again is a no-op.

This patch is upstreamable to intel/ipu7-camera-hal (the ipu75xa configs will need it for any
Panther Lake laptop on kernel ≥ 7.2).

## IR camera (HM1092 / Windows Hello) — blocked at hardware level

*(obsolete — the firmware-block theory was retracted by its own author on
2026-07-25 and the IR camera now works; see "IR camera working" below. Kept for
the history of how it was misdiagnosed.)*

After months of reverse-engineering (intel/vision-drivers#37, last update 2026-05-29):

- Every host-controllable variable is confirmed correct: sensor streams (`MODE_SELECT=0x01`), IPU7 ISYS accepts stream open, IR LED on, bridge ACKs `0x0830`
- The SVP7500 port-2 MIPI transmitter never fires — **zero activity on CSI-2 port 2**
- The bridge firmware (`06CB0701.bin`) is **fully encrypted** — cannot be inspected or patched
- The port-2 enable likely requires CSE/CSME authorization only the Windows biometric stack can obtain
- **Not solvable from the Linux side** without Intel/Synaptics cooperation

The `int3472-discrete INT3472:00: GPIO type 0x02 unknown` warning at boot relates to the IR LED
GPIO for this sensor — irrelevant to the RGB camera.

## IR camera working — it was a LINK_FREQ unit bug (2026-08-24)

The section above is wrong. There is no firmware block: the sensor driver was
publishing `V4L2_CID_LINK_FREQ = 360960000`, which is the per-lane MIPI **bit
rate**, where V4L2 wants the **DDR clock** — half of it, `180480000`. ISys
programmed the D-PHY at twice the sensor's real rate, so the clock lane came up
and no packet ever framed: zero SOF, indistinguishable from a dead transmitter.
Retracted by its author on 2026-07-25, intel/vision-drivers#37.

Enable with `hardware.dell-xps-14-da14260.irCamera.enable = true;`. Pieces:

| Piece | Why |
|---|---|
| `hm1092/` module | Sensor driver with the corrected `LINK_FREQ`. No in-tree counterpart — `drivers/media/i2c/hm1092.c` does not exist in mainline, so this stays vendored |
| `hm1092/intel-cvs-ir/` module | The fix pack's fork of `intel_cvs`, **replacing** the profile's plain `intel-cvs` (same `intel_cvs.ko`; the base profile drops its entry when this option is on). It exports `cvs_send_mipi_ir_config`, which hm1092 calls through a weak reference at stream start to get CSI-2 port-2 forwarding configured — the plain `intel/vision-drivers` build exports no symbols, so the weak reference resolves NULL and every IR frame stays dark. Pinned at a rev whose exact build was boot-tested on a DA14260; its bring-up diagnostics compile out by default (`make DEBUG_CVS=1` restores them) |
| `himx1092-ipu-bridge.patch` | Adds the sensor's ACPI HID to `ipu_supported_sensors[]`. The i2c client enumerates without it, but with no software node the ISYS async notifier has nothing to match, so the sensor never joins the media graph. Backported verbatim from mainline `4fdb0342f05e` |
| IR-LED udev rule + `/dev/ir-camera` symlink | Grants group `video` write on the illuminator's `brightness`, and pins a stable path to the capture node (the `/dev/videoN` number is not stable across boots) |
| `ir-camera-pipeline.service` | A boot-time oneshot that sets the CSI-2 port-2 pad formats to `SGRBG10_1X10/648x368` and pre-sets the capture node, so a bare `v4l2-ctl --stream` / `ffmpeg -f v4l2` on `/dev/ir-camera` works without manual `media-ctl`. Howdy's recorder does this itself; the unit is for other consumers and for diagnosis |
| `howdy-ir/` + `irCamera.howdy.enable` | Opt-in on top of `irCamera.enable`: builds `services.howdy` with a raw-V4L2 `recording_plugin = "ir"` recorder (from the fix pack) that reads the node as greyscale and drives the illuminator. Stock Howdy's recorders either can't decode the raw Bayer-tagged mono frames or would debayer them, and none light the emitter. Gated on the `services.howdy` module existing (added to nixpkgs in early 2026) |

**Off by default** because the ipu-bridge entry landed in mainline only after 7.2,
so below that it has to be patched in — which means building the kernel locally
instead of substituting it. Nobody who does not want IR should pay that.

**Refused on kernel >= 7.2**, and the bound is structural, not just caution: the
IR path needs the out-of-tree `intel_cvs` fork above, and from 7.2 the in-tree
`drivers/media/i2c/cvs` owns the device instead — an out-of-tree `intel_cvs`
would shadow it (same module name, depmod `updates/` priority) and take the
working RGB path down with it. Whether IR works on the in-tree driver is
untested rather than known-broken — it looks like it sends the same bridge
configuration itself, so IR may need nothing but a port of this option. The one
thing that might genuinely block it is `ipu_bridge_instantiate_ivsc()`
overwriting `set_secondary_fwnode()` on the `csi_dev` both sensors share. If
you test it, watch for the **RGB** camera regressing.

**Two traps worth knowing.** The illuminator is a LED class device, because
INT3472 claims the GPIO and registers it itself — the sensor driver gets NULL from
its `ir-led` lookup and logs `ir_led=none`, so the consumer has to drive
`brightness`. Without the udev grant an unprivileged consumer gets uniformly dark
frames, which looks exactly like broken hardware. And a bare `v4l2-ctl
--stream-mmap` on the IR node fails on a fresh boot (`ENOLINK`, or `EPIPE` once
the link is up but pad formats still disagree): the graph starts with the CSI2 ->
ISYS Capture link disabled and the pads at their 4096x3072 default, so the pads
have to be set and the link enabled with `media-ctl` first. `ir-camera-pipeline.service`
does that at boot; Howdy's `ir` recorder also does it itself (and bypasses
libcamera, which would debayer this physically-mono sensor).

## Microphone — needs kernel ≥ 7.0

The internal microphone does **not** work on older kernels (no capture device enumerated). It
starts working on **kernel 7.0+**, so the profile sets `linuxPackages_latest` as a default when the
configured kernel is older:

```nix
# We need at least 7.0 to have a working mic
boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "7.0") (
  lib.mkDefault pkgs.linuxPackages_latest
);
```

`lib.mkDefault` keeps this overridable — a user who already runs a ≥ 7.0 kernel (or wants to pin a
different one) is unaffected.

## Speakers — untuned by default, opt-in voicing (2026-08-28)

The speakers work out of the box, but they sound flat: laptop speakers ship voiced by the
vendor's Windows DSP layer, and Linux does not get that layer. The Cirrus smart-amplifier
firmware *is* loaded by the stock Linux path — what is missing is the perceptual voicing on top
of it (the Waves layer on Windows).

`hardware.dell-xps-14-da14260.speakerTuning.enable = true;` restores it as a **PipeWire
filter-chain** in front of the internal speaker sink: 13 biquads (2 high-pass, 10 peaking, 1
high-shelf) into an LSP-Plugins lookahead limiter.

The chain is ported from [basecamp/omarchy `aa9f0c54`][omarchy], where it was fitted to the
measured response of the [xps-audio-linux][xps-audio] `xps-clone` EasyEffects profile (MIT) under
a dense pink-weighted multitone of 104 bin-aligned tones. It measures **1.24 dB RMS** against
that reference and matches its dynamic range within 0.1 LU. Nothing from upstream is
redistributed — the reference's convolution impulse response is not carried, so this has **no
binary blob** and is sample-rate agnostic. Bass Q is capped at 1.8 below 200 Hz on purpose: a
closer magnitude fit swung group delay 31 ms across 63–80 Hz, which smears bass transients; the
cap costs 0.33 dB and halves the swing.

[omarchy]: https://github.com/basecamp/omarchy/commit/aa9f0c54c5c3bd8141f1d30ecf52e6b377a45fe5
[xps-audio]: https://github.com/spencerbull/xps-audio-linux

### How it is hosted

Via pipewire's own **`filter-chain.service`** — a separate PipeWire *client*
(`pipewire -c filter-chain.conf`), fed by a `services.pipewire.configPackages` entry that drops
the graph into `share/pipewire/filter-chain.conf.d/`. Not a drop-in for the audio daemon's own
config, for two reasons upstream hit: the daemon only reads its config at startup (so the graph
could only be changed by restarting PipeWire, which drops every PulseAudio client's connection —
Spotify and friends then need restarting by hand), and a malformed graph in the daemon's config
stops PipeWire from starting at all, where here it breaks only this one unit.

nixpkgs' pipewire module knows about that unit but only hands it `LV2_PATH`; it does not order or
enable it. The profile adds `wantedBy = [ "default.target" ]` and orders it after
`wireplumber.service` (WirePlumber does the linking).

The limiter is an **LV2 plugin**, and without it the whole graph fails to instantiate and the
tuning sink silently never appears. So `pkgs.lsp-plugins` is declared as
`passthru.requiredLv2Packages` on the config package, which is the supported way to get it into
the `LV2_PATH` that nixpkgs builds for `filter-chain.service` — no `extraLv2Packages` needed in
user config.

### What it looks like in the mixer

A **second** output device appears, "Laptop Speakers" (`xps14_speaker_tuning`), in front of the
raw `…HiFi__Speaker__sink`. Priorities on this board:

| Sink | `priority.session` |
|---|---|
| Headphones | 1000 |
| **Laptop Speakers (tuned)** | **800** (`sessionPriority`) |
| Speaker (raw) | 712 |
| HDMI1/2/3 | 664 / 648 / 632 |

So the tuned sink outranks the untuned speakers it fronts and becomes the default output, while
plugging headphones in still wins. The raw sink stays selectable — picking it just bypasses the
tuning. (Upstream hides it, but only from its own shell scripts and QML panel; there is no
PipeWire-level way to hide a sink that the filter-chain's own output still has to target.)

**The two volumes compound.** Set the raw `Speaker` sink to 100% once, then drive volume from the
tuned sink. The chain is linear and the limiter's level-dependent stages (`alr`, `boost`) are
switched off, so lowering the volume does not change the voicing — it just stops the limiter
engaging, which is the intended behaviour.

Three properties on the output stream keep the graph honest, and each fixes a real failure:

- `node.dont-move` — the filter's output is a movable sink input like any other, so anything that
  reroutes "all streams" to a newly selected output drags the processing with it, onto headphones
  or into the tuning's own sink (a cycle).
- `node.dont-fallback` + `node.linger` — the host can start before the speaker device is
  discovered. Without these WirePlumber links the output to whatever default exists (quietly
  tuning the wrong device while the tuning sink still looks healthy) or destroys the node rather
  than waiting. Both keys are needed; see WirePlumber's `scripts/linking/find-defined-target.lua`.

### Why not a WirePlumber smart filter

`node.software-dsp` / `create-filter` with `hide-parent` — what
`framework/13-inch/common/classic-audio.nix` uses in this repo — is the better shape: it leaves
the real device as the default output, so no second sink appears and no volumes compound.
Upstream tried it and reports that on **PipeWire 1.6.8 / WirePlumber 0.5.15** (exactly the
versions here) the graph loads and links correctly, controls are present, `mpv → filter → sink`
links are made — and audio passes through **unprocessed**: the filter's input monitor and the
speaker sink's monitor measure identically. Not reproduced independently here. Worth revisiting,
since it would remove both caveats above.

**Off by default**, per the repo's rule that profiles do not configure sound unless the hardware
needs it to work at all. The speakers work untuned; this is a taste layer.

## Resolution/fps benchmark — 4K is free (2026-08-22)

With the hardware ISP working, `icamerasrc ! caps ! fpsdisplaysink video-sink=fakesink` was
benchmarked per mode (12 s each, root, relay stopped):

| Mode | Delivered fps | Drops |
|---|---|---|
| 1280×720 NV12 | 28.56 avg | 0 |
| 1920×1080 NV12 | 28.57 avg | 0 |
| 3840×2160 NV12 | 28.57 avg | 0 |
| 1920×1080 NV12 @ 60/1 caps | 28.57 avg (caps ignored) | 0 |
| 3840×2160 NV12 + `videoflip` | 28.57 avg | 0 |

The sensor has a single native mode (3856×2176 @ 28.57 fps — matches Intel's "8MP/4K" spec) and
the ISP scales in hardware, so every output size costs the same and >30 fps is impossible. The
loopback therefore now advertises **3840×2160 NV12 @ 30/1** (real cadence ~28.6 fps). NV12 is
icamerasrc's native output, making both `videoconvert` stages passthrough. Lower the
width/height in the relay `output` caps if some consumer app struggles with 4K input.

## Status

RGB camera **working** end-to-end through the **hardware ISP**: 3840×2160 (4K) at ~28.6 fps,
upright/mirrored, low-latency, properly colour-corrected (AIQ tuning), usable by any V4L2 app
(cheese / Firefox / Chrome / conferencing). Requires allowing the unfree `ipu7-camera-bins`
blobs (see above).

Microphone **working** on kernel ≥ 7.0 (enforced as a `mkDefault` in the profile — see above).

Speakers **working untuned** out of the box; vendor-style voicing is **opt-in** via
`hardware.dell-xps-14-da14260.speakerTuning.enable = true;` (a PipeWire filter-chain, no blob).
Mechanically confirmed on a DA14260: the sink appears, wins the default-output election at
`priority.session = 800`, and passes audio — which also confirms the LV2 limiter loaded, since a
missing plugin fails the whole graph rather than degrading it. Measured level matches the
predicted −9.3 dB (see below), so the graph is demonstrably in the path rather than bypassed.

**Whether it sounds *better* is not established.** It has one listener's "works", not a
preference. The magnitude fit is upstream's measurement against its own reference, not a
judgement that the reference suits these drivers, and nothing here has been A/B'd blind. Treat
the voicing as unvalidated taste and the plumbing as tested.

IR camera **opt-in** on kernel < 7.2, via
`hardware.dell-xps-14-da14260.irCamera.enable = true;` — that pulls in an
ipu-bridge patch and so rebuilds the kernel, which is why it is not on by default.
Enabling it on 7.2 or later is refused by an assertion; see above for what is and
is not known there. `irCamera.howdy.enable = true;` on top of that configures
`services.howdy` end-to-end against `/dev/ir-camera` (needs a nixpkgs new enough
to have the `services.howdy` module).

Scope of the evidence: the sensor, the bridge entry and the illuminator are
confirmed working on this DA14260 (kernel 7.1.8) and, by the fix pack's author, on
an XPS 16 DA16260 — but both of those were **DKMS installs on Arch**, not this
profile. The `intel-cvs-ir` pin is the exact code that was boot-tested: the same
rev, built with its diagnostics compiled out just as this derivation builds it,
authenticated a face through the full stream-start path (bridge reported
`GET_DEVICE_STATE = 0x06` after the IR `HOST_SET_MIPI_CONFIG`). The Nix side is
build- and eval-verified plus a partial on-hardware check: on a DA14260 running
this profile's kernel 7.1.9 build, `/dev/ir-camera` streams 648×368 at ~29 fps
with the illuminator toggling around capture, and the `howdy-ir` recorder returns
lit, correctly-framed greyscale frames. A full `pam_howdy` face-auth pass on the
NixOS profile (as opposed to the fix pack's earlier DKMS-on-Arch test) has not
been re-confirmed since the recorder landed here.

## Next Steps

1. Once [nixpkgs #542085](https://github.com/NixOS/nixpkgs/pull/542085) merges, drop the four
   vendored ipu7 packages and switch to `hardware.ipu7 = { enable = true; platform = "ipu75xa"; }`
   (keeping the hand-rolled relay, with `services.v4l2-relayd.instances.ipu7.enable = false;`).
2. Upstream `ipu7-camera-hal/ipu75xa-ov08x40-cvs.patch` to intel/ipu7-camera-hal (any Panther
   Lake laptop on kernel ≥ 7.2 needs it).
3. (Optional) Improve the `services.v4l2-relayd` NixOS module upstream so it can set loopback
   buffers and always include a `queue` — then this profile could drop the hand-rolled service.
4. Track upstream: [`intel/vision-drivers#37`](https://github.com/intel/vision-drivers/issues/37)
5. **Test IR on kernel ≥ 7.2** and lift the assertion if it works. This is the blocking unknown:
   the in-tree cvs appears to send the bridge configuration itself, so IR may need nothing beyond
   dropping the gate. Watch for the RGB camera regressing (`set_secondary_fwnode` on the shared
   `csi_dev`), and read the DSDT for `HIMX1092`'s `_DEP` to know whether that risk is real.
6. Once the kernel carries the ipu-bridge entry itself (the release after 7.2), drop
   `himx1092-ipu-bridge.patch` — the IR option would then no longer force a kernel rebuild. Only
   reachable after item 5, since the assertion currently prevents ever running that kernel with
   IR enabled.
7. Upstream `dkms/hm1092-1.0` to mainline — there is no in-tree HM1092 driver, so this profile
   will carry a vendored copy indefinitely otherwise.
8. If the kernel rebuild that `himx1092-ipu-bridge.patch` forces is unwelcome, the entry can be
   delivered instead as an out-of-tree `ipu-bridge` built from that same kernel's `kernel.src` and
   installed to `updates/` — `CONFIG_IPU_BRIDGE=m` and `CONFIG_MODVERSIONS` is unset, so it
   shadows cleanly, and `onenetbook/4/goodix-stylus-mastykin` is in-repo precedent for extracting
   an in-tree driver source that way. Not taken here because `ipu-bridge` is shared with the
   working RGB path and a lost module priority would fail silently, where a patch that stops
   applying fails at build. Worth revisiting if a stable backport to 7.1.y does not happen.
9. Re-test the WirePlumber smart-filter shape for the speaker tuning (`node.software-dsp` +
   `hide-parent`, as `framework/13-inch/common/classic-audio.nix` uses). If it processes audio on
   1.6.8/0.5.15 after all, the second sink and the compounding volumes both go away.
10. Ask for a stable backport of mainline `4fdb0342f05e` to 7.1.y — new device IDs are explicitly
   in scope for stable. If it lands, this patch expires on its own; note that it will then start
   failing to apply, so the version gate needs updating at that point.
