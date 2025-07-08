{
  warnings = [
    ''
      DEPRECATED: The <nixos-hardware/tuxedo/infinitybook/pro14/gen9-intel> module has been renamed to <nixos-hardware/tuxedo/infinitybook/pro14/gen9/intel>

      The gen9-intel module will be removed in a future release.
    ''
  ];

  imports = [ ../pro14/gen9/intel ];
}
