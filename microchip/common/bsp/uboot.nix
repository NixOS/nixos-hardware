{
  pkgs, targetBoard, ...
}:

with pkgs; let
  payload-generator = pkgs.callPackage ./hss-payload-generator.nix {};
  payload_config = ./uboot.yaml;
in
buildUBoot rec {
  pname = "uboot";
  version = "linux4microchip+fpga-2023.02";

  src = fetchFromGitHub {
    owner = "polarfire-soc";
    repo = "u-boot";
    rev = "b356a897b11ef19dcbe7870530f23f3a978c1714";
    sha256 = "sha256-ouNLnDBeEsaY/xr5tAVBUtLlj0eylWbKdlU+bQ2Ciq4=";
  };

  extraMakeFlags = [
          "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  patches = [ ./patches/0001-Boot-environment-for-Microchip-Iciclle-Kit.patch ];
  defconfig = "${targetBoard}_defconfig";
  enableParallelBuilding = true;
  extraMeta.platforms = ["riscv64-linux"];
  postBuild = ''
        ${payload-generator}/hss-payload-generator -c ${payload_config} payload.bin
        '';
  filesToInstall = [ "payload.bin" ];
}
