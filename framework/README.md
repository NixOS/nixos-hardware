# NOTE: Structure changes from 2023-11-11

Please read the [Deprecated Behaviour README](./OLD-BEHAVIOUR-DEPRECATION.md) to understand how some structural changes to
the code might affect you!

# [Framework Laptops](https://frame.work/)

## Updating Firmware

First put enable `fwupd`

```nix
services.fwupd.enable = true;
```

Then run

```sh
 $ fwupdmgr update
```

## Common Modules

For the Framework 13 laptops, there are common configuration modules available under the `13-inch/common/` directory,
including some modules specific to AMD- or Intel-based laptops. By preference, there will already be a specialised
module for your model's configuration. Otherwise, it can be added alongside the existing modules.

## Support Tools

### fw-ectool

There is a `fw-ectool` package available in nixpkgs-unstable that provides some system configuration options via the EC.
This ectool only works with the Intel-based Framework laptops at present, as the Framework EC for AMD-based mainboards
is based on the Zephyr port of the ChromeOS EC, which involves a slightly changed communication interface.

