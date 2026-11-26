{
  config,
  lib,
  pkgs,
  ...
}:

# Reliable reboot for the MT7988, plus an OPT-IN diagnostic SMC device.
#
# WHY
# ---
# PSCI SYSTEM_RESET works on this board: mtk_plat_system_reset() sets
# WDT_SWSYSRST_EN before WDT_SWRST (see ./patches/), and hardware confirms the
# SoC resets and returns.  What is unreliable is the kernel's route to it --
# the request is sometimes never carried out and the box needs the cord pulled.
#
# So /dev/reboot lets a unit issue exactly that call, at the one safe moment in
# shutdown.
#
# THE TWO DEVICES ARE NOT THE SAME
# --------------------------------
#   /dev/reboot  -- always built.  Accepts SYSTEM_RESET / SYSTEM_OFF and
#                   nothing else: no function number, no arguments.  It cannot
#                   express an arbitrary SMC, so installing it adds no attack
#                   surface beyond the reboot(2) syscall that already exists.
#
#   /dev/smc     -- OPT-IN, OFF BY DEFAULT.  Issues SMC #0 with a caller-chosen
#                   function id and six arguments.  That is a genuine
#                   root -> EL3 hole: BL31 dispatches MediaTek's SIP range
#                   without validation, and those handlers touch eFuses, devapc
#                   and secure-boot state, so a wrong call can brick the SoC
#                   permanently.  It exists for diagnosis only (it is how the
#                   reset behaviour above was measured); never enable it on a
#                   machine you are not actively debugging.
#
# SSD SAFETY (reboot device)
# --------------------------
#   after  = [ "umount.target" "final.target" ]
#   before = [ "systemd-reboot.service" ]
#
# systemd-reboot.service itself runs After=shutdown.target umount.target
# final.target.  Both have completed by the time this unit runs, so every
# filesystem is unmounted or read-only and sync(2) has happened -- cutting the
# SoC here cannot lose writes.  Ordering this any earlier (e.g. at
# shutdown.target) would reset a mounted, dirty btrfs and is NOT safe.
#
# SCOPE: reboot only.  PSCI SYSTEM_OFF is a panic() stub in this ATF
#
#     static void __dead2 mtk_plat_system_off(void)
#     {
#             ERROR("MTK System Off: operation not handled.\n");
#             panic();
#     }
#
# so `poweroff` still needs BL31 to drive the PMIC; userspace cannot fix it.
# The unit is bound to reboot.target only, so poweroff is left alone rather
# than silently turned into a reboot.
let
  cfg = config.hardware.bananapi.bpi-r4-pro;
  kernel = config.boot.kernelPackages.kernel;

  moduleVersion = "1";

  # Sources only: *.nix must not end up inside the module build tree.
  src = pkgs.runCommandLocal "bpi-r4-pro-smc-src" { } ''
    mkdir -p $out
    cp ${./dev_reboot.c} $out/dev_reboot.c
    cp ${./dev_smc.c} $out/dev_smc.c
    cp ${./smcctl.c} $out/smcctl.c
    cp ${./rebootctl.c} $out/rebootctl.c
    cp ${./Makefile} $out/Makefile
  '';

  buildIt =
    pname: tools: extra:
    pkgs.stdenvNoCC.mkDerivation ({
      inherit pname src;
      version = moduleVersion;

      nativeBuildInputs = [
        pkgs.gnumake
        pkgs.gcc
        pkgs.binutils
      ];

      buildPhase = ''
        runHook preBuild
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD ${pname}.ko
        # The userspace tools are NOT kernel modules and the kbuild Makefile
        # (obj-m only) never produces them.  Compile them here with the stdenv
        # toolchain; without this the install below failed with
        #   install: cannot stat 'rebootctl'
        # which broke the whole s-nodus closure on the kernel-modules chain.
        ${lib.concatMapStringsSep "\n" (t: ''
          $CC -O2 -Wall -o ${t} ${t}.c
        '') tools}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm644 ${pname}.ko \
          $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/${pname}.ko
        ${extra}
        runHook postInstall
      '';
    });

  # Restricted: no arguments, two verb choices.  Safe to install permanently.
  devReboot = buildIt "dev_reboot" [ "rebootctl" ] ''
    install -Dm755 rebootctl $out/bin/rebootctl
  '';

  # Unrestricted: arbitrary SMC.  Diagnostic only, opt-in.
  devSmc = buildIt "dev_smc" [ "smcctl" ] ''
    install -Dm755 smcctl $out/bin/smcctl
  '';
in
{
  options.hardware.bananapi.bpi-r4-pro = {
    # Restoring a dead board is a hands-on job, so this stays opt-in.
    smcReboot.enable = lib.mkEnableOption ''
      the /dev/reboot device and a shutdown unit that resets the MT7988 via PSCI
      instead of relying on the kernel's own reset path
    '';

    smcDevice = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Install /dev/smc, which issues an SMC with a CALLER-CHOSEN function
          id and six arguments.

          SECURITY: this is a root -> EL3 hole.  BL31 dispatches MediaTek's SIP
          function range without validating arguments, and those handlers
          touch eFuses, devapc and secure-boot state -- a wrong call can brick
          the SoC permanently, beyond recovery from the SD card.

          It exists for diagnosing BL31 behaviour.  Enable it only while
          actively debugging, and build it by hand (see hardware-tools/dev-smc)
          rather than leaving it in a generation.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.smcReboot.enable {
        boot.extraModulePackages = [ devReboot ];
        boot.kernelModules = [ "dev_reboot" ];

        systemd.services.mt7988-smc-reboot = {
          description = "Reset the MT7988 via BL31 after filesystems are down";
          wantedBy = [ "reboot.target" ];
          after = [
            "umount.target"
            "final.target"
          ];
          before = [ "systemd-reboot.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${devReboot}/bin/rebootctl reset";
            # The SMC does not return on success; if it does, do not hold up the
            # normal path for long.
            TimeoutStartSec = "20s";
          };
        };
      })

      (lib.mkIf cfg.smcDevice.enable {
        warnings = [
          ''
            hardware.bananapi.bpi-r4-pro.smcDevice is enabled: /dev/smc accepts an
            arbitrary SMC function id from root and forwards it to BL31.  A wrong
            call can permanently brick the SoC (eFuse/devapc are reachable through
            MediaTek's SIP range).  Disable this outside active debugging.
          ''
        ];
        boot.extraModulePackages = [ devSmc ];
        boot.kernelModules = [ "dev_smc" ];
        environment.systemPackages = [ devSmc ];
      })
    ]
  );
}
