# Shared kernel configuration for i.MX platforms
# This configuration is used across i.MX93, i.MX8MP, i.MX8MQ and similar platforms
{
  # Common kernel extra configuration for i.MX platforms
  # Includes: virtualization support, EFI boot, RAID, USB/IP, framebuffer settings
  imxCommonKernelConfig = ''
    CRYPTO_TLS m
    TLS y
    MD_RAID0 m
    MD_RAID1 m
    MD_RAID10 m
    MD_RAID456 m
    DM_VERITY m
    LOGO y
    FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER n
    FB_EFI n
    EFI_STUB y
    EFI y
    VIRTIO y
    VIRTIO_PCI y
    VIRTIO_BLK y
    DRM_VIRTIO_GPU y
    EXT4_FS y
    USBIP_CORE m
    USBIP_VHCI_HCD m
    USBIP_HOST m
    USBIP_VUDC m
  '';
}
