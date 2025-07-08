{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation {
  name = "get-firmware";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-installer";
    rev = "v0.7.9";
    hash = "sha256-vbhepoZ52k5tW2Gd7tfQTZ5CLqzhV7dUcVh6+AYwECk=";
  };

  patches = [ ./get-firmware-standalone.patch ];

  buildInputs = [ python3 ];

  installPhase = ''
    cd asahi_firmware
    install -Dm755 bluetooth.py $out/bin/get-bluetooth
    install -Dm755 wifi.py $out/bin/get-wifi
  '';

  meta = with lib; {
    description = "Patched Asahi Linux Installer scripts to get brcm firmware";
    homepage = "https://github.com/AsahiLinux/asahi-installer";
    license = licenses.mit;
    maintainers = with maintainers; [ mkorje ];
    platforms = platforms.all;
  };
}
