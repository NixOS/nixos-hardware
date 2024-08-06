# MIT License

# Copyright (c) 2018-2020 Samuel Dionne-Riel and the Mobile NixOS contributors

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{
  runCommand,
  firmwareLinuxNonfree,
  fetchgit,
  fetchFromGitLab,
}:

let
  pinephonepro-firmware = fetchFromGitLab {
    domain = "gitlab.manjaro.org";
    owner = "tsys";
    repo = "pinebook-firmware";
    rev = "937f0d52d27d7712da6a008d35fd7c2819e2b077";
    sha256 = "sha256-Ij5u4IF55kPFs1BGq/sLlI3fjufwSjqrf8OZ2WnvjWI=";
  };
  ap6256-firmware = fetchFromGitLab {
    domain = "gitlab.manjaro.org";
    owner = "manjaro-arm";
    repo = "packages%2Fcommunity%2Fap6256-firmware";
    rev = "a30bf312b268eab42d38fab0cc3ed3177895ff5d";
    sha256 = "sha256-i2OEkn7RtEMbJd0sYEE2Hpkvw6KRppz5AbwXJFNa/pE=";
  };
  brcm-firmware = fetchgit {
    url = "https://megous.com/git/linux-firmware";
    rev = "6e8e591e17e207644dfe747e51026967bb1edab5";
    sha256 = "sha256-TaGwT0XvbxrfqEzUAdg18Yxr32oS+RffN+yzSXebtac=";
  };
in

# The minimum set of firmware files required for the device.
runCommand "pine64-pinephonepro-firmware" { src = firmwareLinuxNonfree; } ''
  for firmware in \
    rockchip/dptx.bin \
  ; do
    mkdir -p "$(dirname $out/lib/firmware/$firmware)"
    cp -vrf "$src/lib/firmware/$firmware" $out/lib/firmware/$firmware
  done

  (PS4=" $ "; set -x
  mkdir -p $out/lib/firmware/{brcm,rockchip}
  (cd ${ap6256-firmware}
  cp -fv *.hcd *blob *.bin *.txt $out/lib/firmware/brcm/
  )
  cp -fv ${pinephonepro-firmware}/brcm/* $out/lib/firmware/brcm/
  cp -fv ${pinephonepro-firmware}/rockchip/* $out/lib/firmware/rockchip/
  cp -fv ${brcm-firmware}/brcm/*43455* $out/lib/firmware/brcm/
  )
''
