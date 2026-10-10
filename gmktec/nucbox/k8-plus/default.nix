{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/ssd
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Define custom ALSA Card Profile for mini PC chassis without phantom internal speaker/mic
  environment.etc."alsa-card-profile/mixer/profile-sets/gmktec-nucbox-k8-plus-k11.conf".text = ''
    [General]
    auto-profiles = yes

    [Mapping analog-stereo]
    device-strings = front:%f
    channel-map = left,right
    paths-output = analog-output-headphones
    paths-input = analog-input-headphone-mic analog-input-headset-mic analog-input-mic
    priority = 15
  '';

  # Assign profile set to onboard Realtek audio controller so unplugged 3.5mm jack is marked unavailable
  services.pipewire.wireplumber.extraConfig."50-gmktec-nucbox-k8-plus-k11-audio" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "device.name" = "~alsa_card.pci.*";
            "device.product.id" = "0x15e3";
          }
        ];
        actions = {
          update-props = {
            "device.profile-set" = "gmktec-nucbox-k8-plus-k11.conf";
          };
        };
      }
    ];
  };
}
