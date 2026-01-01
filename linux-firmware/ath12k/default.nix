{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    linux-firmware-ath12k-patched = {
      enable = lib.mkEnableOption "enables linux-firmware-ath12k-patched";
      fw-name = lib.mkOption {
        type = lib.types.str;
        description = ''
          The device name of your WiFi card. That is, if your dmesg says
          "failed to fetch board data for X from ath12k/Y" then this is X
        '';
        example = ''bus=pci,vendor=17cb,device=1107,subsystem-vendor=1eac,subsystem-device=8001,qmi-chip-id=2,qmi-board-id=255'';
      };
      fw-board2 = lib.mkOption {
        type = lib.types.str;
        description = ''
          The path to the board-2.bin you'd like to patch RELATIVE TO the
          ath12k folder. That is, if your dmesg says
          "failed to fetch board data for X from ath12k/Y" then this is Y.
        '';
        example = ''WCN7850/hw2.0/board-2.bin'';
      };
      fw-file = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          This is the firmware file you'd like to use. To see a list of
          available files leave this setting blank, which will cause the
          build to fail and the list of files to be printed to the build log..
        '';
        example = ''bus=pci,vendor=17cb,device=1107,subsystem-vendor=17aa,subsystem-device=e0e6,qmi-chip-id=2,qmi-board-id=255.bin'';
      };
    };
  };

  config = lib.mkIf config.linux-firmware-ath12k-patched.enable {
    hardware.firmware =
      with pkgs;
      with config.linux-firmware-ath12k-patched;
      [
        (stdenvNoCC.mkDerivation rec {
          pname = "linux-firmware-ath12k-patched";
          version = "0-unstable-2025-12-05";

          src = fetchgit {
            url = "https://git.codelinaro.org/clo/ath-firmware/ath12k-firmware.git";
            hash = "sha256-DIoj91XELnFj4xludxJCZRHctS4fYQ2khiFWrPdKHoo=";
            rev = "8253b9185d292ba1ad27654f74b7a3abc68fca9c";
          };

          bdecoder = fetchurl {
            url = "https://raw.githubusercontent.com/qca/qca-swiss-army-knife/99ecb87c5f808e98096eeddd5d804eeb0cf51d18/tools/scripts/ath12k/ath12k-bdencoder";
            hash = "sha256-/cyNyWKNZ+UA1Jah3iLoLhNt3q7DJmnqGzrdk/KYBlI=";
          };

          fw-repo = fetchurl {
            url = "https://raw.githubusercontent.com/qca/qca-swiss-army-knife/99ecb87c5f808e98096eeddd5d804eeb0cf51d18/tools/scripts/ath12k/ath12k-fw-repo";
            hash = "sha256-7NvmddwqLiVeB+A2moll1YFH1/0j8rTtgDXGtmJ6hIA=";
          };

          nativeBuildInputs = [
            python3
          ];

          buildPhase = ''
            mkdir board-2 && cd $_
            export RES_DIR=$PWD
            python3 $bdecoder --extract $src/${fw-board2}
            python3 << EOF
            import json
            with open('board-2.json', 'r') as f:
                board2 = json.load(f)
            data = '${fw-file}'
            name = '${fw-name}'
            if not data:
                print("="*80)
                print('=== Dumping JSON for ${fw-board2}')
                print("="*80)
                print(json.dumps(board2, indent=4))
                print("="*80)
                print('=== Dumping list of available options for fw-file')
                print("="*80)
                print(json.dumps([d['data'] for d in board2[0]['board']], indent=4))
                print("="*80)
                error_string = 'Fatal error: please choose one of the values above and set them as the fw-file'
                print(error_string)
                raise RuntimeError(error_string)
            for b in board2[0]['board']:
                if b['data'] == data:
                    b['names'].append(name)
            with open('board-2.json', 'w') as f:
                json.dump(board2, f)
            EOF
            python3 $bdecoder -c ./board-2.json -o patched-board-2.bin
          '';

          installPhase = ''
            runHook preInstall

            cd $src
            mkdir -p $out//lib/firmware
            python3 ${fw-repo} --install $out//lib/firmware
            cp $RES_DIR/patched-board-2.bin $out/lib/firmware/ath12k/${fw-board2}

            runHook postInstall
          '';
        })
      ];
  };
}
