{ lib, pkgs, fetchgit }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="25ab2cf75e5eda5ab9739db1907300010c06dacf";
    sha256="0h8624d7ix1p6ysw9bllmnnwnv164z8xkx56zj3vdczn91vmqcf9";
  };

  surface-ipts-firmware = fetchgit {
    url="https://github.com/linux-surface/surface-ipts-firmware.git";
    rev="bd5093318d2550d5d668241d0d34df4be3fc03ab";
    sha256="0q7k52yk3jdliizl3cq1m3zbbqsx360wxybnbgkaq46rawzhw5bk";
  };

  libwacom-surface = fetchgit {
    url="https://github.com/linux-surface/libwacom-surface.git";
    rev="12628e069298ac2e409501d423a1bf8567b5d1bb";
    sha256="1lydyfx33crd0qvzdyqyp39d0d9fnsplch6429sagdsn6a139ap0";
  };
}
