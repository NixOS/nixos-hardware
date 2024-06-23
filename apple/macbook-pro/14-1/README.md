# MacBook Pro 14,1, NixOS 24.01 (2024)

## Audio
 [ ] Still broken, use usb/hdmi instead, nixos pkg needed: https://github.com/davidjo/snd_hda_macbookpro

## Bluetooth
 [ ] Still broken, even (hacky) workaround does not work any more with latest driver updates

## Touchpad 
 [x] Working, including 'disable while typing' usable quirk

## Thunderbolt
 [x] Working

## NVME
 [x] Working, older NVME / Controller may need workaround for resume

## Suspend/Resume
 [ ] Thunderbolt, WIFI, NVME may still need reboot (sometimes).

## Wifi
 [x] Working (2,4Ghz & 5Ghz supported), WEP3 currently broken b/c old brcm fw 

## Resources
- https://github.com/Dunedan/mbp-2016-linux?tab=readme-ov-file
- https://gist.github.com/roadrunner2/1289542a748d9a104e7baec6a92f9cd7
