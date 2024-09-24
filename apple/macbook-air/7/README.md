# MacBook Air 7,X

### For wifi driver
broadcomt_sta was the best working driver I could find, however on the normal kernel, you need to `sudo modprobe -r wl` and `sudo modprobe wl`, however it was fully working on the zen kernel.

