#!/usr/bin/env bash

IFS="
"

FILELIST="_liverworts_photos_list.txt"

echo "#!/usr/bin/env bash" > add_scale_bar_commands.sh
chmod 755 add_scale_bar_commands.sh

for i in $(find ultra/ -name '*.jpg' | sort); do
	INPUT="$i";
	OUTPUT="$(echo $i | perl -pe 's/ultra/high/' | perl -pe 's/\.jpg/\.jpeg/')";
	NAME="$(basename $i .jpg)";
	CAMERA="$(cat ${FILELIST} | grep ${NAME}$'\t' | cut -d$'\t' -f 19 | head -n 1)";
	OBJECTIVE="$(cat ${FILELIST} | grep ${NAME}$'\t' | cut -d$'\t' -f 8 | head -n 1)";
	MICROSCOPE="$(cat ${FILELIST} | grep ${NAME}$'\t' | cut -d$'\t' -f 5 | head -n 1)";
	MAGNIFICATION="$(cat ${FILELIST} | grep ${NAME}$'\t' | cut -d$'\t' -f 6 | head -n 1)";
	if [[ "${MICROSCOPE}" == "Balgen" ]]; then
		COMMAND="/Users/kristian/Desktop/liverworts/scale_bar/scale_bar.py -c /Users/kristian/Desktop/liverworts/scale_bar/scale_bar_distances.csv -i \"${INPUT}\" -o \"${OUTPUT}\" -s 0 -fc \"${CAMERA}\" -fms \"Bellow\" -fo \"${OBJECTIVE}\" -fmg \"${MAGNIFICATION}\"";
	else
		COMMAND="/Users/kristian/Desktop/liverworts/scale_bar/scale_bar.py -c /Users/kristian/Desktop/liverworts/scale_bar/scale_bar_distances.csv -i \"${INPUT}\" -o \"${OUTPUT}\" -s 0 -fc \"${CAMERA}\" -fo \"${OBJECTIVE}\" -fmg \"${MAGNIFICATION}\"";
	fi
	echo "echo \"${NAME}\"\:" >> add_scale_bar_commands.sh
	echo "${COMMAND}" >> add_scale_bar_commands.sh
done
