# Changes to the framework top-level

## Overview

When the framework profile was created, there weren't other models of laptop available by the
company. Now there are multiple generations of the Framework 13, and the Framework 16 shipping by
the end of 2023.

## How to update

By preference, there will already be a specialised module for your model's configuration. If you
have an 11th gen Intel Framework 13 and were importing the `framework` profile, you would need to
update to use the `framework-11th-gen-intel` profile instead.

If not and you have a 13-inch model, the common module under `framework/13-inch/common/default.nix`
can be imported directly, and the options provided can be used in your own system's configuration.

Alternatively, you can create a new specialisation for your model under `framework` configured for
that model.

## Changes

### 13-inch profile

All of the existing modules have been reconfigured to be under the `framework/13-inch` folder.

The 12th and 13th gen Intel Framework 13's had their own specialisation modules separately available
already. To mirror those modules, the 11th gen Intel Framework 13 configuration has been moved to
`framework/13-inch/11th-gen-intel/default.nix`.

### "Common" modules

Tools / services that are shared among several models are now extracted to their own module under
`13-inch/common/` and imported by `13-inch/common/default.nix`. There were several tweaks for
11th gen/12th gen that were duplicated and are now a part of common modules.

