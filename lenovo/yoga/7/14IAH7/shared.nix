/*
 * Here are configurations for the
 * Intel Core i7-12700H CPU, along
 * with a few others.
 */
{
  imports = [
    ../../../../common/cpu/intel/alder-lake
    ../../../../common/gpu/intel/alder-lake
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    # Info: <https://wiki.archlinux.org/title/Power_management#Active_State_Power_Management>
    kernelParams = [ "pcie_aspm.policy=powersupersave" ];
  };
}
