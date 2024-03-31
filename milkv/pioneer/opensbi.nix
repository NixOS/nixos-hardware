{ fetchFromGitHub, opensbi, ... }:

opensbi.overrideAttrs (attrs: {
  # Based on the vendor's sg2042-master branch.
  version = "1.4-git-a6e158f7";
  src = fetchFromGitHub {
    owner = "sophgo";
    repo = "opensbi";
    rev = "a6e158f71aab17155e2bf25a325ce4f0be51d9dd";
    hash = "sha256-5ggrEx1e53pB2+m0TBjDzDJXf2wjsQ2edu01FqqGt/Y=";
  };

  makeFlags =
    # Based on the vendor options
    # https://github.com/sophgo/bootloader-riscv/blob/01dc52ce10e7cf489c93e4f24b6bfe1bf6e55919/scripts/envsetup.sh#L299
    attrs.makeFlags ++ [
      "PLATFORM=generic"
      "FW_PIC=y"
      "BUILD_INFO=y"
      "DEBUG=1"
    ];
})
