# Microsoft Surface Pro 9

## Note on Intel Panel Self Refresh (PSR)

Intel GPUs support a feature called [Panel Self Refresh (PSR)](https://www.intel.com/content/www/us/en/support/articles/000057194/graphics.html), where the display refreshes independently of the OS. Out of the box, this can cause lots of display lag, stuttering, and enormous refresh rate drops.

This configuration disables PSR by adding `i915.enable_psr=0` to the kernel boot parameters, at the cost of some battery life. If you want to turn PSR back on, add `i915.enable_psr=1` to your `boot.kernelParams`.
