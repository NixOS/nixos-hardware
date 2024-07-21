# Deprecation of //asus/zephyrus/ga402x/default.nix

Background:
The `asus-zephyrus-ga402x` provides an attr-set with `amdgpu` and `nvidia` entries, to allow users
to choose whether to enable only the AMD-GPU driver, or also enable the NVidia driver with (by
default) Prime enabled.

However, this attr-set style seems to be broken by [PR #1046](https://github.com/NixOS/nixos-hardware/pull/1046),
which exports modules as paths, instead.
That change seems to cause an error of "value is a path while a set was expected".

[PR #1053](https://github.com/NixOS/nixos-hardware/pull/1053):
- Replaced `asus-zephyrus-ga402x.amdgpu` with a `asus-zephyrus-ga402x-amdgpu` entry.
- Replaced `asus-zephyrus-ga402x.nvidia` with a `asus-zephyrus-ga402x-nvidia` entry.
- Made `asus-zephyrus-ga402x` throw a deprecation error.
- [FIXES: #1052](https://github.com/NixOS/nixos-hardware/issues/1052)
