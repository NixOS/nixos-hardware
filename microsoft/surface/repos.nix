{ lib, pkgs, fetchgit }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="25ab2cf75e5eda5ab9739db1907300010c06dacf";
    sha256="0h8624d7ix1p6ysw9bllmnnwnv164z8xkx56zj3vdczn91vmqcf9";
  };

  libwacom-surface = fetchgit {
    url="https://github.com/linux-surface/libwacom-surface.git";
    rev="12628e069298ac2e409501d423a1bf8567b5d1bb";
    sha256="1lydyfx33crd0qvzdyqyp39d0d9fnsplch6429sagdsn6a139ap0";
  };
}
