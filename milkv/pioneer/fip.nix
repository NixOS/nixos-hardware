{ fetchurl, ... }:

# Download the vendor's Firmware Image Package
fetchurl {
  url = "https://github.com/sophgo/bootloader-riscv/raw/3f750677e0249ff549ad3fe20bbc800998503539/firmware/fip.bin";
  hash = "sha256-rav00Ok6+FU77lI0piQPHCaz7Tw1RSbyUal4PyeSccg=";
}
