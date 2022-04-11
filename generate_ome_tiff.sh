#!/usr/bin/env bash

IFS="
"
export JAVA_OPTS='-Djna.library.path=/usr/local/Cellar/c-blosc/1.21.1/lib'

curdir="$(pwd)"
for j in $(ls -d */ | sort); do
	echo "   +----- $j"
	k="$(echo $j | perl -pe 's/\///g')"
	cd "$k"
	echo "$(echo $k | perl -pe 's/_/_\</' | perl -pe 's/ /\> /').TIF" > "$k.pattern"
	/opt/src/bioformats2raw-0.4.0/bin/bioformats2raw --max_workers=48 --max_cached_tiles=6400 "${k}.pattern" "${k}.zarr" && \
	/opt/src/raw2ometiff-0.3.0/bin/raw2ometiff --max_workers=48 "${k}.zarr" "${k}.ome.tiff" && \
	mv "${k}.ome.tiff" .. && \
	cd .. && \
	sync && \
	rm -rf "$j"
	cd "${curdir}"
done

