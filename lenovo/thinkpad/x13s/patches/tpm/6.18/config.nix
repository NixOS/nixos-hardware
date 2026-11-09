{ lib, ... }:
{
  structuredExtraConfig = lib.mapAttrs (_: lib.mkDefault) {
    TCG_QCOM_TPM_QSEE = lib.kernel.yes;
  };
}
