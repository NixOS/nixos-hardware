{ coreutils,
  kmod,
  writeShellApplication,
  ...
}:

writeShellApplication {
  name = "wait-unload-module";
  runtimeInputs = [
    coreutils
    kmod
  ];
  text = ''
    # This script attempts to unload a kernel module, waiting for it to no longer be in-use by
    # other modules.
    # It does so by trying to "modprobe -r" the module once every second until the command
    # no longer fails with a "is in use" message.
    #
    # NOTE: If using "systemd-inhibit", please use "--mode=delay" to minimise the risk of sleep
    #       being completely blocked.
    #       The setting causes "systemd-inhibit" to place a time-out on the completion of the
    #       script, and will cancel the inhibit it if the script exceeds the time-out.

    unload_module() {
      local module="$1"

      if modprobe -r "$module" 2>&1; then
        echo ok
      else
        echo fail
      fi
    }

    main() {
      local module="$1"

      # TODO: Change to a timeout, rather than a "sleep"?
      while sleep 1; do
        output="$(unload_module "$module")"
        case "$output" in
          *is\ in\ use*)
            :noop
            ;;
          *ok*)
            return 0
            ;;
          *)
            echo "modprobe output:"
            echo "$output"
            echo "(Exiting)"
            return 1
            ;;
        esac
      done
    }

    main "$@"
  '';
}
