# Lenovo LOQ 15IAX9

## Upgrading the Firmware
Since traditional methods don't work on Linux we need to use the "crisis" mode of the InsydeH2O BIOS.
We are going to follow this [guide](https://github.com/nonkerdoob/SmokelessCPU-Guides/blob/main/Guides/BIOS/BIOS_CRISIS.md) (loosely).

**Caution: With the steps I will be providing now I successfully upgraded the firmware of my laptop but I can't guarantee the same for you and I am not taking any responsibility. You are responsible for your own device.**

**Caution 2: If the BIOS you are going to flash is older than your current one, you need to enable ```BIOS Flashback``` in your BIOS settings, otherwise it will fail and might brick you device. You can see your BIOS version using ```dmidecode```**

- ### Step 1: Downloading the required files

Get the update files from [here](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/gaming-series/loq-15iax9/downloads/driver-list/component?name=BIOS%2FUEFI&id=5AC6A815-321D-440E-8833-B07A93E0428C), download the one under "BIOS Update for Windows".

- ### Step 2: Extracting the files

After downloading you should have a file named something like ```necn50ww.exe```, it might look different after the "necn" part but that's okay.
Now you can simply extract the exe with an archiving tool like ```7z```:
```
$ 7z x necn50ww.exe -ofirmware
```
After extracting the exe we can see that the file we need is inside the ```firmware``` directory

```
$ cd firmware && ls -lh
total 30M
-rw-r--r-- 1 howoz users 280K Feb  3  2021 BiosImageProcx64.dll
-rw-r--r-- 1 howoz users 104K Feb  3  2021 Ding.wav
-rw-r--r-- 1 howoz users  42K Feb  3  2021 FlsHook.exe
-rw-r--r-- 1 howoz users  47K Jun 10  2021 H2OFFT64.sys
-rw-r--r-- 1 howoz users  11K Jun 10  2021 H2OFFT.cat
-rw-r--r-- 1 howoz users 6.6K Jun 10  2021 H2OFFT.inf
-rw-r--r-- 1 howoz users 6.7M Nov 14  2023 H2OFFT-Wx64.exe
-rw-r--r-- 1 howoz users 1.3M Oct 18  2022 InterToolx64.efi
-rw-r--r-- 1 howoz users 1.7M Feb  3  2021 mfc90u.dll
-rw-r--r-- 1 howoz users  526 Feb  3  2021 Microsoft.VC90.CRT.manifest
-rw-r--r-- 1 howoz users  550 Feb  3  2021 Microsoft.VC90.MFC.manifest
-rw-r--r-- 1 howoz users 832K Feb  3  2021 msvcp90.dll
-rw-r--r-- 1 howoz users 613K Feb  3  2021 msvcr90.dll
-rw-r--r-- 1 howoz users  56K Dec  2  2025 platform.ini
-r--r--r-- 1 howoz users  19M Jan 16  2026 signed_NE.ROM
```
The ```signed_NE.ROM``` is the file we are looking for.

- ### Step 3: Creating the USB

Now that we have the file we need, we will be creating our USB.
It needs to be a single partition FAT32
After creating the USB move the ```signed_NE.ROM``` file into the root of the USB and rename it to ```necn.bin```.

You can repartition the USB with ```cfdisk```

After repartitioning the USB, you need to format the partition you just created.
```
# mkfs.fat -F32 /dev/sdX1
```

- ### Step 4: Flashing

This section copied from the guide I provided at the top

**The Beep is damn loud and will last for 8-10min, so don't do this at night**

1. Remove the Power plug
2. Make sure that the laptop is off, pressing the power button for > 30 sec
3. Plug the USB
4. Press and keep pressed FN + R
5. Plug the charger
6. Press the power button
7. The led near the Power connector will start blinking
8. Keep FN + R pressed until the computer starts beeping, it can take 2 to 5 minutes to start, don't give up early, once it starts beeping you can release the key after a couple of beeps
9. Wait for it to finish, will reboot automatically when done

## nix-info
 - system: `"x86_64-linux"`
 - host os: `Linux 7.1.3, NixOS, 26.05 (Yarara), 26.05.20260719.fd14620`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.34.8`
 - nixpkgs: `/nix/store/m0chqc0bmfxhjfpilx67cph63kn7gd11-source`

## lspci
```
...
00:02.0 VGA compatible controller: Intel Corporation Alder Lake-S [UHD Graphics] (rev 0c)
...
01:00.0 VGA compatible controller: NVIDIA Corporation AD107M [GeForce RTX 4050 Max-Q / Mobile] (rev a1)
...
```
