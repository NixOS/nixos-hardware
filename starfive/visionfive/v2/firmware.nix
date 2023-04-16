{ callPackage, runCommand, writeText, stdenv, dtc }:
let
  uboot = callPackage ./uboot.nix { };
  opensbi = callPackage ./opensbi.nix {
    withPayload = "${uboot}/u-boot.bin";
    withFDT = "${uboot}/starfive_visionfive2.dtb";
  };
  spl-tool = callPackage ./spl-tool.nix { };
  its-file = writeText "visionfive2-uboot-fit-image.its" ''
    /dts-v1/;

    / {
      description = "U-boot-spl FIT image for JH7110 VisionFive2";
      #address-cells = <2>;

      images {
        firmware {
          description = "u-boot";
          data = /incbin/("${opensbi}/share/opensbi/lp64/generic/firmware/fw_payload.bin");
          type = "firmware";
          arch = "riscv";
          os = "u-boot";
          load = <0x0 0x40000000>;
          entry = <0x0 0x40000000>;
          compression = "none";
        };
      };

      configurations {
        default = "config-1";

        config-1 {
          description = "U-boot-spl FIT config for JH7110 VisionFive2";
          firmware = "firmware";
        };
      };
    };
  '';
in {
  inherit opensbi uboot;
  spl = runCommand "starfive-visionfive2-spl" { } ''
    mkdir -p $out/share/starfive-visionfive2/
    ln -s ${uboot}/u-boot-spl.bin .
    ${spl-tool}/bin/spl_tool -c -f ./u-boot-spl.bin
    cp u-boot-spl.bin.normal.out $out/share/starfive-visionfive2/spl.bin
  '';
  uboot-fit-image = stdenv.mkDerivation {
    name = "starfive-visionfive2-uboot-fit-image";
    nativeBuildInputs = [ dtc ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/starfive-visionfive2/
      ${uboot}/mkimage -f ${its-file} -A riscv -O u-boot -T firmware $out/share/starfive-visionfive2/visionfive2_fw_payload.img
    '';
  };
}
