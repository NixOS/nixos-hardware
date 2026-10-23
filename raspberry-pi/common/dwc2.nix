{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.dwc2;
  collectOtgModes =
    path: value:
    if builtins.isAttrs value then
      lib.concatLists (lib.mapAttrsToList (name: collectOtgModes (path ++ [ name ])) value)
    else
      lib.optional (lib.last path == "otg_mode") { inherit path value; };

  otgModes = collectOtgModes [ ] config.hardware.raspberry-pi.configtxt.settings;
  pi4Filters = [
    "all"
    "pi4"
    "cm4"
  ];
  onlyPi4Filters = setting: lib.all (section: lib.elem section pi4Filters) (lib.init setting.path);
  otherBoardFilters =
    setting:
    let
      filters = lib.init setting.path;
    in
    lib.any (
      section:
      lib.elem section [
        "pi2"
        "pi3"
        "pi5"
        "cm5"
      ]
    ) filters
    && !lib.any (
      section:
      lib.elem section [
        "pi4"
        "cm4"
      ]
    ) filters;
  usesXhci =
    setting:
    let
      values = lib.toList setting.value;
    in
    values != [ ]
    && lib.elem (lib.last values) [
      true
      1
      "1"
    ];
  optionPath =
    setting:
    lib.showOption (
      [
        "hardware"
        "raspberry-pi"
        "configtxt"
        "settings"
      ]
      ++ setting.path
    );
  assignment = setting: "${optionPath setting} = ${builtins.toJSON setting.value}";
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi.dwc2 = {
    enable = lib.mkEnableOption "the DWC2 USB controller through the firmware";
    dr_mode = lib.mkOption {
      type = lib.types.enum [
        "host"
        "peripheral"
        "otg"
      ];
      default = "otg";
      description = ''
        USB role for the DWC2 controller.
        The available connector depends on the board.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Omit FDT/FDTDIR so U-Boot keeps the firmware's DWC2 overlay.
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    hardware.raspberry-pi.configtxt = {
      settings.cm4.otg_mode = null;
      deviceTreeOverlays = lib.genAttrs [ "pi2" "pi3" "pi4" "pi5" ] (_: [
        { dwc2.dr_mode = cfg.dr_mode; }
      ]);
    };

    assertions = map (setting: {
      assertion = !usesXhci setting;
      message = ''
        DWC2 is enabled, but ${assignment setting} selects XHCI on the Raspberry Pi 4 family, including CM4.
        Remove that definition or set ${optionPath setting} = null.
      '';
    }) (lib.filter onlyPi4Filters otgModes);

    # Other filters can depend on hardware or boot state that Nix cannot inspect.
    warnings =
      map
        (setting: ''
          ${assignment setting} can select XHCI on the Raspberry Pi 4 family when its firmware filters match.
          DWC2 is enabled. If this definition applies to a board that uses DWC2, remove it.
        '')
        (
          lib.filter (
            setting: !onlyPi4Filters setting && !otherBoardFilters setting && usesXhci setting
          ) otgModes
        );
  };
}
