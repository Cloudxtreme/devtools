#!/bin/bash
#prep-lime.sh
# prepare lime building
#20150119 rh
cd openwrt

cp feeds.conf.default feeds.conf

echo "src-git libremap git://github.com/libremap/libremap-agent-openwrt.git" >> feeds.conf
echo "src-git lime https://github.com/libre-mesh/lime-packages.git" >> feeds.conf
#src-git lime https://github.com/libre-mesh/lime-packages.git;develop

scripts/feeds update -a
scripts/feeds install -a

#make -j3


#config lime

#feeds


mkdir -p files/etc/config/
cp feeds/lime/packages/lime-system/files/etc/config/lime files/etc/config/lime
gedit files/etc/config/lime

