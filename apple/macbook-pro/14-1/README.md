# MacBook Pro 14,1, NixOS 24.05 (2024)

## Audio
 - [ ] broken until https://github.com/NixOS/nixpkgs/pull/322968 lands in master

## Bluetooth
 - [ ] broken lands https://github.com/NixOS/nixpkgs/pull/322964 in master

## Touchpad 
 - [x] Working, including 'disable while typing' usable quirk

## Thunderbolt
 - [x] Working

## NVME
 - [x] Working, older NVME / Controller may need workaround for resume

## Suspend/Resume
 - [ ] Thunderbolt, WIFI, NVME may still need reboot (sometimes).

## Wifi
 - [x] Working (2,4Ghz & 5Ghz supported), WEP3 broken -> brcm fw blob (2015) 

## Resources
- https://github.com/Dunedan/mbp-2016-linux?tab=readme-ov-file
- https://gist.github.com/roadrunner2/1289542a748d9a104e7baec6a92f9cd7
