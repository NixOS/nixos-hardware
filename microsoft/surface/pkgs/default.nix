{ callPackage }:
{
  kernel-stable = callPackage ./kernel {
    kernelVersion = "stable";
  };

  kernel-longterm = callPackage ./kernel {
    kernelVersion = "longterm";
  };
}
