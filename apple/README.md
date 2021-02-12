## Macbooks with T2 chips (15 and later)

# builtin wifi

There's currently no existing firmware for Macbooks containing the new T2 chips.
When installing NixOs you'll need to rely on 3rd party hardware (ex. usb-c -> ethernet unit).

To get the builtin wifi running, make sure you store the firmware specific to your macbook
as is described here: https://gist.github.com/TRPB/437f663b545d23cc8a2073253c774be3#wifi

If you already formatted your osx partition (like I did), you can probably still access
the wifi with trial and error using the firmware uploaded here https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2

To apply the firmware to your NixOs, I did the following which can be modified matching your machine and your firmware

```nix
{ stdenv,lib, fetchurl }:

let clm_blob = fetchurl {
      url = "https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui.clmb";
      sha256 = "0c626zskm6yx3dxpvhx0q6j1hsvqwxdwm6nif3kkfahyfx69glny";
    };
    apple_txt = fetchurl {
      url = "https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/P-midway-ID_M-HRPN_V-m__m-7.7.txt";
      sha256 = "01nxmcds26aanvwmpjxwh0kk9i3l7v3gh25qrmy58cmw4mwxhsa5";
    };

in stdenv.mkDerivation {

  name = "brcmfmac4364-firmware";

  src = fetchurl {
      url = "https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui.trx";
      sha256 = "0n4jz3g5mxrn8vzyfb905gjpir9xdxglb33f0p68s4wm4szw04m3";
    };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware/brcm
    cp $src $out/lib/firmware/brcm/brcmfmac4364-pcie.bin
    cp ${clm_blob} $out/lib/firmware/brcm/brcmfmac4364-pcie.clm_blob
    cp ${apple_txt} $out/lib/firmware/brcm/brcmfmac4364-pcie.Apple\ Inc.-MacBookPro15,1.txt
  '';

}
```

then add it to your hardware configuration

```nix
hardware.firmware = [ (pkgs.callPackage ./brcmfmac4364.nix {}) ];
```


## Switching Cmd and Alt/AltGr

This will switch the left Alt and Cmd key as well as the right Alt/AltGr and Cmd key.

```nix
boot.kernelParams = [
  "hid_apple.swap_opt_cmd=1"
];
```

Reference: https://wiki.archlinux.org/index.php/Apple_Keyboard#Switching_Cmd_and_Alt/AltGr

## Switching far-left fn with ctrl

```nix
boot.kernelParams = [
  "hid_apple.swap_fn_leftctrl=1"
];
```

## Making function keys default instead of media keys in TouchBar

```nix
boot.kernelParams = [
  "hid_apple.fnmode=2"
];
```

## Debugging hid_apple

Depending on your kernel version and or patches, some kernel parameters may not work.
See which parameters your system has with `ls /sys/module/hid_apple/parameters/`
and if any problems related to those parameters appear in `# dmsg`.
