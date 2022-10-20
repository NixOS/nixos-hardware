# MacBook Pro 14,1

## Audio

Audio is a lost cause. Bribe an Apple or Cirrus engineer for the datasheet. ;)

## Thunderbolt

The thunderbolt module will oops upon system resume, and subsequently refuse to work until next reboot.

## Suspend/Resume

The d3cold state needs to be disabled on the NVME controller for it to wake up.

## Bluetooth
The Bluetooth UART (/dev/ttyS0) is created and then deleted by udev in early boot.
Hack around it by reloading the 8250_dw module, causing it to be re-created.
