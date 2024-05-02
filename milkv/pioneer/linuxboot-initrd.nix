{ buildPackages
, fetchFromGitHub
, fetchpatch
, linux-firmware
, buildGoModule
, ...
}:

# Based on
# https://github.com/sophgo/bootloader-riscv/blob/e0839852d571df106db622611f4786ae17e8df0f/scripts/envsetup.sh#L809-L819
let
  u-root = buildPackages.buildGoModule rec {
    pname = "u-root";
    version = "0.14.0";
    src = fetchFromGitHub {
      owner = "u-root";
      repo = "u-root";
      rev = "v${version}";
      hash = "sha256-8zA3pHf45MdUcq/MA/mf0KCTxB1viHieU/oigYwIPgo=";
    };
    vendorHash = null;
    patches = [
      (fetchpatch {
        url = "https://github.com/sophgo/bootloader-riscv/commit/322c3305763872a9b88a1c85d79bca63b8fbe7a6.patch";
        hash = "sha256-l5r3DbcMqRYD5FhRBqtEIEscZAdDvjmQJE4BIAtWYWE=";
        stripLen = 1;
      })
    ];

    postInstall = ''
      cp -r . $out/src
    '';

    # We only build the u-root binary in the build phase and the initrd in the
    # postBuild hook.
    subPackages = [ "." ];

    # Tests time out after 10min for native riscv64 builds on the pioneer.
    doCheck = false;
  };
in
buildGoModule {
  name = "linuxboot-initrd";
  src = null;
  vendorHash = null;
  dontUnpack = true;
  nativeBuildInputs = [ u-root ];

  buildPhase = ''
    runHook preBuild
    pushd ${u-root}/src
    mkdir -p $out
    GOROOT="$(go env GOROOT)" u-root \
      -build bb \
      -uinitcmd=boot \
      -files "${linux-firmware}/lib/firmware/amdgpu/:lib/firmware/amdgpu/" \
      -files "${linux-firmware}/lib/firmware/radeon/:lib/firmware/radeon/" \
      -o $out/initramfs.cpio \
      core boot
    popd

    # The vendor does not compress the initrd. We do since we include more
    # firmware files. CRC32 is required by the kernel's decompressor.
    xz --check=crc32 $out/initramfs.cpio
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv $out/initramfs.cpio.xz $out/initrd.img
    runHook postInstall
  '';
}
