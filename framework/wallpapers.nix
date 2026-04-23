# Framework-branded wallpaper packs, installed system-wide so GNOME and
# KDE Plasma wallpaper pickers can find them.
#
# Each pack is opt-in; pick the ones that match your hardware, for example:
#   hardware.framework.wallpapers.laptop13pro.enable = true;
#
# Or enable every pack at once:
#   hardware.framework.wallpapers.enableAll = true;
#
# To set one as the default in GNOME, add a GSettings override, e.g.:
#   services.desktopManager.gnome.extraGSettingsOverrides = ''
#     [org.gnome.desktop.background]
#     picture-uri='file:///run/current-system/sw/share/backgrounds/framework-laptop13pro-wallpapers/framework-laptop13pro-1.png'
#   '';
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.framework.wallpapers;

  mkPack =
    {
      id,
      url,
      hash,
    }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = "framework-${id}-wallpapers";
      version = "2026-04-24";
      src = pkgs.fetchzip {
        inherit url hash;
        stripRoot = false;
      };

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        bg_dir="$out/share/backgrounds/framework-${id}-wallpapers"
        mkdir -p "$bg_dir" "$out/share/gnome-background-properties"

        xml="$out/share/gnome-background-properties/framework-${id}.xml"
        {
          echo '<?xml version="1.0" encoding="UTF-8"?>'
          echo '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">'
          echo '<wallpapers>'
        } > "$xml"

        i=1
        while IFS= read -r -d "" f; do
          base=$(basename "$f")
          ext="''${base##*.}"
          name="''${base%.*}"
          slug="framework-${id}-$i"
          dest="$bg_dir/$slug.$ext"
          cp "$f" "$dest"

          {
            echo '  <wallpaper deleted="false">'
            echo "    <name>$name</name>"
            echo "    <filename>$dest</filename>"
            echo '    <options>zoom</options>'
            echo '    <shade_type>solid</shade_type>'
            echo '    <pcolor>#000000</pcolor>'
            echo '    <scolor>#000000</scolor>'
            echo '  </wallpaper>'
          } >> "$xml"

          kde_dir="$out/share/wallpapers/$slug/contents/images"
          mkdir -p "$kde_dir"
          ln -s "$dest" "$kde_dir/$slug.$ext"
          {
            echo '[Desktop Entry]'
            echo "Name=$name"
            echo "X-KDE-PluginInfo-Name=$slug"
          } > "$out/share/wallpapers/$slug/metadata.desktop"

          i=$((i + 1))
        done < <(find "$src" -type f \( -iname '*.png' -o -iname '*.jpg' \) -print0 | sort -z)

        echo '</wallpapers>' >> "$xml"

        runHook postInstall
      '';

      meta = {
        description = "Framework ${id} wallpaper pack";
        homepage = "https://frame.work/wallpapers";
        platforms = lib.platforms.all;
      };
    };

  packs = {
    desktop = mkPack {
      id = "desktop";
      url = "https://downloads.frame.work/assets/framework-desktop-wallpaper-pack.zip";
      hash = "sha256-MRCBf+8lWJMf6xys3aV4a5yeJOfrqU0ntoEGV7QAGe4=";
    };
    laptop12 = mkPack {
      id = "laptop12";
      url = "https://downloads.frame.work/assets/framework-laptop12-wallpaper-pack.zip";
      hash = "sha256-r6VCLMBd0HtR9YzDg94UB7FuuNa4PTsjvpPCR3MHKRA=";
    };
    laptop13 = mkPack {
      id = "laptop13";
      url = "https://downloads.frame.work/assets/framework-laptop13-wallpaper-pack.zip";
      hash = "sha256-biTp0uoEFScCyulszGSwdceC97xouOMQgoivB43vZpo=";
    };
    laptop13pro = mkPack {
      id = "laptop13pro";
      url = "https://downloads.frame.work/assets/framework-laptop13pro-wallpaper-pack.zip";
      hash = "sha256-BHo7glMjORE5IPRPTfScJ4QBXqiu/+Ga7oruH6rHYms=";
    };
    laptop16 = mkPack {
      id = "laptop16";
      url = "https://downloads.frame.work/assets/framework-laptop16-wallpaper-pack.zip";
      hash = "sha256-u+zWlIVZ/Gqk71F6r35Y1akLCwcVxcP/CzDZWcmsSU8=";
    };
  };
in
{
  options.hardware.framework.wallpapers = {
    enableAll = lib.mkEnableOption "all Framework wallpaper packs";
    desktop.enable = lib.mkEnableOption "the Framework Desktop wallpaper pack";
    laptop12.enable = lib.mkEnableOption "the Framework Laptop 12 wallpaper pack";
    laptop13.enable = lib.mkEnableOption "the Framework Laptop 13 wallpaper pack";
    laptop13pro.enable = lib.mkEnableOption "the Framework Laptop 13 Pro wallpaper pack";
    laptop16.enable = lib.mkEnableOption "the Framework Laptop 16 wallpaper pack";
  };

  config.environment.systemPackages = lib.concatLists [
    (lib.optional (cfg.enableAll || cfg.desktop.enable) packs.desktop)
    (lib.optional (cfg.enableAll || cfg.laptop12.enable) packs.laptop12)
    (lib.optional (cfg.enableAll || cfg.laptop13.enable) packs.laptop13)
    (lib.optional (cfg.enableAll || cfg.laptop13pro.enable) packs.laptop13pro)
    (lib.optional (cfg.enableAll || cfg.laptop16.enable) packs.laptop16)
  ];
}
