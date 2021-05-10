NixOS profiles to optimize settings for different hardware.

## Setup

### Using channels

Add and update `nixos-hardware` channel:

```
$ sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
$ sudo nix-channel --update
```

Then import an appropriate profile path from the table below. For example, to
enable ThinkPad X220 profile, your `imports` in `/etc/nixos/configuration.nix`
should look like:

```
imports = [
  <nixos-hardware/lenovo/thinkpad/x220>
  ./hardware-configuration.nix
];
```

New updates to the expressions here will be fetched when you update the channel.

## Using nix flakes support

There is also experimental flake support. In your `/etc/nixos/flake.nix` add the following:

```nix
{
  description = "NixOS configuration with flakes";
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware/master;

  outputs = { self, nixpkgs, nixos-hardware }: {
    # replace <your-hostname> with your actual hostname
    nixosConfigurations.<your-hostname> = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        # ...
        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.dell-xps-13-9380
      ];
    };
  };
}
```


### Using fetchGit

You can fetch the git repository directly:

```nix
imports = [
  "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/x220"
];
```

Unlike the channel, this will update the git repository on a rebuild. However,
you can easily pin to a particular revision if you desire more stability.

## List of Profiles

See code for all available configurations.

| Model                             | Path                                               |
| --------------------------------- | -------------------------------------------------- |
| [Acer Aspire 4810T][]             | `<nixos-hardware/acer/aspire/4810t>`               |
| Airis N990                        | `<nixos-hardware/airis/n990>`                      |
| Apple MacBook Air 3,X             | `<nixos-hardware/apple/macbook-air/3>`             |
| Apple MacBook Air 4,X             | `<nixos-hardware/apple/macbook-air/4>`             |
| Apple MacBook Air 6,X             | `<nixos-hardware/apple/macbook-air/6>`             |
| [Apple MacBook Pro 10,1][]        | `<nixos-hardware/apple/macbook-pro/10-1>`          |
| Apple MacBook Pro 12,1            | `<nixos-hardware/apple/macbook-pro/12-1>`          |
| Asus TUF FX504GD                  | `<nixos-hardware/asus/fx504gd>`                    |
| BeagleBoard PocketBeagle          | `<nixos-hardware/beagleboard/pocketbeagle>`        |
| [Dell G3 3779][]                  | `<nixos-hardware/dell/g3/3779>`                    |
| Dell Latitude 3480                | `<nixos-hardware/dell/latitude/3480>`              |
| Dell Precision 5530               | `<nixos-hardware/dell/precision/5530>`             |
| [Dell XPS E7240][]                | `<nixos-hardware/dell/e7240>`                      |
| [Dell XPS 13 7390][]              | `<nixos-hardware/dell/xps/13-7390>`                |
| [Dell XPS 13 9310][]              | `<nixos-hardware/dell/xps/13-9310>`                |
| [Dell XPS 13 9343][]              | `<nixos-hardware/dell/xps/13-9343>`                |
| [Dell XPS 13 9360][]              | `<nixos-hardware/dell/xps/13-9360>`                |
| [Dell XPS 13 9370][]              | `<nixos-hardware/dell/xps/13-9370>`                |
| [Dell XPS 13 9380][]              | `<nixos-hardware/dell/xps/13-9380>`                |
| [Dell XPS 15 7590][]              | `<nixos-hardware/dell/xps/15-7590>`                |
| [Dell XPS 15 9550][]              | `<nixos-hardware/dell/xps/15-9550>`                |
| [Dell XPS 15 9550, nvidia][]      | `<nixos-hardware/dell/xps/15-9550/nvidia>`         |
| [Dell XPS 15 9560][]              | `<nixos-hardware/dell/xps/15-9560>`                |
| [Dell XPS 15 9560, intel only][]  | `<nixos-hardware/dell/xps/15-9560/intel>`          |
| [Dell XPS 15 9560, nvidia only][] | `<nixos-hardware/dell/xps/15-9560/nvidia>`         |
| [Dell XPS 15 9500][]              | `<nixos-hardware/dell/xps/15-9500>`                |
| [Dell XPS 15 9500, nvidia][]      | `<nixos-hardware/dell/xps/15-9500/nvidia>`         |
| [Google Pixelbook][]              | `<nixos-hardware/google/pixelbook>`                |
| [Inverse Path USB armory][]       | `<nixos-hardware/inversepath/usbarmory>`           |
| Lenovo IdeaPad Z510               | `<nixos-hardware/lenovo/ideapad/z510>`             |
| Lenovo ThinkPad E470              | `<nixos-hardware/lenovo/thinkpad/e470>`            |
| Lenovo ThinkPad E495              | `<nixos-hardware/lenovo/thinkpad/e495>`            |
| Lenovo ThinkPad L13               | `<nixos-hardware/lenovo/thinkpad/l13>`             |
| Lenovo ThinkPad L14 (Intel)       | `<nixos-hardware/lenovo/thinkpad/l14/intel>        |
| Lenovo ThinkPad L14 (AMD)         | `<nixos-hardware/lenovo/thinkpad/l14/amd>          |
| Lenovo ThinkPad P53               | `<nixos-hardware/lenovo/thinkpad/p53>`             |
| Lenovo ThinkPad T14               | `<nixos-hardware/lenovo/thinkpad/t14>`             |
| Lenovo ThinkPad T14 AMD Gen 1     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen1>`    |
| Lenovo ThinkPad T14s              | `<nixos-hardware/lenovo/thinkpad/t14s>`            |
| Lenovo ThinkPad T14s AMD Gen 1    | `<nixos-hardware/lenovo/thinkpad/t14s/amd/gen1>`   |
| Lenovo ThinkPad T410              | `<nixos-hardware/lenovo/thinkpad/t410>`            |
| Lenovo ThinkPad T420              | `<nixos-hardware/lenovo/thinkpad/t420>`            |
| Lenovo ThinkPad T430              | `<nixos-hardware/lenovo/thinkpad/t430>`            |
| Lenovo ThinkPad T440s             | `<nixos-hardware/lenovo/thinkpad/t440s>`           |
| Lenovo ThinkPad T440p             | `<nixos-hardware/lenovo/thinkpad/t440p>`           |
| Lenovo ThinkPad T450s             | `<nixos-hardware/lenovo/thinkpad/t450s>`           |
| Lenovo ThinkPad T460              | `<nixos-hardware/lenovo/thinkpad/t460>`           |
| Lenovo ThinkPad T460s             | `<nixos-hardware/lenovo/thinkpad/t460s>`           |
| Lenovo ThinkPad T470s             | `<nixos-hardware/lenovo/thinkpad/t470s>`           |
| Lenovo ThinkPad T480s             | `<nixos-hardware/lenovo/thinkpad/t480s>`           |
| Lenovo ThinkPad T490              | `<nixos-hardware/lenovo/thinkpad/t490>`            |
| Lenovo ThinkPad T495              | `<nixos-hardware/lenovo/thinkpad/t495>`            |
| Lenovo ThinkPad X113 Yoga         | `<nixos-hardware/lenovo/thinkpad/x13-yoga>`        |
| Lenovo ThinkPad X140e             | `<nixos-hardware/lenovo/thinkpad/x140e>`           |
| Lenovo ThinkPad X200s             | `<nixos-hardware/lenovo/thinkpad/x200s>`           |
| Lenovo ThinkPad X220              | `<nixos-hardware/lenovo/thinkpad/x220>`            |
| Lenovo ThinkPad X230              | `<nixos-hardware/lenovo/thinkpad/x230>`            |
| Lenovo ThinkPad X250              | `<nixos-hardware/lenovo/thinkpad/x250>`            |
| [Lenovo ThinkPad X260][]          | `<nixos-hardware/lenovo/thinkpad/x260>`            |
| Lenovo ThinkPad X270              | `<nixos-hardware/lenovo/thinkpad/x270>`            |
| Lenovo ThinkPad X280              | `<nixos-hardware/lenovo/thinkpad/x280>`            |
| [Lenovo ThinkPad X1 (6th Gen)][]  | `<nixos-hardware/lenovo/thinkpad/x1/6th-gen>`      |
| [Lenovo ThinkPad X1 (7th Gen)][]  | `<nixos-hardware/lenovo/thinkpad/x1/7th-gen>`      |
| Lenovo ThinkPad X1 Extreme Gen 2  | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen2>` |
| [Lenovo ThinkPad X13][]           | `<nixos-hardware/lenovo/thinkpad/x13`              |
| [Microsoft Surface Range][]       | `<nixos-hardware/microsoft/surface>`               |
| [Microsoft Surface Pro 3][]       | `<nixos-hardware/microsoft/surface-pro/3>`         |
| [MSI GS60 2QE][]                  | `<nixos-hardware/msi/gs60>`                        |
| PC Engines APU                    | `<nixos-hardware/pcengines/apu>`                   |
| [Raspberry Pi 2][]                | `<nixos-hardware/raspberry-pi/2>`                  |
| [Samsung Series 9 NP900X3C][]     | `<nixos-hardware/samsung/np900x3c>`                |
| [Purism Librem 13v3][]            | `<nixos-hardware/purism/librem/13v3>`              |
| [Purism Librem 15v3][]            | `<nixos-hardware/purism/librem/15v3>`              |
| Supermicro A1SRi-2758F            | `<nixos-hardware/supermicro/a1sri-2758f>`          |
| Supermicro X10SLL-F               | `<nixos-hardware/supermicro/x10sll-f>`             |
| [System76 (generic)][]            | `<nixos-hardware/system76>`                        |
| [System76 Darter Pro 6][]         | `<nixos-hardware/system76/darp6>`                  |
| [Toshiba Chromebook 2 `swanky`][] | `<nixos-hardware/toshiba/swanky>`                  |
| [Tuxedo InfinityBook v4][]        | `<nixos-hardware/tuxedo/infinitybook/v4>`          |

