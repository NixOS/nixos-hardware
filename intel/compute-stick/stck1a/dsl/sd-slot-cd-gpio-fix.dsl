DefinitionBlock ("sd-slot-cd-gpio-fix.aml", "SSDT", 5, "NIXOS", "SDHDFIX", 0x00000001)
{
    External (\_SB.SDHD, DeviceObj)

    Scope (\_SB.SDHD)
    {
        Name (_DSD, Package ()
        {
            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
            Package ()
            {
                /*
                 * The sdhci-acpi driver expects a cd (card-detect) GPIO
                 * from the first Gpio/GpioInt entry in the device's _CRS.
                 *
                 * Unfortunately, the first entry is a GpioInt, which the driver
                 * cannot use for card detection (it only supports plain Gpio).
                 *
                 * As a result, the driver fails to detect the SD card.
                 *
                 * This SSDT patch explicitly directs the driver to use
                 * the second Gpio resource (index 1), which is the correct
                 * Gpio entry for card detection.
                 */
                Package () { "gpios", Package () { ^SDHD, 1, 0, 0 } },
            }
        })
    }
}
