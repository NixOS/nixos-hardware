{
  # Print all logs to console for debug
  boot.kernelParams = [
    "systemd.journald.forward_to_console"
  ];

  # Enable AVF debug log
  avf.vmConfig.debugLevel = 1;

  # Allow the user to log in as root without a password.
  users.users.root.initialHashedPassword = "";

  # Automatically log in at the virtual consoles.
  services.getty.autologinUser = "droid";
}
