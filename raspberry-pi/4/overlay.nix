{
  simple-pi4-overlay = { target, status }: {
    name = "${target}-${status}-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
          target = <&${target}>;
          __overlay__ {
            status = "${status}";
          };
        };
      };
    '';
  };
}
