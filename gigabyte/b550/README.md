# B550 suspend bug

Gigabyte B550-family motherboards have a hard to diagnose (At least, from the system log events) suspend bug.

As of the F18 bios for the b550m-d3sh (My machine), released in 2024-02-27, this is still unfixed by the manufacurer and has been for over 4 years.

Symptoms: 
- Suspend PC
- It goes into suspend, then seems to boot and hang.  Sometimes it suspends successfully, but waking it from suspend puts it in the "zombie" state.
- By playing chicken with volatile storage and flicking the power switch on the back of power supply, you can sometimes get it to wake from suspend as the card un-powers before volatile storage does.

Fix: disable GPP0 and GPP8 (And, for some cards, potentially PTXH, I can't test) in /proc/acpi/wakeup
    - To do this permanently, a systemd service is provided


## This affects at least:
- Gigabyte b550m-d3sh (my machine)
- Gigabyte B550i AORUS Pro Ax https://www.reddit.com/r/gigabyte/comments/p5ewjn/b550i_pro_ax_f13_bios_sleep_issue_on_linux/
- Gigabyte B550 Vision D https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/hb32elw/
- Gigabyte B550 Aorus Pro https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/ijsx8ia/
- Gigabyte B550 Aorus Pro AC https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/j6cbnwq/
- Gigabyte B550 Aorus Pro v2 https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/imx7sz0/
    - B550 Aorus Pro may need GPP0 and PTXH instead of GPP8, I don't have hardware to test
- Gigabyte B550 Aurus Elite v2 https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/k2psbgu/
- Gigabyte B550m pro https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/huocd81/
- Gigabyte B550m Aorus Elite https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/hzngaa7/
- Gigabyte B550 Gaming X v2 https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/hvojl44/
- Gigabyte B550 Aorus Master v1.0 https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/j1alpxk/

### Anecdotes of other boards:
- Gigabyte A520M https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/i57jpjw/



## Shoutouts:
- thanks to [/u/dustythermals's reddit comment](https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/hb32elw/) for the systemd service blueprint
- thanks to help from [@ToxicFrog](https://github.com/ToxicFrog) for advice on making it not toggle when `nixos-rebuild switch` is ran
- thanks to [/u/Demotay's reddit comment](https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/ksbm0mb/) for how to make it check and only fire if these are enabled
- Huge thanks to /u/theHugePotato who found the [root cause](https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/h9plj88/) and put it where everyone could find

## Breadcrumbs:
https://www.reddit.com/r/gigabyte/comments/p5ewjn/b550i_pro_ax_f13_bios_sleep_issue_on_linux/

https://www.reddit.com/r/archlinux/comments/11urtla/systemctl_suspend_hibernate_and_hybridsleep_all/

https://forum.manjaro.org/t/system-do-not-wake-up-after-suspend/76681/2

