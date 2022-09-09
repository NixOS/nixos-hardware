# Apple MacBook Pro 11,5

This configuration will **not** work with MacBook Pro 11,2 or 11,3 models.

## Notable features

* Prevent intermittent USB 3.0 controller wakeup signal when the lid is closed. Without this fix your laptop may get very hot and drain the battery after waking up in your laptop bag.

  You can see for yourself which devices are allowed to wake up your laptop using the command:

  ```shell
  cat /proc/acpi/wakeup
  ```

  This fix works for Linux kernel 3.13 and above.

  Sources:

  * [Fix unwanted laptop resume after lid is closed](https://medium.com/@laurynas.karvelis_95228/install-arch-linux-on-macbook-pro-11-2-retina-install-guide-for-year-2017-2034ceed4cb2#66ba)
  * [Arch wiki: MacBookPro11,x Suspend](https://wiki.archlinux.org/index.php/MacBookPro11,x#Suspend)
  * [simonvandel/dotfiles (nix config)](https://github.com/simonvandel/dotfiles/blob/f254a4a607257faee295ce798ed215273c342850/nixos/vandel-macair/configuration.nix#L45)

## Graphics

The [MacBookPro11,4 and MacBookPro11,5](https://support.apple.com/kb/SP719) models ship with a discrete ATI/AMD graphics card (whereas MacBookPro11,2 and MacBookPro11,3 ship with NVidia cards). This is alongside the usual integrated Intel GPU.

To switch from the older `radeon` driver to the newer `amdgpu` driver (via experimental `si_support`), include `nixos-hardware.nixosModules.common-gpu-amd-southern-islands` (or `${nixos-hardware}/common/gpu/amd/southern-islands`) in your configuration. This will get you vulkan support among other benefits.

For example, in your `flake.nix`:

```nix
nixosConfigurations = {
  macbook-pro-11-5 = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos-hardware.nixosModules.apple-macbook-pro-11-5
      nixos-hardware.nixosModules.common-gpu-amd-southern-islands
      {
        # Your personal configuration
      }
    ];
  };
};
```

## Power management

You may also wish to look into dynamic switching between integrated and discrete graphics, but this config doesn't currently attempt it.
See the removed [hardware.amdHybridGraphics.disable](https://github.com/NixOS/nixpkgs/pull/33915) option for an entry point.

## Hardware probes

Hardware probes generated with `nix run nixpkgs#hw-probe -- -all -upload`:

* Probe [#305905e674](https://linux-hardware.org/?probe=305905e674) of Apple MacBookPro11,5 (with `amdgpu` driver)

DRM (Direct Rendering Manager) snapshots generated with `drm_info -j | curl -d @- https://drmdb.emersion.fr/submit`:

* Snapshot [#e8f8076f1f1b](https://drmdb.emersion.fr/snapshots/e8f8076f1f1b) (with `amdgpu` driver)

## Additional resources

* Arch linux wiki: [MacBookPro11,x](https://wiki.archlinux.org/index.php/MacBookPro11,x)
* Kernel patches: [MacBookPro11,x](https://bugzilla.kernel.org/buglist.cgi?quicksearch=macbookpro11)

For more context about experimental `amdgpu` support, see:

* [Enabling AMDGPU by default for SI & CIK (November 2021)](https://gitlab.freedesktop.org/drm/amd/-/issues/1776)
* [Enabling AMDGPU by default for SI & CIK (August 2020))](https://lists.freedesktop.org/archives/amd-gfx/2020-August/052243.html)
* [Feature support matrix](https://wiki.gentoo.org/wiki/AMDGPU#Feature_support)
