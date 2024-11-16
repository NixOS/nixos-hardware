{lib, config, ...}:
let
  nvidiaPackage = config.hardware.nvidia.package;
in
{
  imports = [ ../. ];

  # enable the open source drivers if the package supports it
  hardware.nvidia.open = lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);

  # nvidia's hibernate, suspend, and resume services are not normally triggered on suspend-then-hibernate and hybrid-hibernate
  systemd.services = {
    nvidia-hibernate = {
      before = [ "systemd-suspend-then-hibernate.service" ];
      wantedBy = [ "suspend-then-hibernate.target" ];
    };

    nvidia-suspend = {
      before = [ "systemd-hybrid-sleep.service" ];
      wantedBy = [ "hybrid-sleep.target" ];
    };

    nvidia-resume = {
      after = [ "systemd-suspend-then-hibernate.service" "systemd-hybrid-sleep.service" ];
      wantedBy = [ "post-resume.target" ];
    };
  };
}
