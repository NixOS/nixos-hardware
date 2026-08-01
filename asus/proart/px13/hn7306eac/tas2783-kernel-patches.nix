{
  pkgs,
  lib,
  config,
  ...
}:

# See CachyOS’s discussion:
# https://github.com/CachyOS/linux-cachyos/issues/737
let
  mkPatch = name: hash: {
    inherit name;
    patch = pkgs.fetchpatch {
      inherit name;
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}.patch?h=linux-cachyos-px13";
      inherit hash;
    };
  };
in
{
  assertions = [
    {
      assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "7.0";
      message = "tas2783 patches require Linux ≥ 7.0 (found ${config.boot.kernelPackages.kernel.version})";
    }
  ];

  boot.kernelPatches = [
    (mkPatch "0001-ALSA-tas2783-sdw-add-Playback-to-volume-control" "sha512-IdIy81PXtmQAQ+MVChYDYkoa5RDhQwP2L5efN8cz+tST3nM0Oc0x4SJ4sBnVL7QDJc/WBB0OEnFfTkEt9Id+cQ==")
    (mkPatch "0002-Names-to-match-snd_soc_dai_driver-playback-capturest" "sha512-SrCgzceh3rhyYz5tNWHY2jNWyG/qgmU7ZVLtV71iir8HwOrSES7JsunV2E7mb8R66dShY+loV8ovNeMkyuDB7w==")
    (mkPatch "0003-removed-unused-fields" "sha512-mWKqFg8AG00TE3oPy5usPPxWf6aIvhxMLDGI+/0+vvjBIFwWv6qh9jSUeid6CAKgAcluPSA8Sag4ESguCeinyw==")
    (mkPatch "0004-SOC_SINGLE_RANGE_TLV-uses-snd_soc_get_volsw-snd_soc_" "sha512-G51v725q17UHvfPg4H8V92eSbZ5lcuiF97Zt1EbAtuwrhXefeaZy+hl79sSpVlzzY8pvzIwf6wodAuvp44M01A==")
    (mkPatch "0005-dev_set_drvdata-already-called-intas_sdw_probe" "sha512-zk+rKZ/l0oB7JdABtb89x6tUzggP99TSy+3cr+q6QjZFdjGsLPXHxre0YACuKBNx6+JazZE/zEilIvahS4wOLQ==")
    (mkPatch "0006-refactor-setting-sa_func_data" "sha512-8djgIJV1LCzDhFLFn/PNfDkE+U0mh2h4Rm2LJMeLUYKQlwzgPMbICh5B3HhCgEVTaUd54OGOSFEf0i6AIm2SIQ==")
    (mkPatch "0007-check-AF01-for-init-data" "sha512-gjpdnJDzve37MnyVE52+E9sRkXF9+HtA4XTrBZQiV8ozFwWgIzhO2ZDKSpWbE/kd23PdaUcKX/fPj3J7ZD5YqA==")
    (mkPatch "0008-setup-ports" "sha512-uuDa92VXlCsszswv8PHcDbbyfseL6Jt7DWPc5ajG1WSM/FGojRIbbl/2smQyGfE2jPquy5GQfJps7k1cRfpl8w==")
    (mkPatch "0009-Already-set-by-SOC_SINGLE_RANGE_TLV-Speaker-Playback" "sha512-qBveCsmwezD13oWF5jBlUybdns5OsDDZji0y0smaKWi9GPAvhw/v66WUnEyC77UF1mvq+OyrWpA4yXwxAFza3Q==")
    (mkPatch "0010-control-to-set-channel" "sha512-pL8Ol1ml2QhyKnzZvD+oTaVUPyqOO49uuiEUzyKdnskFwVH+jIluY3IDsmzWv5wTg/9D+CTGC4J8gW55xKwWfg==")
    (mkPatch "0011-mute-unmute-using-SND_SOC_DAPM_SWITCH" "sha512-6aB8mBACTIQxU7CTrpR3UXJFdR4KbUOT9/AymyGiuV/9PfWdXZoW/0A09SHFptxRwCv4FG5tZSDZRtKvvYNQdQ==")
    (mkPatch "0012-use-SND_SOC_DAPM_REG-to-power-on-off" "sha512-mJ93TxZQ1GuDGar0/6tBd/dlJ3B/41AVhRsViuSaEhykPC4NlIAOWaN9eJj4bxjEEyEQ3REfjHXVnJ3wdCRK9w==")
    (mkPatch "0013-reattach-after-resume" "sha512-OdkYPzRDkd4FCd1OTOAfRrQW6JQ9D3Opic/X+sg+pLNGoEEXfph/sLXVYGo9u6DGPJndQZNrXyS4qhJMGPWVMw==")
    (mkPatch "0014-defer-check" "sha512-ABSrwsOB+KU39LMxh3N47Ji+edhu5rDQMKMi5rEVXtCU8W56qANpU+ui+bJmOLYyq8c9H1qme+b5nQ6u9zv01w==")
    (mkPatch "0015-to-help-alsa-find-them" "sha512-gVJ+0ZO9Oz15/rC08moVSlVglbishJctjH5SnDdI8m3s9hkEY56o8v+R/PlRS3rL+mOa9q3VuO5J40+LrcxDKw==")
    (mkPatch "0016-cleanup-controls" "sha512-Jkp7kdi0FmVMlBL/VVzq7hYkCmKoELO0epnExP7ggQuopCzRbVpUQ3giMlj10O69aUBZJ4z3gaMkb1HTYjIXmA==")
    # Upstream linux-firmware took a different naming approach to the original patches
    {
      name = "0017-fix-tas2783-fw-name-0x";
      patch = ./fix-tas2783-fw-name-0x.patch;
    }
  ];
}
