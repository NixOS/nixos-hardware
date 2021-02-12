{ pkgs, kernel }:

pkgs.stdenv.mkDerivation rec {
  name = "mbp-bridge";
  version = "b43fcc069da73e051072fde24af4014c9c487286";

  src = pkgs.fetchFromGitHub {
    owner = "MCMrARM";
    repo = "mbp2018-bridge-drv";
    rev = version;
    sha256 = "0ac2l51ybfrvg8m36x67rsvgjqs1vwp7c89ssvbjkrcq3y4qdb53";
  };

  sourceRoot = "source";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  postUnpack = ''
    chmod -R +rw source
  '';

  buildPhase = ''
    echo 'obj-m += bce.o
bce-objs := pci.o mailbox.o queue.o queue_dma.o vhci/vhci.o vhci/queue.o vhci/transfer.o audio/audio.o audio/protocol.o audio/protocol_bce.o audio/pcm.o' > Makefile
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd) modules
  '';

  installPhase = ''
   mkdir -p $out/lib/modules/${kernel.modDirVersion}
   cp *.ko $out/lib/modules/${kernel.modDirVersion}
  '';

}
