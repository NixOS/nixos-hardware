# Lenovo ThinkPad X1 Yoga Gen 8

## Camera

The X1 Yoga Gen 8 ships with one of two cameras, and each needs a
different profile.

| Camera                  | Check                             | Profile                                |
|-------------------------|-----------------------------------|----------------------------------------|
| USB (UVC)               | `lsusb` lists "Integrated Camera" | `lenovo-thinkpad-x1-yoga-8th-gen`      |
| MIPI sensor behind IPU6 | `lsmod` lists `intel_ipu6`        | `lenovo-thinkpad-x1-yoga-8th-gen-ipu6` |

The USB camera works out of the box.

The MIPI camera works through libcamera without any extra configuration,
so browsers and GNOME can already use it through PipeWire. Applications
that speak plain V4L2, such as Zoom, can only see raw Bayer nodes and
report that there's no camera. The `ipu6` profile enables
`hardware.ipu6`, which relays the sensor to a regular V4L2 device. That
pulls in Intel's proprietary camera HAL and firmware.
