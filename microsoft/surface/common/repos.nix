{ fetchFromGitHub }:

{
  linux-surface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "arch-6.10.3-1";
    hash = "sha256-T7voXofI5W+YodHB2DtNSKKc4iUlN3NS0onP4TKFvQM=";
  };

  # This is the owner and repo for the pre-patched kernel from the "linux-surface" project:
  linux-surface-kernel = { rev, sha256 }:
    fetchFromGitHub {
      owner = "linux-surface";
      repo = "kernel";
      inherit rev sha256;
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
