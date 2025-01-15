# Lenovo IdeaCentre K330

The specific system I took for reference has the following hardware configuration:

- Intel Core i7 2600
- NVIDIA GeForce GT 545 [Latest supported (proprietary) driver (390.xx)](https://www.nvidia.com/en-us/drivers/details/196213/)
- Some SSD (originally had a Seagate Barracuda hard drive)

This hardware configuration was motivated by #1297

I recommend enabling xserver instead of trying to use Wayland. As documented in the above linked issue, using Wayland with this rather old hardware lead to the system freezing after a short time of operation.

```nix
{
    services.xserver.enable = true;
}
```
