{
  imports = [
    ../../common/pc
    ../../common/pc/ssd
    ../../common/cpu/amd/pstate.nix
  ];

  boot.kernelModules = [
    # Nuvoton NCT6798D - temperature, voltage and RPM
    "nct6775"

    # a single "temp1" sensor, always at "+31.9°C"
    # commented because it's not useful, but left here for reference
    # Bus `SMBus PIIX4 adapter port 1 at 0b20'
    # Busdriver `i2c_piix4', I2C address 0x4f
    # Chip `ds75'
    # "lm75"
  ];
}
