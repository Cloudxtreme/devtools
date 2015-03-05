#!/bin/bash
#treegraph.sh
#requires : 
#	treegraph.pl
#	dot
#	eog	debian imagviewer
set -x

filter="neato"	#twopi circo fdp sfdp patchwork osage

filterar="neato twopi circo fdp sfdp patchwork osage"

itree="/home/br15/openwrt/feeds/luci/applications/luci-splash"
dotf=$(basename $itree.dot)
gtype=png	#svg jpeg

echo "genertaing dotf : $dotf.$gtype"

[ -e "$dotf" ] && rm "$dotf"

perl treegraph.pl -f -q "$itree" > $dotf

echo "dot using gtype:$gtype - filter $filter"

#dot -T$gtype -K$filter -o "$dotf.$filter.$gtype" $dotf

for filter in $filterar
 do
  dot -T$gtype -K$filter -o "$dotf.$filter.$gtype" $dotf
done


eog "$dotf.$filter.$gtype"
