# The x550 supports 5G but the driver does not enable it by default
# https://forum.proxmox.com/threads/x550-x550-t2-duplex-auto-negotiation.116776/
{
  systemd.network.links."80-x550" = {
    matchConfig = {
      Driver = "ixgbe";
      Property = [
        "ID_MODEL_ID=0x1563"
        "ID_VENDOR_ID=0x8086"
      ];
    };
    linkConfig.Advertise = [
      "100baset-full"
      "1000baset-full"
      "2500baset-full"
      "5000baset-full"
      "10000baset-full"
    ];
    linkConfig.NamePolicy = [
      "keep"
      "kernel"
      "database"
      "onboard"
      "slot"
      "path"
    ];
    linkConfig.AlternativeNamesPolicy = [
      "database"
      "onboard"
      "slot"
      "path"
      "mac"
    ];
    linkConfig.MACAddressPolicy = "persistent";
  };
}
