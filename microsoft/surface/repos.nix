{ lib, pkgs, fetchFromGitHub, fetchurl }: {
  linux-surface-kernel = fetchFromGitHub {
    owner = "linux-surface";
    repo = "kernel";
    rev = "db94c89f56d6ceae03ca3802e11197f48e6c539f";
    sha256 = "0c58ri0i9gdb4w7l361pnkvq6ap17kmgnxngh0bcdmgn4dc88wx2";
  };

  ath10k-firmware = fetchFromGitHub {
    owner = "kvalo";
    repo = "ath10k-firmware";
    rev = "c987e38cbdb90dcb4e477d5dd21de66c77996435";
    sha256 = "16a67baxlga8vb43zbby2s7kpp4488vczg3manmr9g3wxnhhb9n3";
  };

  surface-go-ath10k-firmware_backup = fetchFromGitHub {
    owner = "mexisme";
    repo = "linux-surface_ath10k-firmware";
    rev = "74e5409e699383d6ca2bc4da4a8433d16f3850b1";
    sha256 = "169vgvxpgad9anmchs22fj5qm6ahzjfdnwhd8pc280q705vx6pjk";
  };
}
