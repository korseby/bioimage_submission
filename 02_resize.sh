#!/usr/bin/env bash

IFS="
"

echo "#!/usr/bin/env bash" > resize_commands.sh
chmod 755 resize_commands.sh

for i in $(find . -name '*.jpeg'); do
	INPUT="$i";
	OUTPUT="$(echo $i | perl -pe 's/\.jpeg/\.jpg/')";
	NAME="$(basename $i .jpg)";
	COMMAND="convert \"${INPUT}\" -resize 800x600 -quality 90 \"${OUTPUT}\"";
	echo "echo \"${NAME}\"\:" >> resize_commands.sh
	echo "${COMMAND}" >> resize_commands.sh
done
