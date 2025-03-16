{
  stdenv,
  raw_disk_image,
  vm_config,
  utillinux,
  pigz,
  e2fsprogs,
}:

stdenv.mkDerivation {
  name = "avf_image.tar.gz";

  nativeBuildInputs = [
    utillinux
    pigz
    e2fsprogs
  ];

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    diskImage=$(echo ${raw_disk_image}/*.img)

    OFFSETS=($(sfdisk -l $diskImage -o Start,Sectors | tail -n 2 | grep -o "[0-9]*"))

    echo $out > build_id

    # bs=512 -> sector size is 512, skip=start sector, count=size in sectors
    dd if=$diskImage of=efi_part bs=512 skip="''${OFFSETS[0]}" count="''${OFFSETS[1]}"
    dd if=$diskImage of=root_part bs=512 skip="''${OFFSETS[2]}" count="''${OFFSETS[3]}"

    # can be removed once android e2fsck supports this feature
    tune2fs -O ^orphan_file root_part

    cp ${vm_config} vm_config.json

    sed -i "s/{efi_part_guid}/$(sfdisk --part-uuid $diskImage 1)/g" vm_config.json
    sed -i "s/{root_part_guid}/$(sfdisk --part-uuid $diskImage 2)/g" vm_config.json

    contents=(
    build_id
    root_part
    efi_part
    vm_config.json
    )

    # --sparse option isn't supported in apache-commons-compress
    tar cv -I pigz -f $out -C . "''${contents[@]}"
  '';
}
