{ lib, pkgs, fetchgit, fetchurl }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="25ab2cf75e5eda5ab9739db1907300010c06dacf";
    sha256="0h8624d7ix1p6ysw9bllmnnwnv164z8xkx56zj3vdczn91vmqcf9";
  };

  linux-kernel-firmware = fetchgit {
    url="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev="060ad8b3d505e2ff8878d11a81da3532b983cd45";
    sha256="0n93xc3vzx7gy96lpkypw7ay201x7whirxm00c0zhq6zmq2zs12v";
  };

  ath10k-firmware = fetchgit {
    url="https://github.com/kvalo/ath10k-firmware";
    rev="84b47062aab31d67156e0a3ef593a6999a12864b";
    sha256="0l8wfj8z4jbb31nzqkaxisby0n6061ix01c5di9bq66iby59j8py";
  };

    surface-go-ath10k-firmware = fetchurl {
    url="https://support.killernetworking.com/K1535_Debian/board.bin";
    # url="https://www.killernetworking.com/support/K1535_Debian/board.bin";
    sha256="0l8wfj8z4jbb31nzqkaxisby0n6061ix01c5di9bq66iby59j8py";
  };

}
