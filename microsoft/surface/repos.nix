{ lib, pkgs, fetchgit }:
{
  linux-surface = fetchgit {
    url="https://github.com/linux-surface/linux-surface.git";
    rev="f8fab978a480a4ed57e9ebb6928683b2e443c1c5";
    sha256="0zwybprwjckpapxm6gxzh6hwdd1w91g5sjxn6z52zlvvjpkmw959";
  };
}
