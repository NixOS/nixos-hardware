{
  lib,
  stdenvNoCC,
  callPackage,
  _7zz,
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
    _7zz
    get-firmware
  ];
  buildPhase = ''
    7zz x -bd -bso0 -bsp0 $src \
      "macOS Base System/usr/share/firmware/bluetooth/*" \
      "macOS Base System/usr/share/firmware/wifi/*"

    get-bluetooth "macOS Base System/usr/share/firmware/bluetooth" bluetooth/
    get-wifi "macOS Base System/usr/share/firmware/wifi" wifi/
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
