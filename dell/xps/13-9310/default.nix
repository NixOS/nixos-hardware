{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # TODO: upstream to NixOS/nixpkgs
  nixpkgs.overlays = [(final: previous: {
    qca6390-firmware = final.callPackage ./qca6390-firmware.nix {};
  })];

  hardware.firmware = lib.mkBefore [
    # Firmware for the AX500 (wi-fi & bluetooth chip).
    pkgs.qca6390-firmware
  ];

  # The QCA6390 driver currently requires a specific version of the kernel
  # along with a particular set of patches to build.
  # Kvalo's ath11k-qca6390-bringup branch is currently based on `5.10-rc4`.
  # TODO: Remove this once patches landed in kernel.
  boot.kernelPackages = let
    linux_patched_pkg = { buildLinux, fetchurl, modDirVersionArg ? null, ... }@args:
      buildLinux (args // rec {
        version = "5.10-rc4";
        extraMeta.branch = "5.10";
        modDirVersion = if (modDirVersionArg == null) then
          builtins.replaceStrings [ "-" ] [ ".0-" ] version
        else
          modDirVersionArg;
        src = fetchurl {
          url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
          sha256 = "1fc68lka76n1dygyn914c4vhxqzwv951pp4kdkrr0jv5nvdnyplb";
        };
        kernelPatches = [
          # kvalo qca6390 patches
          # https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=ath11k-qca6390-bringup
          {
            name = "add-64-bit-check-before-reading-msi-high-addr";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=065c9528cc508cfbf6e3399582df29f76f56163c";
              sha256 = "1mqhwags919vlxllzqh5kj4b2l869swvfwa89jk804a1l4l02fmv";
            };
          }
          {
            name = "pci-support-platforms-with-one-msi-vector";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=59c6d022df8efb450f82d33dd6a6812935bd022f";
              sha256 = "0sxbb58bnryb9hic1cyc8dzrzachhca7a6hywyzz1pksh9syhs5y";
            };
          }
          {
            name = "try-to-allocate-big-block-of-dma-memory-firstly";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=0d8b0aff6b77ea5a8d715ba5d0089f9dffbabf21";
              sha256 = "120zqivqhs5080b64h62x69svi6bq02scgnkswa0hbvdncsy63y8";
            };
          }
          {
            name = "fix-monitor-status-dma-unmap-direction";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=fa4eea695afb286ae38beb30dabf251335cb4a62";
              sha256 = "1sh3d8ck4nlg671j2y8f07394xrqlnbrvh9rmy4l1zfpz7wa7d10";
            };
          }
          {
            name = "hook-mhi-suspend-and-resume";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=762fe5bc2dd1e43ef307a375861b1a8c414b14e3";
              sha256 = "154p8gp4smmmkhyx127f6rib04xd5bn38a3n4893rbyyb5kckv40";
            };
          }
          {
            name = "implement-hif-suspend-and-resume-functions";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=2f164833bcca14e8aec0b2566eae4b5a7d09ee6f";
              sha256 = "1ic968y1ivlgfhbj67ds809zqas7n50kc6wb8jgksk227dvagnip";
            };
          }
          {
            name = "read-select_window-register-to-ensure-write-is-finished";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=6afab932ece78fedc1538c20c2aefdd13aa6c9d0";
              sha256 = "19jiz9mf868rj57ljjdb3n97sfi6x78ac9kgd7fhg1bh0zjjiskp";
            };
          }
          {
            name = "implement-htc-suspend-related-callbacks";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=69ab2835b82c176e793195243e1400d4f8db3647";
              sha256 = "1gba5h0s6c6zjplw8zyqc2qj21ly1m2xzbgznml159wzj2xvzb2m";
            };
          }
          {
            name = "put-target-to-suspend-when-system-enters-suspend-state";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=68023bee4d61ea2b02af49bba00adabba51d8b6b";
              sha256 = "05aqdjd5xps0wncrh41r805fn2rpnhw53pn02a374g81bbifwa5q";
            };
          }
          {
            name = "pci-print-a-warning-if-firmware-crashed";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=23dcef9436560a033703164c4daff9e36e640969";
              sha256 = "0m45wvilr2cgdkpdjzcz4hdzsfs596ibjsvd7sdksjbrp5wslla1";
            };
          }
          {
            name = "qmi-print-allocated-memory-segment-addresses-and-sizes";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=a327caa4a5a677161a6f1d29514e8cb42236e956";
              sha256 = "1id6xz7siw1x2xa00psqvr4h5zb0xd83apy0cyv4jqzkd5x1kwl0";
            };
          }
          {
            name = "hack-add-delays-to-suspend-and-resume-handlers";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=a9ce8040a968bdbb5aad2d767298d390e2507b16";
              sha256 = "02chzhmkkxl4rxkp5vmab9sm218jggns1yanhqkfkpvdpzlz2dlg";
            };
          }

          {
            name = "put-hw-to-dbs-using-mode";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=ce8b5dfc16a0b84ac9ab2d508c2d5e66e8bf179a";
              sha256 = "0gcnzn82mjdqy3ly494xfawqb9xvwd01dcdr43cw8ik92jggs4sf";
            };
          }
          {
            name = "fix-pcie-link-unstable-issue";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=a82a3aee7cde95d533c28cad3749e3c354011896";
              sha256 = "0r26g7j7kkm76bippp79vd462ykc8k8p0bxr7pshhkyazs6v1ij3";
            };
          }
          {
            name = "fix-pci-l1ss-clock-unstable-problem";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=08816aab67540e6babc558dafa973fc905a9afa1";
              sha256 = "180hp6iwgw7cqiiwhp9cnzwr5z9n26pphi2j693x751crzr0xkzw";
            };
          }
          {
            name = "disable-otp-write-privilege";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=86c5a1d6983e647a55448c80f94eb8f0aa97dfad";
              sha256 = "176g07kpsqnkc3vpfx2lhlrksmdg05m0zxn1i5yfvksczp2215iq";
            };
          }
          {
            name = "disable-aspm-l0sls-before-downloading-firmware";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=8bd374e3305359ca0be9fe88e8a1edc1abd537eb";
              sha256 = "1grjsf6jvn536cz6wil79l2lzc90ga1c7sisv9j0qac7jzr7x5rz";
            };
          }
          {
            name = "purge-rx-pktlog-when-entering-suspend";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=6f481de563dd108bd3df616c80e60f308b7a48e3";
              sha256 = "14qd1qv8v3mcslj7crzrw0ib1caa7vbnq7jkq163248658bbmk6p";
            };
          }
          {
            name = "set-credit_update-flag-for-flow-controlled-ep-only";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=6e0fba395a054cd58d87b3749f1f4ff2f3fef92e";
              sha256 = "0sgjxj6m3fdlgdfg7rv5fajfmbmrccy5asrammlgbc7gh5sn9ac4";
            };
          }
          {
            name = "implement-wow-enable-and-wow-wakeup-command";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=cfca935c92d8f2b31c95e7fd074645245f54492a";
              sha256 = "0dwbsqkw3f8v676s0x3jv04w0qk36ypvnwh02rx4qfdk38sh0j3j";
            };
          }
          {
            name = "add-ce-irq-enable-and-disable-hif-layer-functions";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=9297794a5d5af5e82b9554677f959add281a5b76";
              sha256 = "0hl93l8khh36drllxii969nvkb6p4hh28gnjyg0y10adm5q9b4ac";
            };
          }
          {
            name = "put-target-to-wow-state-when-suspend-happens";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=0c214f7ebce5eadb589554611bb927517c7aa7ea";
              sha256 = "0k4af5i12ghgviraig1zcm8b4fngws8wmhhn9w902nnn3miqy7sw";
            };
          }
          {
            name = "fix-incorrect-tlvs-in-scan-start-command";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=bfa226b7e2e988609631e7f6cd0d4e9ede423f6b";
              sha256 = "03qb5d0dm77l2ifmcy87p064qd55bg9kqx9nmxy6lrvz83crizpb";
            };
          }
          {
            name = "vdev-delete-sync-with-fw";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=c1d3ee50859a2d2c132a8461fdabde568df5ee20";
              sha256 = "1dscfdqv5x3h024gryh0464mky0j6z681rliiix17kdh172vxx52";
            };
          }
          {
            name = "peer-delete-sync-with-fw";
            patch = pkgs.fetchpatch {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=6244933ddba318b36bb00c48eeb8d63a24a901c2";
              sha256 = "0p1663w0lik44gwyfzmxxiwnc3s9n3p46aappla8pbfk9wdgw86d";
            };
          }

          # Patch for crash by w1nk.
          {
            name = "w1nk-irq-lock-patch";
            patch = pkgs.fetchpatch {
              url = "https://raw.githubusercontent.com/w1nk/ath11k-debug/master/one-irq-manage.patch";
              sha256 = "011db3h10smqy0ni0qr9mkyhykf1f3yq6yym6ysbb7jr7l51q0n9";
            };
          }
        ];
      } // (args.argsOverride or { }));
    linux_patched = pkgs.callPackage linux_patched_pkg { };
  in pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_patched);

  # Confirmed necessary to get audio working as of 2020-11-13:
  # https://bbs.archlinux.org/viewtopic.php?pid=1933643#p1933643
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # Touchpad goes over i2c.
  # Without this we get errors in dmesg on boot and hangs when shutting down.
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Allows for updating firmware via `fwupdmgr`.
  # services.fwupd.enable = true;
}
