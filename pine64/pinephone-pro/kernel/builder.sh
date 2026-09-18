source $stdenv/setup
cat $patches | unxz | patch -p1 -N -r -||true 
cp -r $src $out
