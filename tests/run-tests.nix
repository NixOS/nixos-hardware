{
  lib,
  writeShellScriptBin,
  bash,
  python3,
  nix-eval-jobs,
  self,
}:

writeShellScriptBin "run-tests" ''
  #!${bash}/bin/bash
  export PATH=${
    lib.makeBinPath [
      nix-eval-jobs
      nix-eval-jobs.nix
    ]
  }
  exec ${python3.interpreter} ${self}/tests/run.py
''
