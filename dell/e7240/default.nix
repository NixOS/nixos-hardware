{
  imports = [
    ../latitude/e7240/default.nix
  ];

  warnings = [
    ''
      DEPRECATED: Importing dell/e7240 is deprecated. Use dell/latitude/e7240 instead.

      This module will be removed in a future release.
    ''
  ];
}
