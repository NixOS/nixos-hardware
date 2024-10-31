{ fetchFromGitHub }:

{
  linux-surface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "arch-6.10.10-1";
    hash = "sha256-AX48oDmzzEoYQkCmF/201opXuVofwGMUI9qvRt+YVHc=";
  };

  # This is the owner and repo for the pre-patched kernel from the "linux-surface" project:
  linux-surface-kernel = { rev, hash }:
    fetchFromGitHub {
      owner = "linux-surface";
      repo = "kernel";
      inherit rev hash;
    };

  surface-go-ath10k-firmware_backup = fetchFromGitHub {
    owner = "mexisme";
    repo = "linux-surface_ath10k-firmware";
    rev = "74e5409e699383d6ca2bc4da4a8433d16f3850b1";
    hash = "sha256-AX48oDmzzEoYQkCmF/201opXuVofwGMUI9qvRt+YVHc=";
  };
}
