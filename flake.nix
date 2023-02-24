{
  description = "nixos-hardware";

  outputs = _:
    let
      recurse = segments:
        let
          dir = builtins.concatStringsSep "/" ([ ./. ] ++ segments);
          stat = builtins.readDir dir;
          f = acc: name:
            if stat.${name} == "directory" then
              acc // recurse (segments ++ [ name ])
            else if name == "default.nix" && segments != [ ] then
              acc // {
                "${builtins.concatStringsSep "-" segments}" = dir;
              }
            else
              acc;
        in
        builtins.foldl' f { } (builtins.attrNames stat);

      modules = recurse [ ];
    in
    {
      nixosModules = modules // {
        # Backwards compatibility
        asus-battery = import ./asus/battery.nix;
        common-cpu-amd-pstate = import ./common/cpu/amd/pstate.nix;
        common-cpu-intel-cpu-only = import ./common/cpu/intel/cpu-only.nix;
        common-gpu-intel = import ./common/gpu/intel.nix;
        common-gpu-nvidia = import ./common/gpu/nvidia/prime.nix;
        common-gpu-nvidia-disable = import ./common/gpu/nvidia/disable.nix;
        common-gpu-nvidia-nonprime = import ./common/gpu/nvidia;
        common-pc-laptop-acpi_call = import ./common/pc/laptop/acpi_call.nix;
        common-pc-laptop-ssd = import ./common/pc/ssd;
        lenovo-legion-y530-15ich = import ./lenovo/legion/15ich;
        lenovo-thinkpad-p1-gen3 = import ./lenovo/thinkpad/p1/3th-gen;
        lenovo-thinkpad-z13 = import ./lenovo/thinkpad/z/z13;
        letsnote-cf-lx4 = import ./panasonic/letsnote/cf-lx4;
        microsoft-surface-go = import ./microsoft/surface/surface-go;
        microsoft-surface-laptop-amd = import ./microsoft/surface/surface-laptop-amd;
        microsoft-surface-pro-intel = import ./microsoft/surface/surface-pro-intel;
        purism-librem-15v3 = import ./purism/librem/15v3;
      };
    };
}
