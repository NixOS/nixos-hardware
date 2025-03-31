{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation {
  name = "macrecovery";

  src = fetchFromGitHub {
    owner = "acidanthera";
    repo = "OpenCorePkg";
    rev = "1.0.4";
    hash = "sha256-5Eypza9teSJSulHaK7Sxh562cTKedXKn3y+Z3+fC6sM=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    cd Utilities/macrecovery
    install -Dm755 macrecovery.py $out/opt/macrecovery
    cp boards.json $out/opt/boards.json
    mkdir $out/bin
    ln -s $out/opt/macrecovery $out/bin/macrecovery
  '';

  meta = with lib; {
    description = "A tool that helps to automate recovery interaction";
    homepage = "https://github.com/acidanthera/OpenCorePkg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mkorje ];
    mainProgram = "macrecovery";
    platforms = platforms.all;
  };
}
