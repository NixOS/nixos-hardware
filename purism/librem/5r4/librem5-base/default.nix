{
  stdenv,
  fetchFromGitLab,
  shellcheck,
  kmod,
  lib,
}:
stdenv.mkDerivation {
  pname = "librem5-base";
  version = "unstable";
  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "librem5-base";
    rev = "96b0f920cde9157332b0c16ba1135ee60a3f3259";
    hash = "sha256-nR42dk3g0/IkVFygZ7K1SZ2KoQJeDzuMOumKdOOQS5k=";
  };

  buildPhase = ":";

  checkInputs = [ shellcheck ];
  doCheck = true;
  checkPhase = "make";

  installPhase = ''
    mkdir -p "$out/bin" "$out/lib/udev/rules.d"
    cp -v default/lockdown-support/lockdown-support.sh "$out/bin"
    chmod +x "$out/bin/lockdown-support.sh"
    cp -v default/gpsd/99-gnss.rules "$out/lib/udev/rules.d"

    pushd debian
    for rule in librem5-base-defaults.*.udev; do
      cp -v "$rule" "$out/lib/udev/rules.d/''${rule#*.}.rules"
    done
    popd

    mkdir -p "$out/etc/pulse"
    cp -v "default/audio/pulse/librem5.pa" "$out/etc/pulse/librem5.pa"
    substituteInPlace "$out/etc/pulse/librem5.pa" \
      --replace ".include /etc/pulse/default.pa" ""
  '';

  postFixup = ''
    sed -i \
      -e "s@/usr/sbin/lockdown-support.sh@$out/bin/lockdown-support.sh@g" \
      -e "s@/usr/sbin/modprobe@${kmod}/bin/modprobe@g" \
      -e "s@/usr/sbin/rmmod@${kmod}/bin/rmmod@g" \
      "$out"/lib/udev/rules.d/*.udev.rules
  '';

  # https://source.puri.sm/Librem5/librem5-base/-/issues/68
  # President@Purism promised it's under a free license: https://matrix.to/#/%23community-librem-5%3Atalk.puri.sm/%24hNCtZr7Escmr56uz1eEiaHpakteEXig7b5G8t2W6tWs
  meta.license = lib.licenses.free;
}
