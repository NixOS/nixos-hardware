{
  pkgs,
  targetBoard,
  ...
}:

with pkgs;
let
  payload-generator = pkgs.callPackage ./hss-payload-generator.nix { };
  payload_config = ./uboot.yaml;
in
buildUBoot rec {
  pname = "uboot";
  version = "linux4microchip+fpga-2023.09";

  src = fetchFromGitHub {
    owner = "polarfire-soc";
    repo = "u-boot";
    # from mpfs-uboot-2022.01 branch
    rev = "8f5e331e3f09cdf469d528905f5d6a7139016634";
    sha256 = "sha256-UElnkRgzcvTjAo5X9N8c1fCTrTxdpAGkntcpQlqgDy8=";
  };

  extraMakeFlags = [
    "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  patches = [
    ./patches/0001-Boot-environment-for-Microchip-Iciclle-Kit.patch
  ];
  defconfig = "${targetBoard}_defconfig";
  enableParallelBuilding = true;
  extraMeta.platforms = [ "riscv64-linux" ];
  postBuild = ''
    ${payload-generator}/hss-payload-generator -c ${payload_config} payload.bin
  '';
  filesToInstall = [ "payload.bin" ];
}
