{ lib, pkgs, fetchgit, fetchurl }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="f8fab978a480a4ed57e9ebb6928683b2e443c1c5";
    sha256="0zwybprwjckpapxm6gxzh6hwdd1w91g5sjxn6z52zlvvjpkmw959";
  };

  ath10k-firmware = fetchgit {
    url="https://github.com/kvalo/ath10k-firmware";
    rev="84b47062aab31d67156e0a3ef593a6999a12864b";
    sha256="0l8wfj8z4jbb31nzqkaxisby0n6061ix01c5di9bq66iby59j8py";
  };

  surface-go-ath10k-firmware_upstream = fetchurl {
    url="https://support.killernetworking.com/K1535_Debian/board.bin";
    # url="https://www.killernetworking.com/support/K1535_Debian/board.bin";
    sha256="0l8wfj8z4jbb31nzqkaxisby0n6061ix01c5di9bq66iby59j8py";
  };

  surface-go-ath10k-firmware_backup = fetchgit {
    url="git@github.com:mexisme/linux-surface_ath10k-firmware.git";
    rev="74e5409e699383d6ca2bc4da4a8433d16f3850b1";
    sha256="169vgvxpgad9anmchs22fj5qm6ahzjfdnwhd8pc280q705vx6pjk";
  };
}
