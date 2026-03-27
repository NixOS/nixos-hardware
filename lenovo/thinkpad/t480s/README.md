# lenovo-thinkpad-t480s

For most users you can enable the config and everything will work, however if you got a **fingerprint sensor**, enable this (it is not enabled because not every ThinkPad t480s got one) :
```nix
services.fprintd.enable = true;
```

**(advanced user only)** or if you got overeating issue as described in this post [Reddit](https://www.reddit.com/r/thinkpad/comments/870u0a/t480s_linux_throttling_bug/) enable this (probably not relevant for most of users, check your thermal paste and fans before doing, it will undervolt your cpu and can just cause more issues than it resolve):
```nix
services.throttled.enable = true;
```
