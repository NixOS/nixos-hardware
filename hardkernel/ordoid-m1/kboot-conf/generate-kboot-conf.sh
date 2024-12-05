#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

usage() {
    echo "usage: $0 -c <path-to-default-configuration> -n <dtbName> [-g <num-generations>] [-d <target>]" >&2
    exit 1
}

target=/kboot.conf
default=                # Default configuration
numGenerations=0        # Number of other generations to include in the menu

while getopts "t:c:d:g:n:" opt; do
    case "$opt" in
        c) default="$OPTARG" ;;
        g) numGenerations="$OPTARG" ;;
        d) target="$OPTARG" ;;
        n) dtbName="$OPTARG" ;;
        \?) usage ;;
    esac
done

[ "$default" = "" -o "$dtbName" = "" ] && usage

tmp=$target.tmp

# Echo out an kboot.conf menu entry
addEntry() {
    local path=$(readlink -f "$1")
    local tag="$2" # Generation number or 'default'

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    timestampEpoch=$(stat -L -c '%Z' $path)
    timestamp=$(date "+%Y-%m-%d %H:%M" -d @$timestampEpoch)
    nixosLabel="$(cat $path/nixos-version)"
    extraParams="$(cat $path/kernel-params)"

    local kernel=$(readlink -f "$path/kernel")
    local initrd=$(readlink -f "$path/initrd")
    local dtbs=$(readlink -f "$path/dtbs")

    local id="nixos-$tag--$nixosLabel"

    if [ "$tag" = "default" ]; then
        echo "default=$id"
    fi

    echo -n "$id='"
    echo -n "$kernel initrd=$initrd dtb=$dtbs/$dtbName "
    echo -n "systemConfig=$path init=$path/init $extraParams"
    echo "'"
}

echo "# Hola!" > $tmp
addEntry $default default >> $tmp

if [ "$numGenerations" -gt 0 ]; then
    # Add up to $numGenerations generations of the system profile to the menu,
    # in reverse (most recent to least recent) order.
    for generation in $(
            (cd /nix/var/nix/profiles && ls -d system-*-link) \
            | sed 's/system-\([0-9]\+\)-link/\1/' \
            | sort -n -r \
            | head -n $numGenerations); do
        link=/nix/var/nix/profiles/system-$generation-link
        addEntry $link $generation
    done >> $tmp
fi

mv -f $tmp $target
