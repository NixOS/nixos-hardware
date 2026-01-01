# linux-firmware/ath12k

## The problem

The [Linux Firmware](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath12k) already contains the [ath12k firmware](https://git.codelinaro.org/clo/ath-firmware/ath12k-firmware) which contains various `board-2.bin`files which are containers of the actual firmware files. The kernel module tries to load a firmware file from within the `board-2.bin` container based on the device ID that the WiFi card reports. As itt turns out,  there are WiFi cards with device IDs that aren't included in any of the firmware files in the `board-2.bin` container.

See the following bug reports on the [Kernel's Bugzilla](https://bugzilla.kernel.org/):
1. [Bug 217971](https://bugzilla.kernel.org/show_bug.cgi?id=217971)
1. [Bug 219319](https://bugzilla.kernel.org/show_bug.cgi?id=219319)
1. [Bug 218741](https://bugzilla.kernel.org/show_bug.cgi?id=218741)
1. [Bug 219239](https://bugzilla.kernel.org/show_bug.cgi?id=219239)
1. [Bug 220897](https://bugzilla.kernel.org/show_bug.cgi?id=220897)

## The solution

The solution is pointed out in some of the issues mentioned above - patch the `board-2.bin` with the device ID that your WiFi card reports. To do that, unpack the `board-2.bin` with [`bdecoder`](https://raw.githubusercontent.com/qca/qca-swiss-army-knife/99ecb87c5f808e98096eeddd5d804eeb0cf51d18/tools/scripts/ath12k/ath12k-bdencoder), edit the JSON and repack it. Then install the firmware as you normally would according to the [official readme](https://git.codelinaro.org/clo/ath-firmware/ath12k-firmware/-/blob/main/README.md?ref_type=heads).

The only problem is that it's not clear to which firmware file you should add the device ID of your WiFi card. Unfortunately, my best answer is keep trying until you find one that works.

## The Nix Solution

1. Import this module.
2. Run `sudo dmesg|grep -i ath12k`, you should see a line to the effect of:
```
[   15.743621] ath12k_pci 0000:07:00.0: failed to fetch board data for X from ath12k/Y
```
3. Place this in your NixOS Configuration:
```nix
linux-firmware-ath12k-patched = {
  enable = true;
  fw-name = "X";
  fw-board2 = "Y";
};
```
4. Build your NixOS Configuration, you should see an error to the effect of:
```
┏━ 4 Errors:
 ⋮
┃        >     "bus=pci,vendor=17cb,device=1107,subsystem-vendor=17aa,subsystem-device=e0e6,qmi-chip-id=2,qmi-board-id=255,variant=LE.bin",
┃        >     "bus=pci,vendor=17cb,device=1107,subsystem-vendor=17aa,subsystem-device=e0e6,qmi-chip-id=2,qmi-board-id=255,variant=LE_Eiger.bin",
┃        >     "bus=pci,vendor=17cb,device=1107,subsystem-vendor=105b,subsystem-device=e0ea,qmi-chip-id=2,qmi-board-id=255,variant=AC_RAY16ZPB.bin",
┃        >     "bus=pci,vendor=17cb,device=1107,subsystem-vendor=105b,subsystem-device=e10d,qmi-chip-id=2,qmi-board-id=255.bin"
┃        > ]
┃        > ================================================================================
┃        > Fatal error: please choose one of the values above and set them as the fw-file
┃        > Traceback (most recent call last):
┃        >   File "<stdin>", line 18, in <module>
┃        > RuntimeError: Fatal error: please choose one of the values above and set them as the fw-file
┃        For full logs, run:
┃          nix log /nix/store/gha0dc3ziaz16pfv321iyzchr380m4v9-linux-firmware-ath12k-patched-0-unstable-2025-12-05.drv
┣━ Dependency Graph:
┃       ┌─ ⏸ linux-zen-6.18.1-modules-shrunk waiting for 1 ⏵
┃    ┌─ ⏸ initrd-linux-zen-6.18.1
┃ ┌─ ⏸ boot.json
┃ │           ┌─ ⏵ linux-firmware-ath12k-patched-0-unstable-2025-12-05 (buildPhase)
┃ │        ┌─ ⏸ linux-firmware-ath12k-patched-0-unstable-2025-12-05-zstd
┃ │     ┌─ ⏸ firmware
┃ │  ┌─ ⏸ etc-modprobe.d-firmware.conf
┃ │  ├─ ⏵ system-units
┃ ├─ ⏸ etc
┃ ⏸ nixos-system-ron-desktop-25.11.20251225.5900a0a
┣━━━ Builds
┗━ ∑ ⏵ 2 │ ✔ 1 │ ⏸ 8 │ ⚠ Exited with 4 errors reported by nix at 22:43:30 after 7s
Error:
   0: Failed to build configuration
   1: Command exited with status Exited(1)

Location:
   src/commands.rs:693
```
5. Run the command printed below the line that says "For full logs, run:" to view the full log. Scroll up to see the list of firmware files that this module can assign your device ID to. You can either scroll up further to look at the original JSON and try to find a similar device ID to what you have and use that, or copy the list of possible values to a file and try each one until one of them work.
6. Assuming you chose a firmware file in the previous step (a string that ends with '.bin'), add the following line to your configuration and apply it:
```nix
linux-firmware-ath12k-patched = {
  /* enable, fw-name, fw-board2 as before */
  fw-file = "some-very-long-file-name.bin";
};
```
7. Reboot and examine `sudo dmesg|grep -i ath12k`. If there are no errors, try to scan and connect to a WiFi network. Make sure you can see all the networks you expect to see (e.g. 2.4Ghz, 5 Ghz and 6Ghz). If anything fails, go back to step 5.

If you've tried all the firmware files and some things don't work properly, as far as I know, I'm afraid you're out of luck. For example, I got 2.4Ghz and 5Ghz (6Ghz untested) to work, but Bluetooth isn't working.
