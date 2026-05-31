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

{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "pine64-alsa-ucm";
  version = "ec0ef36b8b897ed1ae6bb0d0de13d5776f5d3659";

  src = pkgs.fetchFromGitLab {
    owner = "pine64-org";
    repo = "pine64-alsa-ucm";
    rev = version;
    sha256 = "sha256-nsZXBB5VpF0YpfIS+/SSHMlPXSyIGLZSOkovjag8ifU=";
  };

  patches = [ ./repoint-pinephone-pro.patch ];

  installPhase = ''
    ucm_path=$out/share/alsa/ucm2/

    mkdir -p $ucm_path/PinePhone $ucm_path/PinePhonePro $ucm_path/conf.d/simple-card
    ln -s ../../PinePhonePro/PinePhonePro.conf $ucm_path/conf.d/simple-card/PinePhonePro.conf

    cp -r ucm2/* $ucm_path/
  '';
}
