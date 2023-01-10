# Changes to the microsoft/surface top-level

## Overview

When I (@mexisme) created the microsoft/surface profile, there weren't that many differences between
the various models of Surface.

I had just acquired a Surface Go 1, and it was mostly safe to enable all the options for all the
models, and they would fail gracefully enough that we could mostly ignore warnings or errors.

Now, however --- as-of 2023-01-10 --- we have a much wider variety of chipsets, incl. models with
some of the newer AMD CPUs, and this is breaking small things in annoying ways for more people.

## How to update

By preference, there will already be a specialised module for your model's configuration.

If not, the `microsoft/surface/common/` module can also be imported directly, and the options
provided can be used in your own system's configuration.

Alternatively, you can create a new specialisation for your model under `microsoft/surface`
configured for that model.

## Changes

### Model Specialisations

In keeping with the broader structure of "nixos-hardware", I've also changed the structure of the
microsoft/surface profile to make it easier for people to specialise for their hardware.

Any code or modules that are specialised for a Surface model now have their own directory under this
top-level.

E.g. I am moving the Surface Go specialisations into `surface-go/`, and there may be further
specialisations like `surface-go-3/`.

### "Common" modules

All the "common" modules that were once in the top-level of the microsoft/surface profile have moved
under the `common/` directory.

Tools / services that are shared among several models are now extracted to their own module under
`common/` and imported by `common/default.nix`.
These new "common" modules now have an `enable` option, which is `false` by default.

### "Deprecated Behaviour" module

The original `./default.nix` module has been replaced by a new `deprecated/` module, which replicates the
original behaviour.

The new `./default.nix` will load the new `deprecated/` module, but will also pop-up a warning asking users
to update how they use the microsoft/surface profile from now on.
This warning will probably change to a fail assertion at some point in the future.

## Adding a new Model Specialisation

This hasn't been finalised, partly as I now only have access to a Surface Go 1, these days, so I'm
maybe not the best custodian of this code any longer.

However, hopefully the (imminent) `surface-go/` module is a reasonable exmample, and we should be
able to gather more examples for more model specialisations over time.
