{ lib,
  fetchurl,
  repos,
}:

let
  inherit (lib) kernel;
  version = "5.19.2";
  branch = "5.19";
  patches = repos.linux-surface + "/patches/${branch}";

in {
  inherit version branch;
  modDirVersion = version;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "sha256-SOQKH1UB7GxA48htPVMZIAtojy2TYPcoMwhNdIAf5j0=";
  };

  kernelPatches = [
    {
      name = "microsoft-surface-patches-linux-${version}";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
      };
    }
    {
      name = "ms-surface/0001-surface3-oemb";
      patch = patches + "/0001-surface3-oemb.patch";
    }
    {
      name = "ms-surface/0002-mwifiex";
      patch = patches + "/0002-mwifiex.patch";
    }
    {
      name = "ms-surface/0003-ath10k";
      patch = patches + "/0003-ath10k.patch";
    }
    {
      name = "ms-surface/0004-ipts";
      patch = patches + "/0004-ipts.patch";
    }
    {
      name = "ms-surface/0005-surface-sam";
      patch = patches + "/0005-surface-sam.patch";
    }
    {
      name = "ms-surface/0006-surface-sam-over-hid";
      patch = patches + "/0006-surface-sam-over-hid.patch";
    }
    {
      name = "ms-surface/0007-surface-button";
      patch = patches + "/0007-surface-button.patch";
    }
    {
      name = "ms-surface/0008-surface-typecover";
      patch = patches + "/0008-surface-typecover.patch";
    }
    {
      name = "ms-surface/0009-surface-gpe";
      patch = patches + "/0009-surface-gpe.patch";
    }
    {
      name = "ms-surface/0010-cameras";
      patch = patches + "/0010-cameras.patch";
    }
    {
      name = "ms-surface/0011-amd-gpio";
      patch = patches + "/0011-amd-gpio.patch";
    }
  ];
}
