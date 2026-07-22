# GPD Pocket 4 — HAILUCK touchpad firmware gesture workaround
#
# The HAILUCK CO.,LTD USB keyboard+touchpad (258a:000c) has no native
# multitouch support in Linux. The firmware detects 3-finger swipes
# internally and translates them into keyboard shortcuts:
#
#   3-finger left  → Alt+Shift+Tab, then LEFT arrow key repeats
#   3-finger right → Alt+Tab, then RIGHT arrow key repeats
#   3-finger up    → Super+Tab
#   3-finger down  → Super+D
#
# These are standard Windows desktop shortcuts (app switcher, show desktop).
# On Linux compositors they need to be rebound to useful actions.
#
# Why a lower-level fix isn't possible:
#
#   The firmware sends gesture keypresses through the same USB HID
#   keyboard interface (interface 0) using identical scancodes and
#   report format as physical keypresses. There is no metadata, timing
#   flag, separate report ID, or concurrent event on another interface
#   that distinguishes gesture-generated keys from physical ones.
#   Tools like keyd, hwdb, and evsieve cannot selectively intercept
#   gesture keys without also breaking the same shortcuts when typed
#   on the physical keyboard.
#
# Trade-off:
#
#   Binding these shortcuts to gesture actions means Super+D, Super+Tab,
#   Alt+Tab, and Alt+Shift+Tab lose their normal compositor functions.
#   Rebind those functions to other keys if needed (e.g. Super+Space
#   for app launcher, Mod+O for overview).
#
#   Edge case: pressing Alt+Tab on the keyboard while simultaneously
#   doing a 3-finger swipe would be misinterpreted as two gesture
#   events. In practice this almost never happens.
#
# References:
#   https://gitlab.freedesktop.org/libinput/libinput/-/issues/345
#   https://linux-hardware.org/?id=usb:258a-000c
#
{ lib, ... }:

{
  # This module is documentation-only. Compositor keybind examples:
  #
  # Niri (config.kdl):
  #   Mod+D         { focus-workspace-down; }
  #   Mod+Tab       { focus-workspace-up; }
  #   Alt+Tab       { focus-column-right; }
  #   Alt+Shift+Tab { focus-column-left; }
  #
  # Sway/i3 (config):
  #   bindsym Mod4+d workspace next
  #   bindsym Mod4+Tab workspace prev
  #   bindsym Mod1+Tab focus right
  #   bindsym Mod1+Shift+Tab focus left
  #
  # Hyprland (hyprland.conf):
  #   bind = SUPER, D, workspace, +1
  #   bind = SUPER, Tab, workspace, -1
  #   bind = ALT, Tab, movefocus, r
  #   bind = ALT SHIFT, Tab, movefocus, l
}
