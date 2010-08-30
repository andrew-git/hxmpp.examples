#!/bin/bash

for i in $( ls -d */ ); do
	echo ---------------- BUILDING: $i
	cd $i
	haxe build.hxml
	cd ..
done
echo done.
