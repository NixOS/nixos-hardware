{
  runCommand,
  buildPackages,
  pkgs,
}:

let
  uboot = pkgs.callPackage ./uboot.nix { };

  opensbi = pkgs.opensbi.override {
    withPayload = "${uboot}/u-boot.bin";
    withFDT = "${uboot}/u-boot.dtb";
  };
in
runCommand "firmware-starfive-visionfive-v1"
  {
    nativeBuildInputs = with buildPackages; [ xxd ];
  }
  ''
    function handle_file {
      inFile=$1
      echo inFile: $inFile
      outFile=$2
      inSize=`stat -c "%s" $inFile`
      inSize32HexBe=`printf "%08x\n" $inSize`
      inSize32HexLe=''${inSize32HexBe:6:2}''${inSize32HexBe:4:2}''${inSize32HexBe:2:2}''${inSize32HexBe:0:2}
      echo "inSize: $inSize (0x$inSize32HexBe, LE:0x$inSize32HexLe)"
      echo $inSize32HexLe | xxd -r -ps > $outFile
      cat $inFile >> $outFile
      echo outFile: $outFile
      outSize=`stat -c "%s" $outFile`
      outSize32HexBe=`printf "%08x\n" $outSize`
      echo "outSize: $outSize (0x$outSize32HexBe)"
    }

    mkdir -p "$out/nix-support"
    echo "file bin \"$out/opensbi_u-boot_starfive_visionfive_v1.bin\"" >> "$out/nix-support/hydra-build-products"
    handle_file ${opensbi}/share/opensbi/lp64/generic/firmware/fw_payload.bin $out/opensbi_u-boot_starfive_visionfive_v1.bin
  ''
