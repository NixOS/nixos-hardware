{ config, lib, ... }:
lib.mkIf config.hardware.raspberry-pi."4".enable {
  hardware.deviceTree.overlays = [{
    name = "rpi4-cpu-revision";
    dtsText = ''
      /dts-v1/;
      /plugin/;

      / {
        compatible = "raspberrypi,4-model-b";

        fragment@0 {
          target-path = "/";
          __overlay__ {
            system {
              linux,revision = <0x00d03114>;
            };
          };
        };
      };
    '';
  }];
}
