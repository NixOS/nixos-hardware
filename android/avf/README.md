# android/avf/

Android Virtualization Framework is a new virtualization environment for Android

Among others, it is used to provide the Terminal App starting from Android 15 QPR2

This profile contains the necesarry services and kernel configs

The system changes have been taken from https://android.googlesource.com/platform/packages/modules/Virtualization/+/refs/heads/main/build/debian

# Building initial image

Assuming current folder is the root of this repo, build the following default.nix

```nix
(import <nixpkgs/nixos/lib/eval-config.nix> {
  system = "aarch64-linux";
  modules = [
    (
      { modulesPath, ... }:
      {
        imports = [
          ./android/avf
        ];
      }
    )
  ];
}).config.system.build.avfImage
```

If the VM fails to start, include `./android/avf/debug.nix` and view the logs on a debuggable version of the Terminal app (there is no better way currently)

