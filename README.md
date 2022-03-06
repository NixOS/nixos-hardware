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

| Model                                                               | Path                                               |
|---------------------------------------------------------------------|----------------------------------------------------|
| [Acer Aspire 4810T](acer/aspire/4810t)                              | `<nixos-hardware/acer/aspire/4810t>`               |
| [Airis N990](airis/n990)                                            | `<nixos-hardware/airis/n990>`                      |
| [Apple MacBook Air 3,X](apple/macbook-air/3)                        | `<nixos-hardware/apple/macbook-air/3>`             |
| [Apple MacBook Air 4,X](apple/macbook-air/4)                        | `<nixos-hardware/apple/macbook-air/4>`             |
| [Apple MacBook Air 6,X](apple/macbook-air/6)                        | `<nixos-hardware/apple/macbook-air/6>`             |
| [Apple MacBook Pro 10,1](apple/macbook-pro/10-1)                    | `<nixos-hardware/apple/macbook-pro/10-1>`          |
| [Apple MacBook Pro 12,1](apple/macbook-pro/12-1)                    | `<nixos-hardware/apple/macbook-pro/12-1>`          |
| [Asus ROG Strix G733QS](asus/rog-strix/g733qs)                      | `<nixos-hardware/asus/rog-strix/g733qs>`           |
| [Asus ROG Zephyrus G14 GA401](asus/zephyrus/ga401)                  | `<nixos-hardware/asus/zephyrus/ga401>`             |
| [Asus TUF FX504GD](asus/fx504gd)                                    | `<nixos-hardware/asus/fx504gd>`                    |
| [BeagleBoard PocketBeagle](beagleboard/pocketbeagle)                | `<nixos-hardware/beagleboard/pocketbeagle>`        |
| [Dell G3 3779](dell/g3/3779)                                        | `<nixos-hardware/dell/g3/3779>`                    |
| [Dell Inspiron 5509](dell/inspiron/5509)                            | `<nixos-hardware/dell/inspiron/5509>`              |
| [Dell Inspiron 5515](dell/inspiron/5515)                            | `<nixos-hardware/dell/inspiron/5515>`              |
| [Dell Latitude 3480](dell/latitude/3480)                            | `<nixos-hardware/dell/latitude/3480>`              |
| [Dell Latitude 7490](dell/latitude/7490)                            | `<nixos-hardware/dell/latitude/7490>`              |
| [Dell Poweredge R7515](dell/poweredge/r7515)                        | `<nixos-hardware/dell/poweredge/r7515>`            |
| [Dell Precision 5530](dell/precision/5530)                          | `<nixos-hardware/dell/precision/5530>`             |
| [Dell XPS 13 7390](dell/xps/13-7390)                                | `<nixos-hardware/dell/xps/13-7390>`                |
| [Dell XPS 13 9310](dell/xps/13-9310)                                | `<nixos-hardware/dell/xps/13-9310>`                |
| [Dell XPS 13 9343](dell/xps/13-9343)                                | `<nixos-hardware/dell/xps/13-9343>`                |
| [Dell XPS 13 9360](dell/xps/13-9360)                                | `<nixos-hardware/dell/xps/13-9360>`                |
| [Dell XPS 13 9370](dell/xps/13-9370)                                | `<nixos-hardware/dell/xps/13-9370>`                |
| [Dell XPS 13 9380](dell/xps/13-9380)                                | `<nixos-hardware/dell/xps/13-9380>`                |
| [Dell XPS 15 7590](dell/xps/15-7590)                                | `<nixos-hardware/dell/xps/15-7590>`                |
| [Dell XPS 15 9500, nvidia](dell/xps/15-9500/nvidia)                 | `<nixos-hardware/dell/xps/15-9500/nvidia>`         |
| [Dell XPS 15 9500](dell/xps/15-9500)                                | `<nixos-hardware/dell/xps/15-9500>`                |
| [Dell XPS 15 9550, nvidia](dell/xps/15-9550/nvidia)                 | `<nixos-hardware/dell/xps/15-9550/nvidia>`         |
| [Dell XPS 15 9550](dell/xps/15-9550)                                | `<nixos-hardware/dell/xps/15-9550>`                |
| [Dell XPS 15 9560, intel only](dell/xps/15-9560/intel)              | `<nixos-hardware/dell/xps/15-9560/intel>`          |
| [Dell XPS 15 9560, nvidia only](dell/xps/15-9560/nvidia)            | `<nixos-hardware/dell/xps/15-9560/nvidia>`         |
| [Dell XPS 15 9560](dell/xps/15-9560)                                | `<nixos-hardware/dell/xps/15-9560>`                |
| [Dell XPS 17 9710, intel only](dell/xps/17-9710/intel)              | `<nixos-hardware/dell/xps/17-9710/intel>`          |
| [Dell XPS E7240](dell/e7240)                                        | `<nixos-hardware/dell/e7240>`                      |
| [FriendlyARM NanoPC-T4](friendlyarm/nanopc-t4)                      | `<nixos-hardware/friendlyarm/nanopc-t4>`           |
| [GPD MicroPC](gpd/micropc)                                          | `<nixos-hardware/gpd/micropc>`                     |
| [Google Pixelbook](google/pixelbook)                                | `<nixos-hardware/google/pixelbook>`                |
| [HP Elitebook 2560p](hp/elitebook/2560p)                            | `<nixos-hardware/hp/elitebook/2560p>`              |
| [Intel NUC 8i7BEH](intel/nuc/8i7beh/)                               | `<nixos-hardware/intel/nuc/8i7beh>`                |
| [Lenovo IdeaPad Z510](lenovo/ideapad/z510)                          | `<nixos-hardware/lenovo/ideapad/z510>`             |
| [Lenovo Legion 5 15arh05h](lenovo/legion/15arh05h)                  | `<nixos-hardware/lenovo/legion/15arh05h>`          |
| [Lenovo ThinkPad E14 (AMD)](lenovo/thinkpad/e14/amd)                | `<nixos-hardware/lenovo/thinkpad/e14/amd>`         |
| [Lenovo ThinkPad E14 (Intel)](lenovo/thinkpad/e14/intel)            | `<nixos-hardware/lenovo/thinkpad/e14/intel>`       |
| [Lenovo ThinkPad E470](lenovo/thinkpad/e470)                        | `<nixos-hardware/lenovo/thinkpad/e470>`            |
| [Lenovo ThinkPad E495](lenovo/thinkpad/e495)                        | `<nixos-hardware/lenovo/thinkpad/e495>`            |
| [Lenovo ThinkPad L13 Yoga](lenovo/thinkpad/l13/yoga)                | `<nixos-hardware/lenovo/thinkpad/l13/yoga>`        |
| [Lenovo ThinkPad L13](lenovo/thinkpad/l13)                          | `<nixos-hardware/lenovo/thinkpad/l13>`             |
| [Lenovo ThinkPad L14 (AMD)](lenovo/thinkpad/l14/amd)                | `<nixos-hardware/lenovo/thinkpad/l14/amd>`         |
| [Lenovo ThinkPad L14 (Intel)](lenovo/thinkpad/l14/intel)            | `<nixos-hardware/lenovo/thinkpad/l14/intel>`       |
| [Lenovo ThinkPad P1 Gen 3](lenovo/thinkpad/p1/3th-gen)              | `<nixos-hardware/lenovo/thinkpad/p1/3th-gen>`      |
| [Lenovo ThinkPad P14s AMD Gen 2](lenovo/thinkpad/p14s/amd/gen2)     | `<nixos-hardware/lenovo/thinkpad/p14s/amd/gen2>`   |
| [Lenovo ThinkPad P1](thinkpad/p1)                                   | `<nixos-hardware/lenovo/thinkpad/p1>`              |
| [Lenovo ThinkPad P53](lenovo/thinkpad/p53)                          | `<nixos-hardware/lenovo/thinkpad/p53>`             |
| [Lenovo ThinkPad T14 AMD Gen 1](lenovo/thinkpad/t14/amd/gen1)       | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen1>`    |
| [Lenovo ThinkPad T14 AMD Gen 2](lenovo/thinkpad/t14/amd/gen2)       | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen2>`    |
| [Lenovo ThinkPad T14](lenovo/thinkpad/t14)                          | `<nixos-hardware/lenovo/thinkpad/t14>`             |
| [Lenovo ThinkPad T14s AMD Gen 1](lenovo/thinkpad/t14s/amd/gen1)     | `<nixos-hardware/lenovo/thinkpad/t14s/amd/gen1>`   |
| [Lenovo ThinkPad T14s](lenovo/thinkpad/t14s)                        | `<nixos-hardware/lenovo/thinkpad/t14s>`            |
| [Lenovo ThinkPad T410](lenovo/thinkpad/t410)                        | `<nixos-hardware/lenovo/thinkpad/t410>`            |
| [Lenovo ThinkPad T420](lenovo/thinkpad/t420)                        | `<nixos-hardware/lenovo/thinkpad/t420>`            |
| [Lenovo ThinkPad T430](lenovo/thinkpad/t430)                        | `<nixos-hardware/lenovo/thinkpad/t430>`            |
| [Lenovo ThinkPad T440p](lenovo/thinkpad/t440p)                      | `<nixos-hardware/lenovo/thinkpad/t440p>`           |
| [Lenovo ThinkPad T440s](lenovo/thinkpad/t440s)                      | `<nixos-hardware/lenovo/thinkpad/t440s>`           |
| [Lenovo ThinkPad T450s](lenovo/thinkpad/t450s)                      | `<nixos-hardware/lenovo/thinkpad/t450s>`           |
| [Lenovo ThinkPad T460](lenovo/thinkpad/t460)                        | `<nixos-hardware/lenovo/thinkpad/t460>`            |
| [Lenovo ThinkPad T460s](lenovo/thinkpad/t460s)                      | `<nixos-hardware/lenovo/thinkpad/t460s>`           |
| [Lenovo ThinkPad T470s](lenovo/thinkpad/t470s)                      | `<nixos-hardware/lenovo/thinkpad/t470s>`           |
| [Lenovo ThinkPad T480](lenovo/thinkpad/t480)                        | `<nixos-hardware/lenovo/thinkpad/t480>`            |
| [Lenovo ThinkPad T480s](lenovo/thinkpad/t480s)                      | `<nixos-hardware/lenovo/thinkpad/t480s>`           |
| [Lenovo ThinkPad T490](lenovo/thinkpad/t490)                        | `<nixos-hardware/lenovo/thinkpad/t490>`            |
| [Lenovo ThinkPad T495](lenovo/thinkpad/t495)                        | `<nixos-hardware/lenovo/thinkpad/t495>`            |
| [Lenovo ThinkPad T550](lenovo/thinkpad/t550)                        | `<nixos-hardware/lenovo/thinkpad/t550>`            |
| [Lenovo ThinkPad X1 (6th Gen)](lenovo/thinkpad/x1/6th-gen)          | `<nixos-hardware/lenovo/thinkpad/x1/6th-gen>`      |
| [Lenovo ThinkPad X1 (7th Gen)](lenovo/thinkpad/x1/7th-gen)          | `<nixos-hardware/lenovo/thinkpad/x1/7th-gen>`      |
| [Lenovo ThinkPad X1 (9th Gen)](lenovo/thinkpad/x1/9th-gen)          | `<nixos-hardware/lenovo/thinkpad/x1/9th-gen>`      |
| [Lenovo ThinkPad X1 Extreme Gen 2](lenovo/thinkpad/x1-extreme/gen2) | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen2>` |
| [Lenovo ThinkPad X13 Yoga](lenovo/thinkpad/x13/yoga)                | `<nixos-hardware/lenovo/thinkpad/x13/yoga>`        |
| [Lenovo ThinkPad X13](lenovo/thinkpad/x13)                          | `<nixos-hardware/lenovo/thinkpad/x13>`             |
| [Lenovo ThinkPad X140e](lenovo/thinkpad/x140e)                      | `<nixos-hardware/lenovo/thinkpad/x140e>`           |
| [Lenovo ThinkPad X200s](lenovo/thinkpad/x200s)                      | `<nixos-hardware/lenovo/thinkpad/x200s>`           |
| [Lenovo ThinkPad X220](lenovo/thinkpad/x220)                        | `<nixos-hardware/lenovo/thinkpad/x220>`            |
| [Lenovo ThinkPad X230](lenovo/thinkpad/x230)                        | `<nixos-hardware/lenovo/thinkpad/x230>`            |
| [Lenovo ThinkPad X250](lenovo/thinkpad/x250)                        | `<nixos-hardware/lenovo/thinkpad/x250>`            |
| [Lenovo ThinkPad X260](lenovo/thinkpad/x260)                        | `<nixos-hardware/lenovo/thinkpad/x260>`            |
| [Lenovo ThinkPad X270](lenovo/thinkpad/x270)                        | `<nixos-hardware/lenovo/thinkpad/x270>`            |
| [Lenovo ThinkPad X280](lenovo/thinkpad/x280)                        | `<nixos-hardware/lenovo/thinkpad/x280>`            |
| [MSI GS60 2QE](msi/gs60)                                            | `<nixos-hardware/msi/gs60>`                        |
| [Microsoft Surface Pro 3](microsoft/surface-pro/3)                  | `<nixos-hardware/microsoft/surface-pro/3>`         |
| [Microsoft Surface Range](microsoft/surface)                        | `<nixos-hardware/microsoft/surface>`               |
| [One-Netbook OneNetbook 4](onenetbook/4)                            | `<nixos-hardware/onenetbook/4>`                    |
| [PC Engines APU](pcengines/apu)                                     | `<nixos-hardware/pcengines/apu>`                   |
| [Purism Librem 13v3](purism/librem/13v3)                            | `<nixos-hardware/purism/librem/13v3>`              |
| [Purism Librem 15v3](purism/librem/13v3)                            | `<nixos-hardware/purism/librem/15v3>`              |
| [Raspberry Pi 2](raspberry-pi/2)                                    | `<nixos-hardware/raspberry-pi/2>`                  |
| [Raspberry Pi 4](raspberry-pi/4)                                    | `<nixos-hardware/raspberry-pi/4>`                  |
| [Samsung Series 9 NP900X3C](samsung/np900x3c)                       | `<nixos-hardware/samsung/np900x3c>`                |
| [Supermicro A1SRi-2758F](supermicro/a1sri-2758f)                    | `<nixos-hardware/supermicro/a1sri-2758f>`          |
| [Supermicro M11SDV-8C-LN4F](supermicro/m11sdv-8c-ln4f)              | `<nixes-hardware/supermicro/m11sdv-8c-ln4f>`       |
| [Supermicro X10SLL-F](supermicro/x10sll-f)                          | `<nixos-hardware/supermicro/x10sll-f>`             |
| [Supermicro X12SCZ-TLN4F](supermicro/x12scz-tln4f)                  | `<nixos-hardware/supermicro/x12scz-tln4f>`         |
| [System76 (generic)](system76)                                      | `<nixos-hardware/system76>`                        |
| [System76 Darter Pro 6](system76/darp6)                             | `<nixos-hardware/system76/darp6>`                  |
| [Toshiba Chromebook 2 `swanky`](toshiba/swanky)                     | `<nixos-hardware/toshiba/swanky>`                  |
| [Tuxedo InfinityBook v4](tuxedo/infinitybook/v4)                    | `<nixos-hardware/tuxedo/infinitybook/v4>`          |

## How to contribute a new device profile

1. Add your device profile expression in the appropriate directory
2. Link it in the table in README.md and in flake.nix
3. Run ./tests/run.py to test it. The test script script will parse all the profiles from the README.md
