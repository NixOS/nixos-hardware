{ lib, pkgs, fetchgit }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="74e3a9cd99dd21c362f9a674d0bb42a824c39bd8";
    sha256="09andw78kmz9yd37j0r00y1za2j9n0x6g47b1gyijsglj9yzr7lm";
  };
}
