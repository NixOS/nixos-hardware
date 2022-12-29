{ kmod,
  writeShellApplication,
  ...
}:

writeShellApplication {
  name = "wait-unload-module";
  runtimeInputs = [ kmod ];
  text = ''
    unload_module() {
      local module="$1"

      if modprobe -r "$module" 2>&1; then
        echo ok
      else
        echo fail
      fi
    }

    # NOTE: If using "systemd-inhibit", please use "--mode=delay" to minimise the risk of sleep
    #       being completely blocked.
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
            echo "'modprobe':
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
