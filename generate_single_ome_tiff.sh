#!/usr/bin/env bash

IFS="
"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk17-temurin/Contents/Home"
export JAVA_OPTS='-Djna.library.path=/usr/local/Cellar/c-blosc/1.21.1/lib'
export PARALLEL=24



convert_ome_tiff() {
	i="$1"
	k="$(echo $i | perl -pe 's/(^\.\/|\.jpeg)//g')"
	/opt/share/bioformats2raw-0.4.0/bin/bioformats2raw -p --max_workers=${PARALLEL} "${k}.tiff" "${k}.zarr" && \
	/opt/share/raw2ometiff-0.3.0/bin/raw2ometiff --max_workers=${PARALLEL} "${k}.zarr" "${k}.ome.tiff"  && \
	sync && \
	sleep 5 && \
	rm -rf "$k.zarr"
}



(
for j in $(find . -iname "*.jpeg"); do
	((count=count%PARALLEL)); ((count++==0)) && wait
	convert_ome_tiff "$j" &
done
)
