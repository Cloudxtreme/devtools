#!/bin/sh
#inst-pack-list.sh
#https://forum.openwrt.org/viewtopic.php?id=17381
#20150125rh
#adapted rh
#dev & test ok
#needs more work
#
#infos of installed packages found in 
#	BUILDROOT/build_dir/target-mips-xxxx/root-$BOARD/usr/lib/opkg/status
set -x

echo " create-ipkg-list"
echo " build list of packages installed in the in image"
TOPDIR="/home/br15/barrier_breaker"	#TOPDIR=$(pwd)	#should be in (buildroot dir)
echo "working TOPDIR :$TOPDIR"

echo "grep .config for  ARCH % BOARD"
arch=$(IFS="="; grep CONFIG_ARCH $TOPDIR/.config | { read variable value ; echo "$value" | sed -e 's/\"//g'; })
echo "found ARCH : $ARCH"
board=$(IFS="="; grep CONFIG_TARGET_BOARD $TOPDIR/.config | { read variable value ; echo "$value" | sed -e 's/\"//g'; })
echo "found board :$board"

echo "search for root-$board dir  beneath /target-mips-....."
WRKROOTDIR=$(find $TOPDIR/build_dir -type d -name root-ar71xx) # | grep 
echo "found WRKROOTDIR: $WRKROOTDIR"

STATUSF=$WRKROOTDIR/usr/lib/opkg/status
echo "status file is :$STATUSF"

echo "grep Package info:"
pakages=$(grep ^Package $STATUSF| sed -e 's/^Package: //g' | wc -l)

if [ "$1" = "" ]; then
        packages_list=$(grep ^Package $STATUSF -A2 ) #| sort | sed -e 's/^Package: /   /g')
else
        packages_list=$(grep ^Package $STATUSF | sort | sed -e 's/^Package: //g' | sed -n -e ":a" -e "$ s/\n/, /gp;N;b a")
fi

echo "Installed packages ($packages):"
echo "$packages_list"

