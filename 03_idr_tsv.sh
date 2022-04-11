#/usr/bin/env bash

for i in _tsv-raw/3-res/*; do
	sp="$(echo $i | perl -pe 's/(.*\/|\.tsv.*)//g')"
	./_tsv_res_2_idr.r "_tsv-raw/3-res/${sp}.tsv" "./_tsv-raw/_liverworts_photos_list.tsv" "_tsv-raw/5-idr/${sp}"
	sleep 1
done

# Python
#count=0
#for i in _tsv-raw/5-idr/*; do
#	count=$[${count}+1]
#	if [[ $count -eq 1 ]]; then
#		head -n 1 "${i}" > ./idr0000-scapaniaceae-assays.tsv
#	else
#		./_tsv_merge.py -i1 ./idr0000-scapaniaceae-assays.tsv -i2 "${i}" -o ./idr0000-scapaniaceae-assays.tsv
#	fi
#done

# R
./_tsv_merge.r ./_tsv-raw/5-idr ./idr0000-scapaniaceae-assays.tsv


