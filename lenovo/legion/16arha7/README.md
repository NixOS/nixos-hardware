## Introduction

This configuration includes a fix to get the speakers working on kernels earlier than 6.9.0. Kernels after 6.9.0 already have this patch built-in.

## Setup at the time of testing
```
$ nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.8.2-zen2, NixOS, 24.05 (Uakari), 24.05.20240403.fd281bd`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.18.2`
 - channels(root): `""`
 - nixpkgs: `/home/aires/.nix-defexpr/channels/nixpkgs`
 ```
