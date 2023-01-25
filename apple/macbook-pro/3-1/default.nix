{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # TODO: Change this to make Nouveau work if anyone ever figures out why it's broken.
  boot.kernelParams = [ "nomodeset" ];
}
