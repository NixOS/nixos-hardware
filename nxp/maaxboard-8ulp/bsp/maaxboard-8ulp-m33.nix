{
  lib,
  stdenv,
  fetchgit,
  gcc-arm-embedded,
  cmake,
}:

# Cortex-M33 firmware for i.MX8ULP boot (maaxboard-build-tools build_cortexM()).
stdenv.mkDerivation rec {
  pname = "maaxboard-8ulp-m33";
  version = "lf-6.1.22-2.0.0";

  src = fetchgit {
    url = "https://github.com/Avnet/mcore_sdk_8ulp.git";
    rev = "f6b1bcceab9e8510a06355c05dfe55c5f87bb9fd";
    sha256 = "sha256-B2mdxwMxNUnow7iBdSq2AcpO12+8MqZ36DLme5GYkgk=";
  };

  nativeBuildInputs = [
    cmake
    gcc-arm-embedded
  ];

  dontConfigure = true;

  # boards/evkmimx8ulp/multicore_examples/rpmsg_lite_str_echo_rtos/armgcc/build_release.sh
  buildPhase = ''
    runHook preBuild

    cd boards/evkmimx8ulp/multicore_examples/rpmsg_lite_str_echo_rtos/armgcc
    cat > ../version.h <<EOF
#define SDK_VERSION "v2.14.0"
#define GIT_VERSION "g${lib.substring 0 12 src.rev}"
EOF

    export ARMGCC_DIR=${gcc-arm-embedded}
    cmake \
      -DCMAKE_TOOLCHAIN_FILE="../../../../../tools/cmake_toolchain_files/armgcc.cmake" \
      -G "Unix Makefiles" \
      -DCMAKE_BUILD_TYPE=release \
      .
    make -j$NIX_BUILD_CORES
    test -f release/rpmsg_lite_str_echo_rtos_imxcm33.elf
    cp release/rpmsg_lite_str_echo_rtos_imxcm33.elf $NIX_BUILD_TOP/m33.elf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ${gcc-arm-embedded}/bin/arm-none-eabi-objcopy -Obinary \
      $NIX_BUILD_TOP/m33.elf \
      $out/m33_image.bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Avnet/mcore_sdk_8ulp";
    description = "MaaXBoard 8ULP Cortex-M33 firmware (rpmsg_lite_str_echo_rtos)";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}
