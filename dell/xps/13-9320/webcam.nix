{ config, pkgs, ... }:

# Only update these hashes after testing they build and the camera functions!

let

  ipu6-camera-bins = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ipu6-camera-bins";
      version = "unstable-2022-02-08";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ipu6-camera-bins";
        # ref = "main";
        rev = "276859fc6de83918a32727d676985ec40f31af2b";
        hash = "sha256-QnedM2UBbGyd2wIF762Mi+VkDZYtC6MifK4XGGxlUzw=";
      };

      installPhase = ''
        mkdir $out
        cp -r $src/ipu6ep/* $out
        for pc in $out/lib/pkgconfig/*; do
          substituteInPlace $pc \
            --replace "exec_prefix=/usr" "exec_prefix=\''${prefix}" \
            --replace "prefix=/usr" "prefix=$out" \
            --replace "libdir=/usr/lib" "libdir=$out/lib" \
            --replace "includedir=/usr/include" "includedir=$out/include"
          done
      '';
    };

  ivsc-firmware = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "unstable-2022-11-02";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        # ref = "main";
        rev = "29c5eff4cdaf83e90ef2dcd2035a9cdff6343430";
        hash = "sha256-GuD1oTnDEs0HslJjXx26DkVQIe0eS+js4UoaTDa77ME=";
      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod
        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };

  ipu6-camera-hal = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ipu6-camera-hal";
      version = "unstable-2022-02-08";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ipu6-camera-hal";
        # ref = "main";
        rev = "884b81aae0ea19a974eb8ccdaeef93038136bdd4";
        hash = "sha256-AePL7IqoOhlxhfPRLpCman5DNh3wYS4MUcLgmgBUcCM=";
      };

      nativeBuildInputs = [cmake pkg-config];

      cmakeFlags = [
        "-DIPU_VER=ipu6ep"
        "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
        "-DUSE_PG_LITE_PIPE=ON"
        "-DUSE_STATIC_GRAPH=OFF"
        "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
        "-DCMAKE_INSTALL_LIBDIR=lib"
        "-DCMAKE_INSTALL_INCLUDEDIR=include"
      ];

      buildInputs = [
        ipu6-camera-bins

        expat.dev
        libtool
      ];

      outputs = [ "out" "dev" ];

    };

  icamerasrc = with pkgs;
    stdenv.mkDerivation rec {
      pname = "icamerasrc";
      version = "20230307_0904_rpl_plat";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "icamerasrc";
        # ref = "icamerasrc_slim_api";
        rev = "20230307_0904_rpl_plat"; # Before refactoring
        hash = "sha256-j8ZYe4nyy5yfo10CGeXDwbAaAPvdr0ptMWB8hQDyESQ=";
      };

      nativeBuildInputs = [automake autoconf autoreconfHook pkg-config];

      # gstreamer cannot otherwise be found
      NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

      CHROME_SLIM_CAMHAL = "ON";
      STRIP_VIRTUAL_CHANNEL_CAMHAL = "ON";

      buildInputs = [
        ipu6-camera-bins
        ipu6-camera-hal

        expat.dev
        libtool
        gst_all_1.gstreamer.dev
        gst_all_1.gst-plugins-base.dev
        libdrm.dev
      ];
    };

  ivsc-driver = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-driver";
      version = "unstable-2023-06-21";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-driver";
        # ref = "main";
        rev = "cce4377f1539f3e7e8d8b45fbe23e87828ed1deb";
        sha256 = "sha256-Q7iyKw4WFSX42E4AtoW/zYRKpknWZSU66V5VPAx6AjA=";
      };

      nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

      installTargets = ["modules_install"];

      makeFlags =
        config.boot.kernelPackages.kernel.makeFlags
        ++ [
          "KERNELRELEASE=${config.boot.kernelPackages.kernel.modDirVersion}"
          "KERNEL_SRC=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
          "INSTALL_MOD_PATH=${placeholder "out"}"
        ];
    };

  ipu6-drivers = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ipu6-drivers";
      version = "unstable-2023-06-09";

      src = fetchgit {
        url = "https://git.launchpad.net/~vicamo/+git/intel-ipu6-dkms";
        rev = "000ab0cc157f4c6b2e57050a594ad58d78ca0a70";
        # ref = "ubuntu/devel";
        hash = "sha256-Eh84ktwGE6lJ1DajUh8Im4Hh+xPJ9Eqzry6iINe/C/U=";
      };

      nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

      prePatch = ''
        patches="$(echo debian/patches/*.patch)$(echo patches/*.patch)"
      '';

      installTargets = ["modules_install"];

      makeFlags =
        config.boot.kernelPackages.kernel.makeFlags
        ++ [
          "KERNELRELEASE=${config.boot.kernelPackages.kernel.modDirVersion}"
          "KERNEL_SRC=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
          "INSTALL_MOD_PATH=${placeholder "out"}"
        ];
    };

  v4l2-relayd = with pkgs;
    stdenv.mkDerivation rec {
      pname = "v4l2-relayd";
      version = "unstable";

      src = pkgs.fetchFromGitLab {
        owner = "vicamo";
        repo = "v4l2-relayd";
        # ref = "main";
        rev = "2e4d5c9ba53bfe8cfe16ea91932c8e5ecb090a87";
        hash = "sha256-3F1ySkGOGlSIPMi+p1NFip4wOsJ0gOdi08s9oQsZsG4=";
      };

      nativeBuildInputs = [automake autoconf autoreconfHook pkg-config];

      preInstall = ''
        mkdir -p $out/lib/systemd/system $out/etc
        ${pkgs.coreutils}/bin/cp -r $src/data/etc/* $out/etc
        ${pkgs.coreutils}/bin/cp -r $src/data/systemd/* $out/lib/systemd/system
      '';

      buildInputs = [
        gst_all_1.gstreamer.dev
        gst_all_1.gst-plugins-base.dev
      ];
    };

  v4l2loopback = config.boot.kernelPackages.v4l2loopback.overrideAttrs (super: {
    src = pkgs.fetchgit {
      url = "https://git.launchpad.net/ubuntu/+source/v4l2loopback";
    #   ref = "ubuntu/devel";
      rev = "cae2954041bc64301097ad996f31ad860e6469f5";
      hash = "sha256-2rGGHBdohcyD5jKmFYqwKCm6iURcxs0OrI+rhukmnRo=";
    };

    prePatch = ''
      patches="$(echo debian/patches/*.patch)$(echo patches/*.patch)"
    '';
  });

  webcamName = "DellWebcam";

in {
    environment.etc.camera.source = "${ipu6-camera-hal}/share/defaults/etc/camera";

    systemd.services.v4l2-relayd = {
        environment = {
        GST_PLUGIN_SYSTEM_PATH_1_0 = pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [icamerasrc gstreamer gst-plugins-base gst-plugins-good]);
        LD_LIBRARY_PATH = "${ipu6-camera-bin}/lib";
        };
        script = ''
          export GST_DEBUG=2
          export DEVICE=$(grep -l -m1 -E "^${webcamName}$" /sys/devices/virtual/video4linux/*/name | cut -d/ -f6);
          exec ${v4l2-relayd}/bin/v4l2-relayd \
            --debug \
            -i "icamerasrc" \
            -o "appsrc name=appsrc caps=video/x-raw,format=NV12,width=1280,height=720,framerate=30/1 ! videoconvert ! video/x-raw,format=YUY2 ! v4l2sink name=v4l2sink device=/dev/$DEVICE"
        '';
        wantedBy = ["multi-user.target"];
        serviceConfig = {
        User = "root";
        Group = "root";
        };
    };

    hardware.firmware = [
        ipu6-camera-bin
        ivsc-firmware
    ];

    boot.extraModulePackages = [
        ipu6-drivers
        ivsc-driver
        v4l2loopback
    ];

    boot.kernelModules = [
        "v4l2loopback"
    ];

    boot.extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="${webcamName}"
    '';

    hardware.enableAllFirmware = true;
}