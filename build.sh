#!/bin/bash

builded=0
for i in $( ls -d */ ); do
	if [ $(echo $i | sed 's%^_%%') = $i ]
	then
		cd $i
		if [ -e build.hxml ]
		then
			echo $builded --- $i
			haxe build.hxml
			builded=$((builded+1))
		fi
		cd ..
	fi
done
echo done:$builded
