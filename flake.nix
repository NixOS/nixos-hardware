{
  description = "nixos-hardware";

  outputs = _: {
    nixosModules = {
      acer-aspire-4810t = import ./acer/aspire/4810t;
      airis-n990 = import ./airis/n990;
      apple-macbook-air-3 = import ./apple/macbook-air/3;
      apple-macbook-air-4 = import ./apple/macbook-air/4;
      apple-macbook-air-6 = import ./apple/macbook-air/6;
      apple-macbook-pro = import ./apple/macbook-pro;
      apple-macbook-pro-10-1 = import ./apple/macbook-pro/10-1;
      apple-macbook-pro-11-5 = import ./apple/macbook-pro/11-5;
      apple-macbook-pro-12-1 = import ./apple/macbook-pro/12-1;
      apple-macbook-pro-14-1 = import ./apple/macbook-pro/14-1;
      apple-macmini-4-1 = import ./apple/macmini/4;
      apple-t2 = import ./apple/t2;
      asus-battery = import ./asus/battery.nix;
      asus-ally-rc71l = import ./asus/ally/rc71l;
      asus-fx504gd = import ./asus/fx504gd;
      asus-fx506hm = import ./asus/fx506hm;
      asus-fa507nv = import ./asus/fa507nv;
      asus-fa507rm = import ./asus/fa507rm;
      asus-pro-ws-x570-ace = import ./asus/pro-ws-x570-ace;
      asus-rog-strix-g513im = import ./asus/rog-strix/g513im;
      asus-rog-strix-g733qs = import ./asus/rog-strix/g733qs;
      asus-zenbook-ux371 = import ./asus/zenbook/ux371;
      asus-zephyrus-ga401 = import ./asus/zephyrus/ga401;
      asus-zephyrus-ga402 = import ./asus/zephyrus/ga402;
      asus-zephyrus-ga402x = import ./asus/zephyrus/ga402x;
      asus-zephyrus-ga502 = import ./asus/zephyrus/ga502;
      asus-zephyrus-ga503 = import ./asus/zephyrus/ga503;
      asus-zephyrus-gu603h = import ./asus/zephyrus/gu603h;
      beagleboard-pocketbeagle = import ./beagleboard/pocketbeagle;
      chuwi-minibook-x = import ./chuwi/minibook-x;
      deciso-dec = import ./deciso/dec;
      dell-e7240 = import ./dell/e7240;
      dell-g3-3779 = import ./dell/g3/3779;
      dell-inspiron-14-5420 = import ./dell/inspiron/14-5420;
      dell-inspiron-5509 = import ./dell/inspiron/5509;
      dell-inspiron-5515 = import ./dell/inspiron/5515;
      dell-inspiron-7405 = import ./dell/inspiron/7405;
      dell-latitude-3340 = import ./dell/latitude/3340;
      dell-latitude-3480 = import ./dell/latitude/3480;
      dell-latitude-5520 = import ./dell/latitude/5520;
      dell-latitude-7280 = import ./dell/latitude/7280;
      dell-latitude-7390 = import ./dell/latitude/7390;
      dell-latitude-7430 = import ./dell/latitude/7430;
      dell-latitude-7490 = import ./dell/latitude/7490;
      dell-latitude-9430 = import ./dell/latitude/9430;
      dell-optiplex-3050 = import ./dell/optiplex/3050;
      dell-poweredge-r7515 = import ./dell/poweredge/r7515;
      dell-precision-3541 = import ./dell/precision/3541;
      dell-precision-5530 = import ./dell/precision/5530;
      dell-precision-7520 = import ./dell/precision/7520;
      dell-xps-13-7390 = import ./dell/xps/13-7390;
      dell-xps-13-9300 = import ./dell/xps/13-9300;
      dell-xps-13-9310 = import ./dell/xps/13-9310;
      dell-xps-13-9333 = import ./dell/xps/13-9333;
      dell-xps-13-9343 = import ./dell/xps/13-9343;
      dell-xps-13-9350 = import ./dell/xps/13-9350;
      dell-xps-13-9360 = import ./dell/xps/13-9360;
      dell-xps-13-9370 = import ./dell/xps/13-9370;
      dell-xps-13-9380 = import ./dell/xps/13-9380;
      dell-xps-15-7590 = import ./dell/xps/15-7590;
      dell-xps-15-7590-nvidia = import ./dell/xps/15-7590/nvidia;
      dell-xps-15-9500 = import ./dell/xps/15-9500;
      dell-xps-15-9500-nvidia = import ./dell/xps/15-9500/nvidia;
      dell-xps-15-9510 = import ./dell/xps/15-9510;
      dell-xps-15-9510-nvidia = import ./dell/xps/15-9510/nvidia;
      dell-xps-15-9520 = import ./dell/xps/15-9520;
      dell-xps-15-9520-nvidia = import ./dell/xps/15-9520/nvidia;
      dell-xps-15-9550 = import ./dell/xps/15-9550;
      dell-xps-15-9550-nvidia = import ./dell/xps/15-9550/nvidia;
      dell-xps-15-9560 = import ./dell/xps/15-9560;
      dell-xps-15-9560-intel = import ./dell/xps/15-9560/intel;
      dell-xps-15-9560-nvidia = import ./dell/xps/15-9560/nvidia;
      dell-xps-15-9570 = import ./dell/xps/15-9570;
      dell-xps-15-9570-intel = import ./dell/xps/15-9570/intel;
      dell-xps-15-9570-nvidia = import ./dell/xps/15-9570/nvidia;
      dell-xps-17-9700-intel = import ./dell/xps/17-9700/intel;
      dell-xps-17-9700-nvidia = import ./dell/xps/17-9700/nvidia;
      dell-xps-17-9710-intel = import ./dell/xps/17-9710/intel;
      framework = import ./framework;
      framework-11th-gen-intel = import ./framework/13-inch/11th-gen-intel;
      framework-12th-gen-intel = import ./framework/13-inch/12th-gen-intel;
      framework-13th-gen-intel = import ./framework/13-inch/13th-gen-intel;
      framework-13-7040-amd = import ./framework/13-inch/7040-amd;
      framework-16-7040-amd = import ./framework/16-inch/7040-amd;
      friendlyarm-nanopc-t4 = import ./friendlyarm/nanopc-t4;
      friendlyarm-nanopi-r5s = import ./friendlyarm/nanopi-r5s;
      focus-m2-gen1 = import ./focus/m2/gen1;
      gigabyte-b550 = import ./gigabyte/b550;
      google-pixelbook = import ./google/pixelbook;
      gpd-micropc = import ./gpd/micropc;
      gpd-p2-max = import ./gpd/p2-max;
      gpd-pocket-3 = import ./gpd/pocket-3;
      gpd-win-2 = import ./gpd/win-2;
      gpd-win-max-2-2023 = import ./gpd/win-max-2/2023;
      hp-elitebook-2560p = import ./hp/elitebook/2560p;
      hp-elitebook-830g6 = import ./hp/elitebook/830/g6;
      hp-elitebook-845g7 = import ./hp/elitebook/845/g7;
      hp-elitebook-845g8 = import ./hp/elitebook/845/g8;
      hp-elitebook-845g9 = import ./hp/elitebook/845/g9;
      huawei-machc-wa = import ./huawei/machc-wa;
      hp-notebook-14-df0023 = import ./hp/notebook/14-df0023;
      intel-nuc-8i7beh = import ./intel/nuc/8i7beh;
      lenovo-ideapad-15alc6 = import ./lenovo/ideapad/15alc6;
      lenovo-ideapad-15arh05 = import ./lenovo/ideapad/15arh05;
      lenovo-ideapad-16ach6 = import ./lenovo/ideapad/16ach6;
      lenovo-ideapad-z510 = import ./lenovo/ideapad/z510;
      lenovo-ideapad-slim-5 = import ./lenovo/ideapad/slim-5;
      lenovo-ideapad-s145-15api = import ./lenovo/ideapad/s145-15api;
      lenovo-legion-15ach6 = import ./lenovo/legion/15ach6;
      lenovo-legion-15ach6h = import ./lenovo/legion/15ach6h;
      lenovo-legion-15arh05h = import ./lenovo/legion/15arh05h;
      lenovo-legion-16ach6h = import ./lenovo/legion/16ach6h;
      lenovo-legion-16ach6h-hybrid = import ./lenovo/legion/16ach6h/hybrid;
      lenovo-legion-16ach6h-nvidia = import ./lenovo/legion/16ach6h/nvidia;
      lenovo-legion-16achg6-hybrid = import ./lenovo/legion/16achg6/hybrid;
      lenovo-legion-16achg6-nvidia = import ./lenovo/legion/16achg6/nvidia;
      lenovo-legion-16aph8 = import ./lenovo/legion/16aph8;
      lenovo-legion-16arha7 = import ./lenovo/legion/16arha7;
      lenovo-legion-16ithg6 = import ./lenovo/legion/16ithg6;
      lenovo-legion-16irx8h = import ./lenovo/legion/16irx8h;
      lenovo-legion-t526amr5 = import ./lenovo/legion/t526amr5;
      lenovo-legion-y530-15ich = import ./lenovo/legion/15ich;
      lenovo-thinkpad = import ./lenovo/thinkpad;
      lenovo-thinkpad-a475 = import ./lenovo/thinkpad/a475;
      lenovo-thinkpad-e14-amd = import ./lenovo/thinkpad/e14/amd;
      lenovo-thinkpad-e14-intel = import ./lenovo/thinkpad/e14/intel;
      lenovo-thinkpad-e470 = import ./lenovo/thinkpad/e470;
      lenovo-thinkpad-e495 = import ./lenovo/thinkpad/e495;
      lenovo-thinkpad-l13 = import ./lenovo/thinkpad/l13;
      lenovo-thinkpad-l13-yoga = import ./lenovo/thinkpad/l13/yoga;
      lenovo-thinkpad-l14-amd = import ./lenovo/thinkpad/l14/amd;
      lenovo-thinkpad-l14-intel = import ./lenovo/thinkpad/l14/intel;
      lenovo-thinkpad-l480 = import ./lenovo/thinkpad/l480;
      lenovo-thinkpad-p1 = import ./lenovo/thinkpad/p1;
      lenovo-thinkpad-p1-gen3 = import ./lenovo/thinkpad/p1/3th-gen;
      lenovo-thinkpad-p14s-amd-gen1 = import ./lenovo/thinkpad/p14s/amd/gen1;
      lenovo-thinkpad-p14s-amd-gen2 = import ./lenovo/thinkpad/p14s/amd/gen2;
      lenovo-thinkpad-p14s-amd-gen3 = import ./lenovo/thinkpad/p14s/amd/gen3;
      lenovo-thinkpad-p14s-amd-gen4 = import ./lenovo/thinkpad/p14s/amd/gen4;
      lenovo-thinkpad-p16s-amd-gen1 = import ./lenovo/thinkpad/p16s/amd/gen1;
      lenovo-thinkpad-p50 = import ./lenovo/thinkpad/p50;
      lenovo-thinkpad-p51 = import ./lenovo/thinkpad/p51;
      lenovo-thinkpad-p52 = import ./lenovo/thinkpad/p52;
      lenovo-thinkpad-p53 = import ./lenovo/thinkpad/p53;
      lenovo-thinkpad-t14 = import ./lenovo/thinkpad/t14;
      lenovo-thinkpad-t14-amd-gen1 = import ./lenovo/thinkpad/t14/amd/gen1;
      lenovo-thinkpad-t14-amd-gen2 = import ./lenovo/thinkpad/t14/amd/gen2;
      lenovo-thinkpad-t14-amd-gen3 = import ./lenovo/thinkpad/t14/amd/gen3;
      lenovo-thinkpad-t14-amd-gen4 = import ./lenovo/thinkpad/t14/amd/gen4;
      lenovo-thinkpad-t14s = import ./lenovo/thinkpad/t14s;
      lenovo-thinkpad-t14s-amd-gen1 = import ./lenovo/thinkpad/t14s/amd/gen1;
      lenovo-thinkpad-t14s-amd-gen4 = import ./lenovo/thinkpad/t14s/amd/gen4;
      lenovo-thinkpad-t410 = import ./lenovo/thinkpad/t410;
      lenovo-thinkpad-t420 = import ./lenovo/thinkpad/t420;
      lenovo-thinkpad-t430 = import ./lenovo/thinkpad/t430;
      lenovo-thinkpad-t440p = import ./lenovo/thinkpad/t440p;
      lenovo-thinkpad-t440s = import ./lenovo/thinkpad/t440s;
      lenovo-thinkpad-t450s = import ./lenovo/thinkpad/t450s;
      lenovo-thinkpad-t460 = import ./lenovo/thinkpad/t460;
      lenovo-thinkpad-t460p = import ./lenovo/thinkpad/t460p;
      lenovo-thinkpad-t460s = import ./lenovo/thinkpad/t460s;
      lenovo-thinkpad-t470s = import ./lenovo/thinkpad/t470s;
      lenovo-thinkpad-t480 = import ./lenovo/thinkpad/t480;
      lenovo-thinkpad-t480s = import ./lenovo/thinkpad/t480s;
      lenovo-thinkpad-t490 = import ./lenovo/thinkpad/t490;
      lenovo-thinkpad-t495 = import ./lenovo/thinkpad/t495;
      lenovo-thinkpad-t520 = import ./lenovo/thinkpad/t520;
      lenovo-thinkpad-w520 = import ./lenovo/thinkpad/w520;
      lenovo-thinkpad-t550 = import ./lenovo/thinkpad/t550;
      lenovo-thinkpad-t590 = import ./lenovo/thinkpad/t590;
      lenovo-thinkpad-x1 = import ./lenovo/thinkpad/x1;
      lenovo-thinkpad-x1-yoga = import ./lenovo/thinkpad/x1/yoga;
      lenovo-thinkpad-x1-yoga-7th-gen = import ./lenovo/thinkpad/x1/yoga/7th-gen;
      lenovo-thinkpad-x1-6th-gen = import ./lenovo/thinkpad/x1/6th-gen;
      lenovo-thinkpad-x1-7th-gen = import ./lenovo/thinkpad/x1/7th-gen;
      lenovo-thinkpad-x1-9th-gen = import ./lenovo/thinkpad/x1/9th-gen;
      lenovo-thinkpad-x1-10th-gen = import ./lenovo/thinkpad/x1/10th-gen;
      lenovo-thinkpad-x1-11th-gen = import ./lenovo/thinkpad/x1/11th-gen;
      lenovo-thinkpad-x1-extreme = import ./lenovo/thinkpad/x1-extreme;
      lenovo-thinkpad-x1-extreme-gen2 = import ./lenovo/thinkpad/x1-extreme/gen2;
      lenovo-thinkpad-x1-extreme-gen4 = import ./lenovo/thinkpad/x1-extreme/gen4;
      lenovo-thinkpad-x1-nano = import ./lenovo/thinkpad/x1-nano;
      lenovo-thinkpad-x1-nano-gen1 = import ./lenovo/thinkpad/x1-nano/gen1;
      lenovo-thinkpad-x13 = import ./lenovo/thinkpad/x13/intel;
      lenovo-thinkpad-x13-amd = import ./lenovo/thinkpad/x13/amd;
      lenovo-thinkpad-x13-yoga = import ./lenovo/thinkpad/x13/yoga;
      lenovo-thinkpad-x13-yoga-3th-gen = import ./lenovo/thinkpad/x13/yoga/3th-gen;
      lenovo-thinkpad-x140e = import ./lenovo/thinkpad/x140e;
      lenovo-thinkpad-x200s = import ./lenovo/thinkpad/x200s;
      lenovo-thinkpad-x220 = import ./lenovo/thinkpad/x220;
      lenovo-thinkpad-x230 = import ./lenovo/thinkpad/x230;
      lenovo-thinkpad-x250 = import ./lenovo/thinkpad/x250;
      lenovo-thinkpad-x260 = import ./lenovo/thinkpad/x260;
      lenovo-thinkpad-x270 = import ./lenovo/thinkpad/x270;
      lenovo-thinkpad-x280 = import ./lenovo/thinkpad/x280;
      lenovo-thinkpad-x390 = import ./lenovo/thinkpad/x390;
      lenovo-thinkpad-z = import ./lenovo/thinkpad/z;
      lenovo-thinkpad-z13-gen1 = import ./lenovo/thinkpad/z/gen1/z13;
      lenovo-thinkpad-z13-gen2 = import ./lenovo/thinkpad/z/gen2/z13;
      lenovo-yoga-6-13ALC6 = import ./lenovo/yoga/6/13ALC6;
      lenovo-yoga-7-14ARH7 = import ./lenovo/yoga/7/14ARH7;
      lenovo-yoga-7-slim-gen8 = import ./lenovo/yoga/7/slim/gen8;
      letsnote-cf-lx4 = import ./panasonic/letsnote/cf-lx4;
      microchip-icicle-kit = import ./microchip/icicle-kit;
      microsoft-surface-go = import ./microsoft/surface/surface-go;
      microsoft-surface-pro-intel = import ./microsoft/surface/surface-pro-intel;
      microsoft-surface-laptop-amd = import ./microsoft/surface/surface-laptop-amd;
      microsoft-surface-common = import ./microsoft/surface/common;
      microsoft-surface-pro-3 = import ./microsoft/surface-pro/3;
      microsoft-surface-pro-9 = import ./microsoft/surface-pro/9;
      milkv-pioneer = import ./milkv/pioneer;
      morefine-m600 = import ./morefine/m600;
      msi-b350-tomahawk = import ./msi/b350-tomahawk;
      msi-b550-a-pro = import ./msi/b550-a-pro;
      msi-gs60 = import ./msi/gs60;
      msi-gl62 = import ./msi/gl62;
      nxp-imx8mp-evk = import ./nxp/imx8mp-evk;
      nxp-imx8mq-evk = import ./nxp/imx8mq-evk;
      nxp-imx8qm-mek = import ./nxp/imx8qm-mek;
      hardkernel-odroid-hc4 = import ./hardkernel/odroid-hc4;
      hardkernel-odroid-h3 = import ./hardkernel/odroid-h3;
      omen-14-fb0798ng = import ./omen/14-fb0798ng;
      omen-15-en0010ca = import ./omen/15-en0010ca;
      omen-16-n0005ne = import ./omen/16-n0005ne;
      omen-15-en1007sa = import ./omen/15-en1007sa;
      omen-15-en0002np = import ./omen/15-en0002np;
      onenetbook-4 = import ./onenetbook/4;
      olimex-teres_i = import ./olimex/teres_i;
      pcengines-apu = import ./pcengines/apu;
      pine64-pinebook-pro = import ./pine64/pinebook-pro;
      pine64-rockpro64 = import ./pine64/rockpro64;
      pine64-star64 = import ./pine64/star64;
      protectli-vp4670 = import ./protectli/vp4670;
      purism-librem-13v3 = import ./purism/librem/13v3;
      purism-librem-15v3 = import ./purism/librem/15v3;
      purism-librem-5r4 = import ./purism/librem/5r4;
      raspberry-pi-2 = import ./raspberry-pi/2;
      raspberry-pi-3 = import ./raspberry-pi/3;
      raspberry-pi-4 = import ./raspberry-pi/4;
      raspberry-pi-5 = import ./raspberry-pi/5;
      kobol-helios4 = import ./kobol/helios4;
      samsung-np900x3c = import ./samsung/np900x3c;
      starfive-visionfive-v1 = import ./starfive/visionfive/v1;
      starfive-visionfive-2 = import ./starfive/visionfive/v2;
      supermicro = import ./supermicro;
      supermicro-a1sri-2758f = import ./supermicro/a1sri-2758f;
      supermicro-m11sdv-8c-ln4f = import ./supermicro/m11sdv-8c-ln4f;
      supermicro-x10sll-f = import ./supermicro/x10sll-f;
      supermicro-x12scz-tln4f = import ./supermicro/x12scz-tln4f;
      system76 = import ./system76;
      system76-gaze18 = import ./system76/gaze18;
      system76-darp6 = import ./system76/darp6;
      toshiba-swanky = import ./toshiba/swanky;
      tuxedo-infinitybook-v4 = import ./tuxedo/infinitybook/v4;
      tuxedo-infinitybook-pro14-gen7 = import ./tuxedo/infinitybook/pro14/gen7;
      tuxedo-pulse-14-gen3 = import ./tuxedo/pulse/14/gen3;
      tuxedo-pulse-15-gen2 = import ./tuxedo/pulse/15/gen2;

      common-cpu-amd = import ./common/cpu/amd;
      common-cpu-amd-pstate = import ./common/cpu/amd/pstate.nix;
      common-cpu-amd-zenpower = import ./common/cpu/amd/zenpower.nix;
      common-cpu-amd-raphael-igpu = import ./common/cpu/amd/raphael/igpu.nix;
      common-cpu-intel = import ./common/cpu/intel;
      common-cpu-intel-comet-lake = import ./common/cpu/intel/comet-lake;
      common-cpu-intel-cpu-only = import ./common/cpu/intel/cpu-only.nix;
      common-cpu-intel-kaby-lake = import ./common/cpu/intel/kaby-lake;
      common-cpu-intel-sandy-bridge = import ./common/cpu/intel/sandy-bridge;
      common-gpu-amd = import ./common/gpu/amd;
      common-gpu-amd-sea-islands = import ./common/gpu/amd/sea-islands;
      common-gpu-amd-southern-islands = import ./common/gpu/amd/southern-islands;
      common-gpu-intel = import ./common/gpu/intel;
      common-gpu-intel-disable = import ./common/gpu/intel/disable.nix;
      common-gpu-nvidia = import ./common/gpu/nvidia/prime.nix;
      common-gpu-nvidia-sync = import ./common/gpu/nvidia/prime-sync.nix;
      common-gpu-nvidia-nonprime = import ./common/gpu/nvidia;
      common-gpu-nvidia-disable = import ./common/gpu/nvidia/disable.nix;
      common-hidpi = import ./common/hidpi.nix;
      common-pc = import ./common/pc;
      common-pc-hdd = import ./common/pc/hdd;
      common-pc-laptop = import ./common/pc/laptop;
      common-pc-laptop-acpi_call = import ./common/pc/laptop/acpi_call.nix;
      common-pc-laptop-hdd = import ./common/pc/laptop/hdd;
      common-pc-laptop-ssd = import ./common/pc/ssd;
      common-pc-ssd = import ./common/pc/ssd;
    };
  };
}
