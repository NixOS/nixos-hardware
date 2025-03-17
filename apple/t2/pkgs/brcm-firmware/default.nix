{
  lib,
  stdenvNoCC,
  callPackage,
  vmTools,
  util-linux,
  linux,
  kmod,
  version,
}:

let
  get-firmware = callPackage ./get-firmware.nix { };
  fetchmacos = callPackage ./fetchmacos.nix { };

  # See https://github.com/kholia/OSX-KVM/blob/master/fetch-macOS-v2.py#L534-L546.
  # Versions before macOS Monterey don't have Bluetooth firmware.
  # Whereas macOS Sequoia doesn't have firmware for MacBook Air 2018 and 2019.
  boards = {
    monterey = {
      boardId = "Mac-B809C3757DA9BB8D";
      mlb = "00000000000000000";
      osType = "latest";
      hash = "sha256-My8FLnqHZn+THfGPIhTSApW/kIWM0ZZhjBxWujhhWPM=";
    };
    ventura = {
      boardId = "Mac-4B682C642B45593E";
      mlb = "00000000000000000";
      osType = "latest";
      hash = "sha256-Qy9Whu8pqHo+m6wHnCIqURAR53LYQKc0r87g9eHgnS4=";
    };
    sonoma = {
      boardId = "Mac-827FAC58A8FDFA22";
      mlb = "00000000000000000";
      osType = "default";
      hash = "sha256-phlpwNTYhugqX2KGljqxpbfGtCFDgggQPzB7U29XSmM=";
    };
  };
in

vmTools.runInLinuxVM (
  stdenvNoCC.mkDerivation {
    pname = "brcm-firmware";
    inherit version;

    src = fetchmacos {
      name = version;
      inherit (boards.${version})
        boardId
        mlb
        osType
        hash
        ;
    };
    dontUnpack = true;

    nativeBuildInputs = [
      util-linux
      get-firmware
    ];
    buildPhase = ''
      ln -s ${linux}/lib /lib
      ${kmod}/bin/modprobe loop
      ${kmod}/bin/modprobe hfsplus

      imgdir=$(mktemp -d)
      loopdev=$(losetup -f | cut -d "/" -f 3)
      losetup -P $loopdev $src
      loopdev_partition=/dev/$(lsblk -o KNAME,TYPE,MOUNTPOINT -n | grep $loopdev | tail -1 | awk '{print $1}')
      mount $loopdev_partition $imgdir

      get-bluetooth $imgdir/usr/share/firmware/bluetooth bluetooth/
      get-wifi $imgdir/usr/share/firmware/wifi wifi/
    '';

    installPhase = ''
      mkdir -p $out/lib/firmware/brcm
      cp bluetooth/brcm/* $out/lib/firmware/brcm/
      cp wifi/brcm/* $out/lib/firmware/brcm/
    '';

    meta = with lib; {
      description = "Wi-Fi and Bluetooth firmware for T2 Macs";
      license = licenses.unfree;
      maintainers = with maintainers; [ mkorje ];
      platforms = platforms.linux;
    };
  }
)
