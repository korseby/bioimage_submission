#!/usr/bin/env bash

IFS="
"
export JAVA_OPTS='-Djna.library.path=/usr/local/Cellar/c-blosc/1.21.4/lib'

curdir="$(pwd)"
for j in $(ls -d */ | sort); do
	echo "   +----- $j"
	k="$(echo $j | perl -pe 's/\///g')"
	cd "$k"
	echo "$(echo $k | perl -pe 's/_/_\</' | perl -pe 's/ /\> /').TIF" > "$k.pattern"
	/opt/share/bioformats2raw-0.6.1/bin/bioformats2raw "${k}.pattern" "${k}.zarr" && \
	/opt/share/raw2ometiff-0.4.1/bin/raw2ometiff "${k}.zarr" "${k}.ome.tiff" && \
	mv "${k}.ome.tiff" .. && \
	cd .. && \
	sync && \
	rm -rf "$j"
	cd "${curdir}"
done

