{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "poe-hat"
      ]
      ''
        Use the stock rpi-poe firmware overlay instead:

          hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
            {
              rpi-poe = {
                poe_fan_temp0 = 40000;
                poe_fan_temp0_hyst = 2000;
                poe_fan_temp1 = 45000;
                poe_fan_temp1_hyst = 2000;
                poe_fan_temp2 = 50000;
                poe_fan_temp2_hyst = 2000;
                poe_fan_temp3 = 55000;
                poe_fan_temp3_hyst = 5000;
              };
            }
          ];

        These are the overlay defaults. Parameters that were not customized can
        be omitted.
      ''
    )
  ];
}
