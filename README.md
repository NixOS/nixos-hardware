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

### Using nix flakes support

There is also experimental flake support. In your `/etc/nixos/flake.nix` add
the following:

```nix
{
  description = "NixOS configuration with flakes";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

## How to contribute a new device profile

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## Get in touch

For questions and discussions, come join us in the [nixos-anywhere matrix](https://matrix.to/#/#nixos-hardware:nixos.org) room.

## List of Profiles

See code for all available configurations.

| Model                                                                             | Path                                                    |
| --------------------------------------------------------------------------------- | ------------------------------------------------------- |
| [Acer Aspire 4810T](acer/aspire/4810t)                                            | `<nixos-hardware/acer/aspire/4810t>`                    |
| [Airis N990](airis/n990)                                                          | `<nixos-hardware/airis/n990>`                           |
| [Apple iMac 14.2](apple/imac/14-2)                                                | `<nixos-hardware/apple/imac/14-2>`                      |
| [Apple iMac 18.2](apple/imac/18-2)                                                | `<nixos-hardware/apple/imac/18-2>`                      |
| [Apple MacBook Air 3,X](apple/macbook-air/3)                                      | `<nixos-hardware/apple/macbook-air/3>`                  |
| [Apple MacBook Air 4,X](apple/macbook-air/4)                                      | `<nixos-hardware/apple/macbook-air/4>`                  |
| [Apple MacBook Air 6,X](apple/macbook-air/6)                                      | `<nixos-hardware/apple/macbook-air/6>`                  |
| [Apple MacBook Air 7,X](apple/macbook-air/7)                                      | `<nixos-hardware/apple/macbook-air/7>`                  |
| [Apple MacBook Pro 8,1](apple/macbook-pro/8-1)                                    | `<nixos-hardware/apple/macbook-pro/8-1>`                |
| [Apple MacBook Pro 10,1](apple/macbook-pro/10-1)                                  | `<nixos-hardware/apple/macbook-pro/10-1>`               |
| [Apple MacBook Pro 11,1](apple/macbook-pro/11-1)                                  | `<nixos-hardware/apple/macbook-pro/11-1>`               |
| [Apple MacBook Pro 11,5](apple/macbook-pro/11-5)                                  | `<nixos-hardware/apple/macbook-pro/11-5>`               |
| [Apple MacBook Pro 12,1](apple/macbook-pro/12-1)                                  | `<nixos-hardware/apple/macbook-pro/12-1>`               |
| [Apple MacBook Pro 14,1](apple/macbook-pro/14-1)                                  | `<nixos-hardware/apple/macbook-pro/14-1>`               |
| [Apple MacMini (2010, Intel, Nvidia)](apple/macmini/4)                            | `<nixos-hardware/apple/macmini/4>`                      |
| [Apple Macs with a T2 Chip](apple/t2)                                             | `<nixos-hardware/apple/t2>`                             |
| [Aoostar R1 N100](aoostar/r1/n100)                                                | `<nixos-hardware/aoostar/r1/n100>`                      |
| [Asus Pro WS X570-ACE](asus/pro-ws-x570-ace)                                      | `<nixos-hardware/asus/pro-ws-x570-ace>`                 |
| [Asus ROG Ally RC71L (2023)](asus/ally/rc71l)                                     | `<nixos-hardware/asus/ally/rc71l>`                      |
| [Asus ROG Flow X13 GV302X\* (2023)](asus/flow/gv302x/amdgpu)                      | `<nixos-hardware/asus/flow/gv302x/amdgpu>`              |
| [Asus ROG Flow X13 GV302X\* (2023)](asus/flow/gv302x/nvidia)                      | `<nixos-hardware/asus/flow/gv302x/nvidia>`              |
| [Asus ROG Strix G513IM](asus/rog-strix/g513im)                                    | `<nixos-hardware/asus/rog-strix/g513im>`                |
| [Asus ROG Strix G713IE](asus/rog-strix/g713ie)                                    | `<nixos-hardware/asus/rog-strix/g713ie>`                |
| [Asus ROG Strix G733QS](asus/rog-strix/g733qs)                                    | `<nixos-hardware/asus/rog-strix/g733qs>`                |
| [Asus ROG Strix X570-E GAMING](asus/rog-strix/x570e)                              | `<nixos-hardware/asus/rog-strix/x570e>`                 |
| [Asus ROG Zephyrus G14 GA401](asus/zephyrus/ga401)                                | `<nixos-hardware/asus/zephyrus/ga401>`                  |
| [Asus ROG Zephyrus G14 GA402](asus/zephyrus/ga402)                                | `<nixos-hardware/asus/zephyrus/ga402>`                  |
| [Asus ROG Zephyrus G14 GA402X\* (2023)](asus/zephyrus/ga402x/amdgpu)              | `<nixos-hardware/asus/zephyrus/ga402x/amdgpu>`          |
| [Asus ROG Zephyrus G14 GA402X\* (2023)](asus/zephyrus/ga402x/nvidia)              | `<nixos-hardware/asus/zephyrus/ga402x/nvidia>`          |
| [Asus ROG Zephyrus G15 GA502](asus/zephyrus/ga502)                                | `<nixos-hardware/asus/zephyrus/ga502>`                  |
| [Asus ROG Zephyrus G15 GA503](asus/zephyrus/ga503)                                | `<nixos-hardware/asus/zephyrus/ga503>`                  |
| [Asus ROG Zephyrus G16 GU605MY](asus/zephyrus/gu605my)                            | `<nixos-hardware/asus/zephyrus/gu605my>`                |
| [Asus ROG Zephyrus M16 GU603H](asus/zephyrus/gu603h)                              | `<nixos-hardware/asus/zephyrus/gu603h>`                 |
| [Asus TUF FX504GD](asus/fx504gd)                                                  | `<nixos-hardware/asus/fx504gd>`                         |
| [Asus TUF FX506HM](asus/fx506hm)                                                  | `<nixos-hardware/asus/fx506hm>`                         |
| [Asus TUF FA506IC](asus/fa506ic)                                                  | `<nixos-hardware/asus/fa506ic>`                         |
| [Asus TUF FA507RM](asus/fa507rm)                                                  | `<nixos-hardware/asus/fa507rm>`                         |
| [Asus TUF FA507NV](asus/fa507nv)                                                  | `<nixos-hardware/asus/fa507nv>`                         |
| [Asus Zenbook Flip S13 UX371](asus/zenbook/ux371/)                                | `<nixos-hardware/asus/zenbook/ux371>`                   |
| [Asus Zenbook Pro 15 UX535](asus/zenbook/ux535/)                                  | `<nixos-hardware/asus/zenbook/ux535>`                   |
| [BeagleBoard PocketBeagle](beagleboard/pocketbeagle)                              | `<nixos-hardware/beagleboard/pocketbeagle>`             |
| [Chuwi MiniBook X](chuwi/minibook-x)                                              | `<nixos-hardware/chuwi/minibook-x>`                     |
| [Deciso DEC series](deciso/dec)                                                   | `<nixos-hardware/deciso/dec>`                           |
| [Dell G3 3779](dell/g3/3779)                                                      | `<nixos-hardware/dell/g3/3779>`                         |
| [Dell G3 3579](dell/g3/3579)                                                      | `<nixos-hardware/dell/g3/3579>`                         |
| [Dell Inspiron 3442](dell/inspiron/3442)                                       | `<nixos-hardawre/dell/inspiron/3442>`                |
| [Dell Inspiron 14 5420](dell/inspiron/14-5420)                                    | `<nixos-hardawre/dell/inspiron/14-5420>`                |
| [Dell Inspiron 5509](dell/inspiron/5509)                                          | `<nixos-hardware/dell/inspiron/5509>`                   |
| [Dell Inspiron 5515](dell/inspiron/5515)                                          | `<nixos-hardware/dell/inspiron/5515>`                   |
| [Dell Inspiron 7405](dell/inspiron/7405)                                          | `<nixos-hardware/dell/inspiron/7405>`                   |
| [Dell Inspiron 7460](dell/inspiron/7460)                                          | `<nixos-hardware/dell/inspiron/7460>`                   |
| [Dell Latitude 3340](dell/latitude/3340)                                          | `<nixos-hardware/dell/latitude/3340>`                   |
| [Dell Latitude 3480](dell/latitude/3480)                                          | `<nixos-hardware/dell/latitude/3480>`                   |
| [Dell Latitude 5490](dell/latitude/5490)                                          | `<nixos-hardware/dell/latitude/5490>`                   |
| [Dell Latitude 5520](dell/latitude/5520)                                          | `<nixos-hardware/dell/latitude/5520>`                   |
| [Dell Latitude 7280](dell/latitude/7280)                                          | `<nixos-hardware/dell/latitude/7280>`                   |
| [Dell Latitude 7390](dell/latitude/7390)                                          | `<nixos-hardware/dell/latitude/7390>`                   |
| [Dell Latitude 7420](dell/latitude/7420)                                          | `<nixos-hardware/dell/latitude/7420>`                   |
| [Dell Latitude 7430](dell/latitude/7430)                                          | `<nixos-hardware/dell/latitude/7430>`                   |
| [Dell Latitude 7490](dell/latitude/7490)                                          | `<nixos-hardware/dell/latitude/7490>`                   |
| [Dell Latitude 9430](dell/latitude/9430)                                          | `<nixos-hardware/dell/latitude/9430>`                   |
| [Dell Latitude E7240](dell/latitude/e7240)                                        | `<nixos-hardware/dell/latitude/e7240>`                  |
| [Dell Optiplex 3050](dell/optiplex/3050)                                          | `<nixos-hardware/dell/optiplex/3050>`                   |
| [Dell Poweredge R7515](dell/poweredge/r7515)                                      | `<nixos-hardware/dell/poweredge/r7515>`                 |
| [Dell Precision 3541](dell/precision/3541)                                        | `<nixos-hardware/dell/precision/3541>`                  |
| [Dell Precision 5490](dell/precision/5490)                                        | `<nixos-hardware/dell/precision/5490>`                  |
| [Dell Precision 5530](dell/precision/5530)                                        | `<nixos-hardware/dell/precision/5530>`                  |
| [Dell Precision 7520](dell/precision/7520)                                        | `<nixos-hardware/dell/precision/7520>`                  |
| [Dell XPS 13 7390](dell/xps/13-7390)                                              | `<nixos-hardware/dell/xps/13-7390>`                     |
| [Dell XPS 13 9300](dell/xps/13-9300)                                              | `<nixos-hardware/dell/xps/13-9300>`                     |
| [Dell XPS 13 9310](dell/xps/13-9310)                                              | `<nixos-hardware/dell/xps/13-9310>`                     |
| [Dell XPS 13 9315](dell/xps/13-9315)                                              | `<nixos-hardware/dell/xps/13-9315>`                     |
| [Dell XPS 13 9333](dell/xps/13-9333)                                              | `<nixos-hardware/dell/xps/13-9333>`                     |
| [Dell XPS 13 9343](dell/xps/13-9343)                                              | `<nixos-hardware/dell/xps/13-9343>`                     |
| [Dell XPS 13 9350](dell/xps/13-9350)                                              | `<nixos-hardware/dell/xps/13-9350>`                     |
| [Dell XPS 13 9360](dell/xps/13-9360)                                              | `<nixos-hardware/dell/xps/13-9360>`                     |
| [Dell XPS 13 9370](dell/xps/13-9370)                                              | `<nixos-hardware/dell/xps/13-9370>`                     |
| [Dell XPS 13 9380](dell/xps/13-9380)                                              | `<nixos-hardware/dell/xps/13-9380>`                     |
| [Dell XPS 15 7590, nvidia](dell/xps/15-7590/nvidia)                               | `<nixos-hardware/dell/xps/15-7590/nvidia>`              |
| [Dell XPS 15 7590](dell/xps/15-7590)                                              | `<nixos-hardware/dell/xps/15-7590>`                     |
| [Dell XPS 15 9500, nvidia](dell/xps/15-9500/nvidia)                               | `<nixos-hardware/dell/xps/15-9500/nvidia>`              |
| [Dell XPS 15 9500](dell/xps/15-9500)                                              | `<nixos-hardware/dell/xps/15-9500>`                     |
| [Dell XPS 15 9510, nvidia](dell/xps/15-9510/nvidia)                               | `<nixos-hardware/dell/xps/15-9510/nvidia>`              |
| [Dell XPS 15 9510](dell/xps/15-9510)                                              | `<nixos-hardware/dell/xps/15-9510>`                     |
| [Dell XPS 15 9520, nvidia](dell/xps/15-9520/nvidia)                               | `<nixos-hardware/dell/xps/15-9520/nvidia>`              |
| [Dell XPS 15 9520](dell/xps/15-9520)                                              | `<nixos-hardware/dell/xps/15-9520>`                     |
| [Dell XPS 15 9530, nvidia](dell/xps/15-9520/nvidia)                               | `<nixos-hardware/dell/xps/15-9530/nvidia>`              |
| [Dell XPS 15 9420](dell/xps/15-9520)                                              | `<nixos-hardware/dell/xps/15-9530>`                     |
| [Dell XPS 15 9550, nvidia](dell/xps/15-9550/nvidia)                               | `<nixos-hardware/dell/xps/15-9550/nvidia>`              |
| [Dell XPS 15 9550](dell/xps/15-9550)                                              | `<nixos-hardware/dell/xps/15-9550>`                     |
| [Dell XPS 15 9560, intel only](dell/xps/15-9560/intel)                            | `<nixos-hardware/dell/xps/15-9560/intel>`               |
| [Dell XPS 15 9560, nvidia only](dell/xps/15-9560/nvidia)                          | `<nixos-hardware/dell/xps/15-9560/nvidia>`              |
| [Dell XPS 15 9560](dell/xps/15-9560)                                              | `<nixos-hardware/dell/xps/15-9560>`                     |
| [Dell XPS 15 9570, intel only](dell/xps/15-9570/intel)                            | `<nixos-hardware/dell/xps/15-9570/intel>`               |
| [Dell XPS 15 9570, nvidia](dell/xps/15-9570/nvidia)                               | `<nixos-hardware/dell/xps/15-9570/nvidia>`              |
| [Dell XPS 15 9570](dell/xps/15-9570)                                              | `<nixos-hardware/dell/xps/15-9570>`                     |
| [Dell XPS 17 9700, intel](dell/xps/17-9700/intel)                                 | `<nixos-hardware/dell/xps/17-9700/intel`                |
| [Dell XPS 17 9700, nvidia](dell/xps/17-9700/nvidia)                               | `<nixos-hardware/dell/xps/17-9700/nvidia>`              |
| [Dell XPS 17 9710, intel only](dell/xps/17-9710/intel)                            | `<nixos-hardware/dell/xps/17-9710/intel>`               |
| [Framework 11th Gen Intel Core](framework/13-inch/11th-gen-intel)                 | `<nixos-hardware/framework/13-inch/11th-gen-intel>`     |
| [Framework 12th Gen Intel Core](framework/13-inch/12th-gen-intel)                 | `<nixos-hardware/framework/13-inch/12th-gen-intel>`     |
| [Framework 13th Gen Intel Core](framework/13-inch/13th-gen-intel)                 | `<nixos-hardware/framework/13-inch/13th-gen-intel>`     |
| [Framework Intel Core Ultra Series 1](framework/13-inch/intel-core-ultra-series1) | `<nixos-hardware/framework/13-inch/intel-core-ultra-series1>`     |
| [Framework 13 AMD Ryzen 7040 Series](framework/13-inch/7040-amd)                  | `<nixos-hardware/framework/13-inch/7040-amd>`           |
| [Framework 16 AMD Ryzen 7040 Series](framework/16-inch/7040-amd)                  | `<nixos-hardware/framework/16-inch/7040-amd>`           |
| [FriendlyARM NanoPC-T4](friendlyarm/nanopc-t4)                                    | `<nixos-hardware/friendlyarm/nanopc-t4>`                |
| [FriendlyARM NanoPi R5s](friendlyarm/nanopi-r5s)                                  | `<nixos-hardware/friendlyarm/nanopi-r5s>`               |
| [Focus M2 Gen 1](focus/m2/gen1)                                                   | `<nixos-hardware/focus/m2/gen1>`                        |
| [Gigabyte B550](gigabyte/b550)                                                    | `<nixos-hardware/gigabyte/b550>`                        |
| [Gigabyte B650](gigabyte/b650)                                                    | `<nixos-hardware/gigabyte/b650>`                        |
| [GPD MicroPC](gpd/micropc)                                                        | `<nixos-hardware/gpd/micropc>`                          |
| [GPD P2 Max](gpd/p2-max)                                                          | `<nixos-hardware/gpd/p2-max>`                           |
| [GPD Pocket 3](gpd/pocket-3)                                                      | `<nixos-hardware/gpd/pocket-3>`                         |
| [GPD Pocket 4](gpd/pocket-4)                                                      | `<nixos-hardware/gpd/pocket-4>`                         |
| [GPD WIN 2](gpd/win-2)                                                            | `<nixos-hardware/gpd/win-2>`                            |
| [GPD WIN Max 2 2023](gpd/win-max-2/2023)                                          | `<nixos-hardware/gpd/win-max-2/2023>`                   |
| [GPD WIN Mini 2024](gpd/win-mini/2024)                                            | `<nixos-hardware/gpd/win-mini/2024>`                    |
| [Google Pixelbook](google/pixelbook)                                              | `<nixos-hardware/google/pixelbook>`                     |
| [HP Elitebook 2560p](hp/elitebook/2560p)                                          | `<nixos-hardware/hp/elitebook/2560p>`                   |
| [HP Elitebook 830g6](hp/elitebook/830/g6)                                         | `<nixos-hardware/hp/elitebook/830/g6>`                  |
| [HP Elitebook 845g7](hp/elitebook/845/g7)                                         | `<nixos-hardware/hp/elitebook/845/g7>`                  |
| [HP Elitebook 845g8](hp/elitebook/845/g8)                                         | `<nixos-hardware/hp/elitebook/845/g8>`                  |
| [HP Elitebook 845g9](hp/elitebook/845/g9)                                         | `<nixos-hardware/hp/elitebook/845/g9>`                  |
| [HP Laptop 14s-dq2024nf](hp/laptop/14s-dq2024nf)                                  | `<nixos-hardware/hp/laptop/14s-dq2024nf>`               |
| [HP Notebook 14-df0023](hp/notebook/14-df0023)                                    | `<nixos-hardware/hp/notebook/14-df0023>`                |
| [HP Probook 440G5](hp/probook/440g5)                                              | `<nixos-hardware/hp/probook/440g5>`                     |
| [Huawei Matebook X Pro (2020)](huawei/machc-wa)                                   | `<nixos-hardware/huawei/machc-wa>`                      |
| [i.MX8QuadMax Multisensory Enablement Kit](nxp/imx8qm-mek/)                       | `<nixos-hardware/nxp/imx8qm-mek>`                       |
| [Intel NUC 8i7BEH](intel/nuc/8i7beh/)                                             | `<nixos-hardware/intel/nuc/8i7beh>`                     |
| [Lenovo IdeaCentre K330](lenovo/ideacentre/k330)                                  | `<nixos-hardware/lenovo/ideacentre/k330>`               |
| [Lenovo IdeaPad 3 15alc6](lenovo/ideapad/15alc6)                                  | `<nixos-hardware/lenovo/ideapad/15alc6>`                |
| [Lenovo IdeaPad Gaming 3 15arh05](lenovo/ideapad/15arh05)                         | `<nixos-hardware/lenovo/ideapad/15arh05>`               |
| [Lenovo IdeaPad Gaming 3 15ach6](lenovo/ideapad/15ach6)                           | `<nixos-hardware/lenovo/ideapad/15ach6>`                |
| [Lenovo IdeaPad 5 Pro 16ach6](lenovo/ideapad/16ach6)                              | `<nixos-hardware/lenovo/ideapad/16ach6>`                |
| [Lenovo IdeaPad Z510](lenovo/ideapad/z510)                                        | `<nixos-hardware/lenovo/ideapad/z510>`                  |
| [Lenovo IdeaPad Slim 5](lenovo/ideapad/slim-5)                                    | `<nixos-hardware/lenovo/ideapad/slim-5>`                |
| [Lenovo IdeaPad Slim 5 16iah8](lenovo/ideapad/16iah8)                             | `<nixos-hardware/lenovo/ideapad/16iah8`                 |
| [Lenovo IdeaPad 2-in-1 16ahp9](lenovo/ideapad/16ahp09)                            | `<nixos-hardware/lenovo/ideapad/16ahp9`                 |
| [Lenovo IdeaPad S145 15api](lenovo/ideapad/s145-15api)                            | `<nixos-hardware/lenovo/ideapad/s145-15api>`            |
| [Lenovo Legion 5 15ach6h](lenovo/legion/15ach6h)                                  | `<nixos-hardware/lenovo/legion/15ach6h>`                |
| [Lenovo Legion 5 15arh05h](lenovo/legion/15arh05h)                                | `<nixos-hardware/lenovo/legion/15arh05h>`               |
| [Lenovo Legion 7 Slim 15ach6](lenovo/legion/15ach6)                               | `<nixos-hardware/lenovo/legion/15ach6>`                 |
| [Lenovo Legion 5 Pro 16ach6h](lenovo/legion/16ach6h)                              | `<nixos-hardware/lenovo/legion/16ach6h>`                |
| [Lenovo Legion 5 Pro 16ach6h (Hybrid)](lenovo/legion/16ach6h/hybrid)              | `<nixos-hardware/lenovo/legion/16ach6h/hybrid>`         |
| [Lenovo Legion 5 Pro 16ach6h (Nvidia)](lenovo/legion/16ach6h/nvidia)              | `<nixos-hardware/lenovo/legion/16ach6h/nvidia>`         |
| [Lenovo Legion 7 16achg6 (Hybrid)](lenovo/legion/16achg6/hybrid)                  | `<nixos-hardware/lenovo/legion/16achg6/hybrid>`         |
| [Lenovo Legion 7 16achg6 (Nvidia)](lenovo/legion/16achg6/nvidia)                  | `<nixos-hardware/lenovo/legion/16achg6/nvidia>`         |
| [Lenovo Legion 7i Pro 16irx8h (Intel)](lenovo/legion/16irx8h)                     | `<nixos-hardware/lenovo/legion/16irx8h>`                |
| [Lenovo Legion 7 Pro 16irx9h (Intel)](lenovo/legion/16irx9h)                      | `<nixos-hardware/lenovo/legion/16irx9h>`                |
| [Lenovo Legion Slim 7 Gen 7 (AMD)](lenovo/legion/16arha7/)                        | `<nixos-hardware/lenovo/legion/16arha7>`                |
| [Lenovo Legion T5 AMR5](lenovo/legion/t526amr5)                                   | `<nixos-hardware/lenovo/legion/t526amr5>`               |
| [Lenovo Legion Y530 15ICH](lenovo/legion/15ich)                                   | `<nixos-hardware/lenovo/legion/15ich>`                  |
| [Lenovo ThinkPad A475](lenovo/thinkpad/a475)                                      | `<nixos-hardware/lenovo/thinkpad/a475>`                 |
| [Lenovo ThinkPad E14 (AMD)](lenovo/thinkpad/e14/amd)                              | `<nixos-hardware/lenovo/thinkpad/e14/amd>`              |
| [Lenovo ThinkPad E14 (Intel)](lenovo/thinkpad/e14/intel)                          | `<nixos-hardware/lenovo/thinkpad/e14/intel>`            |
| [Lenovo ThinkPad E470](lenovo/thinkpad/e470)                                      | `<nixos-hardware/lenovo/thinkpad/e470>`                 |
| [Lenovo ThinkPad E495](lenovo/thinkpad/e495)                                      | `<nixos-hardware/lenovo/thinkpad/e495>`                 |
| [Lenovo ThinkPad L13 Yoga](lenovo/thinkpad/l13/yoga)                              | `<nixos-hardware/lenovo/thinkpad/l13/yoga>`             |
| [Lenovo ThinkPad L13](lenovo/thinkpad/l13)                                        | `<nixos-hardware/lenovo/thinkpad/l13>`                  |
| [Lenovo ThinkPad L14 (AMD)](lenovo/thinkpad/l14/amd)                              | `<nixos-hardware/lenovo/thinkpad/l14/amd>`              |
| [Lenovo ThinkPad L14 (Intel)](lenovo/thinkpad/l14/intel)                          | `<nixos-hardware/lenovo/thinkpad/l14/intel>`            |
| [Lenovo ThinkPad L480](lenovo/thinkpad/l480)                                      | `<nixos-hardware/lenovo/thinkpad/l480>`                 |
| [Lenovo ThinkPad P1 Gen 3](lenovo/thinkpad/p1/3th-gen)                            | `<nixos-hardware/lenovo/thinkpad/p1/3th-gen>`           |
| [Lenovo ThinkPad P14s AMD Gen 1](lenovo/thinkpad/p14s/amd/gen1)                   | `<nixos-hardware/lenovo/thinkpad/p14s/amd/gen1>`        |
| [Lenovo ThinkPad P14s AMD Gen 2](lenovo/thinkpad/p14s/amd/gen2)                   | `<nixos-hardware/lenovo/thinkpad/p14s/amd/gen2>`        |
| [Lenovo ThinkPad P14s AMD Gen 3](lenovo/thinkpad/p14s/amd/gen3)                   | `<nixos-hardware/lenovo/thinkpad/p14s/amd/gen3>`        |
| [Lenovo ThinkPad P14s AMD Gen 4](lenovo/thinkpad/p14s/amd/gen4)                   | `<nixos-hardware/lenovo/thinkpad/p14s/amd/gen4>`        |
| [Lenovo ThinkPad P14s Intel Gen 3](lenovo/thinkpad/p14s/intel/gen3)               | `<nixos-hardware/lenovo/thinkpad/p14s/intel/gen3>`      |
| [Lenovo ThinkPad P16s AMD Gen 1](lenovo/thinkpad/p16s/amd/gen1)                   | `<nixos-hardware/lenovo/thinkpad/p16s/amd/gen1>`        |
| [Lenovo ThinkPad P16s AMD Gen 2](lenovo/thinkpad/p16s/amd/gen2)                   | `<nixos-hardware/lenovo/thinkpad/p16s/amd/gen2>`        |
| [Lenovo ThinkPad P1](lenovo/thinkpad/p1)                                          | `<nixos-hardware/lenovo/thinkpad/p1>`                   |
| [Lenovo ThinkPad P50](lenovo/thinkpad/p50)                                        | `<nixos-hardware/lenovo/thinkpad/p50>`                  |
| [Lenovo ThinkPad P51](lenovo/thinkpad/p51)                                        | `<nixos-hardware/lenovo/thinkpad/p51>`                  |
| [Lenovo ThinkPad P52](lenovo/thinkpad/p52)                                        | `<nixos-hardware/lenovo/thinkpad/p52>`                  |
| [Lenovo ThinkPad P53](lenovo/thinkpad/p53)                                        | `<nixos-hardware/lenovo/thinkpad/p53>`                  |
| [Lenovo ThinkPad T14 AMD Gen 1](lenovo/thinkpad/t14/amd/gen1)                     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen1>`         |
| [Lenovo ThinkPad T14 AMD Gen 2](lenovo/thinkpad/t14/amd/gen2)                     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen2>`         |
| [Lenovo ThinkPad T14 AMD Gen 3](lenovo/thinkpad/t14/amd/gen3)                     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen3>`         |
| [Lenovo ThinkPad T14 AMD Gen 4](lenovo/thinkpad/t14/amd/gen4)                     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen4>`         |
| [Lenovo ThinkPad T14 AMD Gen 5](lenovo/thinkpad/t14/amd/gen5)                     | `<nixos-hardware/lenovo/thinkpad/t14/amd/gen5>`         |
| [Lenovo ThinkPad T14](lenovo/thinkpad/t14)                                        | `<nixos-hardware/lenovo/thinkpad/t14>`                  |
| [Lenovo ThinkPad T14s AMD Gen 1](lenovo/thinkpad/t14s/amd/gen1)                   | `<nixos-hardware/lenovo/thinkpad/t14s/amd/gen1>`        |
| [Lenovo ThinkPad T14s AMD Gen 4](lenovo/thinkpad/t14s/amd/gen4)                   | `<nixos-hardware/lenovo/thinkpad/t14s/amd/gen4>`        |
| [Lenovo ThinkPad T14s](lenovo/thinkpad/t14s)                                      | `<nixos-hardware/lenovo/thinkpad/t14s>`                 |
| [Lenovo ThinkPad T410](lenovo/thinkpad/t410)                                      | `<nixos-hardware/lenovo/thinkpad/t410>`                 |
| [Lenovo ThinkPad T420](lenovo/thinkpad/t420)                                      | `<nixos-hardware/lenovo/thinkpad/t420>`                 |
| [Lenovo ThinkPad T430](lenovo/thinkpad/t430)                                      | `<nixos-hardware/lenovo/thinkpad/t430>`                 |
| [Lenovo ThinkPad T440p](lenovo/thinkpad/t440p)                                    | `<nixos-hardware/lenovo/thinkpad/t440p>`                |
| [Lenovo ThinkPad T440s](lenovo/thinkpad/t440s)                                    | `<nixos-hardware/lenovo/thinkpad/t440s>`                |
| [Lenovo ThinkPad T450s](lenovo/thinkpad/t450s)                                    | `<nixos-hardware/lenovo/thinkpad/t450s>`                |
| [Lenovo ThinkPad T460](lenovo/thinkpad/t460)                                      | `<nixos-hardware/lenovo/thinkpad/t460>`                 |
| [Lenovo ThinkPad T460p](lenovo/thinkpad/t460p)                                    | `<nixos-hardware/lenovo/thinkpad/t460p>`                |
| [Lenovo ThinkPad T460s](lenovo/thinkpad/t460s)                                    | `<nixos-hardware/lenovo/thinkpad/t460s>`                |
| [Lenovo ThinkPad T470s](lenovo/thinkpad/t470s)                                    | `<nixos-hardware/lenovo/thinkpad/t470s>`                |
| [Lenovo ThinkPad T480](lenovo/thinkpad/t480)                                      | `<nixos-hardware/lenovo/thinkpad/t480>`                 |
| [Lenovo ThinkPad T480s](lenovo/thinkpad/t480s)                                    | `<nixos-hardware/lenovo/thinkpad/t480s>`                |
| [Lenovo ThinkPad T490](lenovo/thinkpad/t490)                                      | `<nixos-hardware/lenovo/thinkpad/t490>`                 |
| [Lenovo ThinkPad T490s](lenovo/thinkpad/t490s)                                    | `<nixos-hardware/lenovo/thinkpad/t490s>`                |
| [Lenovo ThinkPad T495](lenovo/thinkpad/t495)                                      | `<nixos-hardware/lenovo/thinkpad/t495>`                 |
| [Lenovo ThinkPad T520](lenovo/thinkpad/t520)                                      | `<nixos-hardware/lenovo/thinkpad/t520>`                 |
| [Lenovo ThinkPad T550](lenovo/thinkpad/t550)                                      | `<nixos-hardware/lenovo/thinkpad/t550>`                 |
| [Lenovo ThinkPad T590](lenovo/thinkpad/t590)                                      | `<nixos-hardware/lenovo/thinkpad/t590>`                 |
| [Lenovo ThinkPad W520](lenovo/thinkpad/w520)                                      | `<nixos-hardware/lenovo/thinkpad/w520>`                 |
| [Lenovo ThinkPad X1 Yoga](lenovo/thinkpad/x1/yoga)                                | `<nixos-hardware/lenovo/thinkpad/x1/yoga>`              |
| [Lenovo ThinkPad X1 Yoga Gen 7](lenovo/thinkpad/x1/yoga/7th-gen/)                 | `<nixos-hardware/lenovo/thinkpad/x1/yoga/7th-gen>`      |
| [Lenovo ThinkPad X1 (6th Gen)](lenovo/thinkpad/x1/6th-gen)                        | `<nixos-hardware/lenovo/thinkpad/x1/6th-gen>`           |
| [Lenovo ThinkPad X1 (7th Gen)](lenovo/thinkpad/x1/7th-gen)                        | `<nixos-hardware/lenovo/thinkpad/x1/7th-gen>`           |
| [Lenovo ThinkPad X1 (9th Gen)](lenovo/thinkpad/x1/9th-gen)                        | `<nixos-hardware/lenovo/thinkpad/x1/9th-gen>`           |
| [Lenovo ThinkPad X1 (10th Gen)](lenovo/thinkpad/x1/10th-gen)                      | `<nixos-hardware/lenovo/thinkpad/x1/10th-gen>`          |
| [Lenovo ThinkPad X1 (11th Gen)](lenovo/thinkpad/x1/11th-gen)                      | `<nixos-hardware/lenovo/thinkpad/x1/11th-gen>`          |
| [Lenovo ThinkPad X1 (12th Gen)](lenovo/thinkpad/x1/12th-gen)                      | `<nixos-hardware/lenovo/thinkpad/x1/12th-gen>`          |
| [Lenovo ThinkPad X1 Extreme Gen 2](lenovo/thinkpad/x1-extreme/gen2)               | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen2>`      |
| [Lenovo ThinkPad X1 Extreme Gen 3](lenovo/thinkpad/x1-extreme/gen3)               | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen3>`      |
| [Lenovo ThinkPad X1 Extreme Gen 4](lenovo/thinkpad/x1-extreme/gen4)               | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen4>`      |
| [Lenovo ThinkPad X1 Nano Gen 1](lenovo/thinkpad/x1-nano/gen1)                     | `<nixos-hardware/lenovo/thinkpad/x1-nano/gen1>`         |
| [Lenovo ThinkPad X13 Yoga](lenovo/thinkpad/x13/yoga)                              | `<nixos-hardware/lenovo/thinkpad/x13/yoga>`             |
| [Lenovo ThinkPad X13 Yoga (3th Gen)](lenovo/thinkpad/x13/yoga/3th-gen)            | `<nixos-hardware/lenovo/thinkpad/x13/yoga/3th-gen>`     |
| [Lenovo ThinkPad X13 (Intel)](lenovo/thinkpad/x13/intel)                          | `<nixos-hardware/lenovo/thinkpad/x13/intel>`            |
| [Lenovo ThinkPad X13 (AMD)](lenovo/thinkpad/x13/amd)                              | `<nixos-hardware/lenovo/thinkpad/x13/amd>`              |
| [Lenovo ThinkPad X140e](lenovo/thinkpad/x140e)                                    | `<nixos-hardware/lenovo/thinkpad/x140e>`                |
| [Lenovo ThinkPad X200s](lenovo/thinkpad/x200s)                                    | `<nixos-hardware/lenovo/thinkpad/x200s>`                |
| [Lenovo ThinkPad X220](lenovo/thinkpad/x220)                                      | `<nixos-hardware/lenovo/thinkpad/x220>`                 |
| [Lenovo ThinkPad X230](lenovo/thinkpad/x230)                                      | `<nixos-hardware/lenovo/thinkpad/x230>`                 |
| [Lenovo ThinkPad X250](lenovo/thinkpad/x250)                                      | `<nixos-hardware/lenovo/thinkpad/x250>`                 |
| [Lenovo ThinkPad X260](lenovo/thinkpad/x260)                                      | `<nixos-hardware/lenovo/thinkpad/x260>`                 |
| [Lenovo ThinkPad X270](lenovo/thinkpad/x270)                                      | `<nixos-hardware/lenovo/thinkpad/x270>`                 |
| [Lenovo ThinkPad X280](lenovo/thinkpad/x280)                                      | `<nixos-hardware/lenovo/thinkpad/x280>`                 |
| [Lenovo ThinkPad X390](lenovo/thinkpad/x390)                                      | `<nixos-hardware/lenovo/thinkpad/x390>`                 |
| [Lenovo ThinkPad Z Series](lenovo/thinkpad/z)                                     | `<nixos-hardware/lenovo/thinkpad/z>`                    |
| [Lenovo ThinkPad Z13 Gen 1](lenovo/thinkpad/z/gen1/z13)                           | `<nixos-hardware/lenovo/thinkpad/z/gen1/z13>`           |
| [Lenovo ThinkPad Z13 Gen 2](lenovo/thinkpad/z/gen2/z13)                           | `<nixos-hardware/lenovo/thinkpad/z/gen2/z13>`           |
| [LENOVO Yoga 6 13ALC6 82ND](lenovo/yoga/6/13ALC6)                                 | `<nixos-hardware/lenovo/yoga/6/13ALC6>`                 |
| [LENOVO Yoga Slim 7 Pro-X 14ARH7 82ND](lenovo/yoga/7/14ARH7/amdgpu)               | `<nixos-hardware/lenovo/yoga/7/14ARH7/amdgpu>`          |
| [LENOVO Yoga Slim 7 Pro-X 14ARH7 82ND](lenovo/yoga/7/14ARH7/nvidia)               | `<nixos-hardware/lenovo/yoga/7/14ARH7/nvidia>`          |
| [Lenovo Yoga Slim 7i Pro X 14IAH7 (Integrated)](lenovo/yoga/7/14IAH7/integrated)  |`<nixos-hardware/lenovo/yoga/7/14IAH7/integrated>`       |
| [Lenovo Yoga Slim 7i Pro X 14IAH7 (Hybrid)](lenovo/yoga/7/14IAH7/hybrid)          |`<nixos-hardware/lenovo/yoga/7/14IAH7/hybrid>`           |
| [LENOVO Yoga 7 Slim Gen8](lenovo/yoga/7/slim/gen8)                                | `<nixos-hardware/lenovo/yoga/7/slim/gen8>`              |
| [MSI B550-A PRO](msi/b550-a-pro)                                                  | `<nixos-hardware/msi/b550-a-pro>`                       |
| [MSI B350 TOMAHAWK](msi/b350-tomahawk)                                            | `<nixos-hardware/msi/b350-tomahawk>`                    |
| [MSI GS60 2QE](msi/gs60)                                                          | `<nixos-hardware/msi/gs60>`                             |
| [MSI GL62/CX62](msi/gl62)                                                         | `<nixos-hardware/msi/gl62>`                             |
| [MSI GL65 10SDR-492](msi/gl65/10SDR-492)                                          | `<nixos-hardware/msi/gl65/10SDR-492>`                   |
| [Microchip Icicle Kit](microchip/icicle-kit)                                      | `<nixos-hardware/microchip/icicle-kit>`                 |
| [Microsoft Surface Go](microsoft/surface/surface-go)                              | `<nixos-hardware/microsoft/surface/surface-go>`         |
| [Microsoft Surface Pro (Intel)](microsoft/surface/surface-pro-intel)              | `<nixos-hardware/microsoft/surface/surface-pro-intel>`  |
| [Microsoft Surface Laptop (AMD)](microsoft/surface/surface-laptop-amd)            | `<nixos-hardware/microsoft/surface/surface-laptop-amd>` |
| [Microsoft Surface Range (Common Modules)](microsoft/surface/common)              | `<nixos-hardware/microsoft/surface/common>`             |
| [Microsoft Surface Pro 3](microsoft/surface-pro/3)                                | `<nixos-hardware/microsoft/surface-pro/3>`              |
| [Microsoft Surface Pro 9](microsoft/surface-pro/9)                                | `<nixos-hardware/microsoft/surface-pro/9>`              |
| [Morefine M600](morefine/m600)                                                    | `<nixos-hardware/morefine/m600>`                        |
| [Minisforum V3](minisforum/v3)                                                    | `<nixos-hardware/minisforum/v3>`                        |
| [NXP iMX8 MPlus Evaluation Kit](nxp/imx8mp-evk)                                   | `<nixos-hardware/nxp/imx8mp-evk>`                       |
| [NXP iMX8 MQuad Evaluation Kit](nxp/imx8mq-evk)                                   | `<nixos-hardware/nxp/imx8mq-evk>`                       |
| [Hardkernel Odroid HC4](hardkernel/odroid-hc4/default.nix)                        | `<nixos-hardware/hardkernel/odroid-hc4>`                |
| [Hardkernel Odroid H3](hardkernel/odroid-h3/default.nix)                          | `<nixos-hardware/hardkernel/odroid-h3>`                 |
| [Hardkernel Odroid H4](hardkernel/odroid-h4/default.nix)                          | `<nixos-hardware/hardkernel/odroid-h4>`                 |
| [Omen 14-fb0798ng](omen/14-fb0798ng)                                              | `<nixos-hardware/omen/14-fb0798ng>`                     |
| [Omen 15-ce002ns](omen/15-ce002ns)                                                | `<nixos-hardware/omen/15-ce002ns>`                      |
| [Omen 15-en0010ca](omen/15-en0010ca)                                              | `<nixos-hardware/omen/15-en0010ca>`                     |
| [Omen 16-n0005ne](omen/16-n0005ne)                                                | `<nixos-hardware/omen/16-n0005ne>`                      |
| [Omen 16-n0280nd](/omen/16-n0280nd)                                               | `<nixos-hardware/omen/16-n0280nd>`                      |
| [Omen 15-en1007sa](omen/15-en1007sa)                                              | `<nixos-hardware/omen/15-en1007sa>`                     |
| [Omen 15-en0002np](omen/15-en0002np)                                              | `<nixos-hardware/omen/15-en0002np>`                     |
| [One-Netbook OneNetbook 4](onenetbook/4)                                          | `<nixos-hardware/onenetbook/4>`                         |
| [Panasonic Let's Note CF-LX4](panasonic/letsnote/cf-lx4)                          | `<nixos-hardware/panasonic/letsnote/cf-lx4>`            |
| [PC Engines APU](pcengines/apu)                                                   | `<nixos-hardware/pcengines/apu>`                        |
| [PINE64 Pinebook Pro](pine64/pinebook-pro/)                                       | `<nixos-hardware/pine64/pinebook-pro>`                  |
| [PINE64 RockPro64](pine64/rockpro64/)                                             | `<nixos-hardware/pine64/rockpro64>`                     |
| [PINE64 STAR64](pine64/star64/)                                                   | `<nixos-hardware/pine64/star64>`                        |
| [Protectli VP4670](protectli/vp4670/)                                             | `<nixos-hardware/protectli/vp4670>`                     |
| [Purism Librem 13v3](purism/librem/13v3)                                          | `<nixos-hardware/purism/librem/13v3>`                   |
| [Purism Librem 15v3](purism/librem/13v3)                                          | `<nixos-hardware/purism/librem/15v3>`                   |
| [Purism Librem 5r4](purism/librem/5r4)                                            | `<nixos-hardware/purism/librem/5r4>`                    |
| [Radxa ROCK 4C+](radxa/rock-4c-plus)                                              | `<nixos-hardware/radxa/rock-4c-plus>`                   |
| [Radxa ROCK 5 Model B](radxa/rock-5b)                                             | `<nixos-hardware/radxa/rock-5b>`                        |
| [Radxa ROCK Pi 4](radxa/rock-pi-4)                                                | `<nixos-hardware/radxa/rock-pi-4>`                      |
| [Radxa ROCK Pi E](radxa/rock-pi-e)                                                | `<nixos-hardware/radxa/rock-pi-e>`                      |
| [Raspberry Pi 2](raspberry-pi/2)                                                  | `<nixos-hardware/raspberry-pi/2>`                       |
| [Raspberry Pi 3](raspberry-pi/3)                                                  | `<nixos-hardware/raspberry-pi/3>`                       |
| [Raspberry Pi 4](raspberry-pi/4)                                                  | `<nixos-hardware/raspberry-pi/4>`                       |
| [Raspberry Pi 5](raspberry-pi/5)                                                  | `<nixos-hardware/raspberry-pi/5>`                       |
| [Samsung Series 9 NP900X3C](samsung/np900x3c)                                     | `<nixos-hardware/samsung/np900x3c>`                     |
| [Slimbook Hero RPL-RTX](slimbook/hero/rpl-rtx)                                    | `<nixos-hardware/slimbook/hero/rpl-rtx>`                |
| [StarFive VisionFive v1](starfive/visionfive/v1)                                  | `<nixos-hardware/starfive/visionfive/v1>`               |
| [StarFive VisionFive 2](starfive/visionfive/v2)                                   | `<nixos-hardware/starfive/visionfive/v2>`               |
| [StarLabs StarLite 5 (I5)](starlabs/starlite/i5)                                  | `<nixos-hardware/starlabs/starlite/i5>`                 |
| [Supermicro A1SRi-2758F](supermicro/a1sri-2758f)                                  | `<nixos-hardware/supermicro/a1sri-2758f>`               |
| [Supermicro M11SDV-8C-LN4F](supermicro/m11sdv-8c-ln4f)                            | `<nixos-hardware/supermicro/m11sdv-8c-ln4f>`            |
| [Supermicro X10SLL-F](supermicro/x10sll-f)                                        | `<nixos-hardware/supermicro/x10sll-f>`                  |
| [Supermicro X12SCZ-TLN4F](supermicro/x12scz-tln4f)                                | `<nixos-hardware/supermicro/x12scz-tln4f>`              |
| [System76 (generic)](system76)                                                    | `<nixos-hardware/system76>`                             |
| [System76 Darter Pro 6](system76/darp6)                                           | `<nixos-hardware/system76/darp6>`                       |
| [System76 Gazelle 18](system76/gaze18)                                            | `<nixos-hardware/system76/gaze18>`                      |
| [System76 Galago Pro 5](system76/galp5-1650)                                      | `<nixos-hardware/system76/galp5-1650>`                  |
| [Toshiba Chromebook 2 `swanky`](toshiba/swanky)                                   | `<nixos-hardware/toshiba/swanky>`                       |
| [Tuxedo InfinityBook v4](tuxedo/infinitybook/v4)                                  | `<nixos-hardware/tuxedo/infinitybook/v4>`               |
| [TUXEDO Aura 15 - Gen1](tuxedo/aura/15/gen1)                                      | `<nixos-hardware/tuxedo/aura/15/gen1>`                  |
| [TUXEDO InfinityBook Pro 14 - Gen7](tuxedo/infinitybook/pro14/gen7)               | `<nixos-hardware/tuxedo/infinitybook/pro14/gen7>`       |
| [TUXEDO Pulse 14 - Gen3](tuxedo/pulse/14/gen3)                                    | `<nixos-hardware/tuxedo/pulse/14/gen3>`                 |
| [TUXEDO Pulse 15 - Gen2](tuxedo/pulse/15/gen2)                                    | `<nixos-hardware/tuxedo/pulse/15/gen2>`                 |
| [Xiaomi Redmibook 16 Pro 2024](xiaomi/redmibook/16-pro-2024)                      | `<nixos-hardware/xiaomi/redmibook/16-pro-2024>`         |
