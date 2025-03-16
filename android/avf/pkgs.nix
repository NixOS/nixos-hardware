{
  base,
  lib,
  ttyd,
  rustPlatform,
  protobuf_28,
  libwebsockets,
}:
let

  mkRustPkg =
    name: lock: extra:
    rustPlatform.buildRustPackage (
      {
        inherit name;

        RUSTFLAGS = "-C linker=gcc";

        # see https://github.com/NixOS/nixpkgs/issues/145726
        # TODO: disable when cross-compling
        prePatch = ''
          rm .cargo/config.toml
        '';

        src = base;
        setSourceRoot = "sourceRoot=$(echo */guest/${name})";

        nativeBuildInputs = [
          protobuf_28
        ];

        postPatch = ''
          ln -s ${lock} Cargo.lock
        '';

        cargoLock = {
          lockFile = lock;
        };

        meta = {
          mainProgram = name;
        };
      }
      // extra
    );
in
{
  ttyd =
    (ttyd.override ({
      libwebsockets = libwebsockets.overrideAttrs (_: {
        patches = [
          "${base}/build/debian/ttyd/client_cert.patch"
        ];
      });
    })).overrideAttrs
      (a: {
        patches = [
          "${base}/build/debian/ttyd/xtermjs_a11y.patch"
        ];
      });

  android_virt = lib.recurseIntoAttrs {
    forwarder_guest = mkRustPkg "forwarder_guest" ./forwarder_guest_Cargo.lock { };
    forwarder_guest_launcher =
      mkRustPkg "forwarder_guest_launcher" ./forwarder_guest_launcher_Cargo.lock
        {
          patches = [
            ./guest-tcpstates.patch
          ];
        };
    shutdown_runner = mkRustPkg "shutdown_runner" ./shutdown_runner_Cargo.lock { };
    storage_balloon_agent = mkRustPkg "storage_balloon_agent" ./storage_balloon_agent_Cargo.lock { };
  };
}
