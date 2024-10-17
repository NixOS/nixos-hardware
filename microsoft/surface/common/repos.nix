{ fetchFromGitHub }:

{
  linux-surface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "arch-6.10.3-1";
    hash = "sha256-T7voXofI5W+YodHB2DtNSKKc4iUlN3NS0onP4TKFvQM=";
  };

  # This is the owner and repo for the pre-patched kernel from the "linux-surface" project:
  linux-surface-kernel = { rev, hash }:
    fetchFromGitHub {
      owner = "linux-surface";
      repo = "kernel";
      inherit rev hash;
    };

  ath10k-firmware = fetchFromGitHub {
    owner = "kvalo";
    repo = "ath10k-firmware";
    rev = "c987e38cbdb90dcb4e477d5dd21de66c77996435";
    hash = "sha256-w6YFoe18vJSrVXW8zzZChNw7jxZ+rT/I2kg92tU6Rpk=";
  };

  surface-go-ath10k-firmware_backup = fetchFromGitHub {
    owner = "mexisme";
    repo = "linux-surface_ath10k-firmware";
    rev = "74e5409e699383d6ca2bc4da4a8433d16f3850b1";
    hash = "sha256-AX48oDmzzEoYQkCmF/201opXuVofwGMUI9qvRt+YVHc=";
  };
}
