#!/usr/bin/env bash

IFS="
"
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk17-temurin/Contents/Home"
export JAVA_OPTS='-Djna.library.path=/usr/local/Cellar/c-blosc/1.21.4/lib'
export PARALLEL=2



convert_ome_tiff() {
	i="$1"
	k="$(echo $i | perl -pe 's/(^\.\/|\.TIF)//g')"
	/opt/share/bioformats2raw-0.6.1/bin/bioformats2raw -p --max_workers=${PARALLEL} "${k}.TIF" "${k}.zarr" && \
	/opt/share/raw2ometiff-0.4.1/bin/raw2ometiff --max_workers=${PARALLEL} "${k}.zarr" "${k}.ome.tiff"  && \
	sync && \
	sleep 5 && \
	rm -rf "$k.zarr"
}



(
for j in *.TIF; do
	#((count=count%PARALLEL)); ((count++==0)) && wait
	convert_ome_tiff "$j"
done
)
