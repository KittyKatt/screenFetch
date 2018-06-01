#!/bin/sh

LANG=C
LANGUAGE=C
LC_ALL=C

man=screenfetch.1
script=screenfetch-dev

version=$(grep 'scriptVersion=' $script | cut -d'"' -f2)
date=$(date +"%B %Y")

mv $man $man.old

echo ".TH SCREENFETCH \"1\" \"$date\" \"$version\" \"User Commands\"" > $man
grep -v -e '^.TH ' $man.old >> $man

for s in supported_distros supported_other supported_dms supported_wms ; do
	sed -i "/@${s}_start@/,/@${s}_end@/{/@${s}_start@/!{/@${s}_end@/!d}}" $man
	list="$(sed -e :a -e '/\\$/N; s/\\\n//; ta' $script | grep "${s}=" | cut -d'"' -f2)"
	sed -i "s:@${s}_start@:@${s}_start@\n${list}:" $man
done

