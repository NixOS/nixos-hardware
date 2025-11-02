{ pkgs }:
pkgs.callPackage ../../common/bsp/imx-optee-builder.nix {
  pname = "imx93-optee-os";
  version = "lf-6.12.3_1.0.0";

  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-optee-os.git";
    rev = "8dd180b6d149c1e1314b5869697179f665bd9ca3";
    sha256 = "sha256-PoolRscdyeGevrOa5YymPTQ36edVvReMM5WshRTz+uk=";
  };

  platformFlavor = "imx-mx93evk";

  meta = {
    maintainers = with pkgs.lib.maintainers; [ govindsi ];
  };
}