[Acer Aspire 4810T]: acer/aspire/4810t
[Asus TUF FX504GD]: asus/fx504gd
[Apple MacBook Pro 10,1]: apple/macbook-pro/10-1
[Dell G3 3779]: dell/g3/3779
[Dell XPS E7240]: dell/e7240
[Dell XPS 13 7390]: dell/xps/13-7390
[Dell XPS 13 9343]: dell/xps/13-9343
[Dell XPS 13 9310]: dell/xps/13-9310
[Dell XPS 13 9360]: dell/xps/13-9360
[Dell XPS 13 9370]: dell/xps/13-9370
[Dell XPS 13 9380]: dell/xps/13-9380
[Dell XPS 15 7590]: dell/xps/15-7590
[Dell XPS 15 9550]: dell/xps/15-9550
[Dell XPS 15 9560]: dell/xps/15-9560
[Dell XPS 15 9560, intel only]: dell/xps/15-9560/intel
[Dell XPS 15 9560, nvidia only]: dell/xps/15-9560/nvidia
[Google Pixelbook]: google/pixelbook
[Inverse Path USB armory]: inversepath/usbarmory
[Lenovo ThinkPad X1 (6th Gen)]: lenovo/thinkpad/x1/6th-gen
[Lenovo ThinkPad X1 (7th Gen)]: lenovo/thinkpad/x1/7th-gen
[Lenovo ThinkPad X13]: lenovo/thinkpad/x13
[Lenovo ThinkPad X13 Yoga]: lenovo/thinkpad/x13-yoga
[Lenovo ThinkPad X260]: lenovo/thinkpad/x260
[Microsoft Surface Pro 3]: microsoft/surface-pro/3
[MSI GS60 2QE]: msi/gs60
[Raspberry Pi 2]: raspberry-pi/2
[Samsung Series 9 NP900X3C]: samsung/np900x3c
[System76 (generic)]: system76
[System76 Darter Pro 6]: system76/darp6
[Purism Librem 13v3]: purism/librem/13v3
[Purism Librem 15v5]: purism/librem/15v5
[Toshiba Chromebook 2 `swanky`]: toshiba/swanky
[Tuxedo InfinityBook v4]: nixos-hardware/tuxedo/infinitybook/v4

## How to contribute a new device profile

1. Add your device profile expression in the appropriate directory
2. Link it in the table in README.md and in flake.nix
3. Run ./tests/run.py to test it. The test script script will parse all the profiles from the README.md
