#!/bin/bash
#set -x
#extr-packg-dep-info.sh
#20150206rh
# extract informations from Makefiles
# for documentations

echo "########### extr-packg-dep-info.sh ##############"
BuildRoot=~/barrier_breaker
PackgRoot=${BuildRoot}/feeds/lime/packages
MkFile="Makefile"
InfoF="pkg-info.txt"
echo "---------- extract infos from: $PackgRoot ------------"

SectStr='SECTION:='		#admin
CategStr='CATEGORY:='	#Administration
TitleStr='TITLE:='			#Send system information to an AlterMap server
MaintStr='MAINTAINER:='	#Gui Iribarren <gui@altermundi.net>
DepdStr='DEPENDS:='		# +luci-lib-core +luci-lib-httpclient +luci-lib-json +luci-lib-nixio +libuci-lua
DescStr='/description'

		#grep "$SectStr \| $DepSt \| $CategStr" $PackgRoot/Makefile
		#find ~/barrier_breaker/feeds/lime/packages/ -type f -name 'Makefile'
		# -H print filename -h hide filename  -i ignore case  -A -B
		#find $PackgRoot/ -type f -name $MkFile -exec grep "$SectStr \| $DepSt \| $CategStr \| $DescStr" {} +

		#grep -r --include="Makefile" "mytarget" ./
		#find $PackgRoot/ -type f -name $MkFile -exec grep -h $DescStr {} +
		# ?? find $PackgRoot/ -type f -name $MkFile -exec make -n -d {} +

		#grep -r --include="$MkFile" -A 2 $DescStr $PackgRoot
		#sed -e '/abc/,/efg/!d' [file-with-content]
		#grep -H -r --include="$MkFile" -A 5 $DescStr $PackgRoot #| sed -n '/:define/{:start /endef/!{N;b start};/*/p}'

TempF="info.tmp"

createTempF(){ #find makefile and dump to $TempF adding separator after each found "Makefile"
	[ -e $TempF ] && rm $TempF
	touch $TempF
	separStr='\n============\n\n'
	find $PackgRoot/ -type f -name $MkFile -exec cat >>$TempF {} \; -exec printf "$separStr" >> $TempF \;
}


anaTempF(){
# analyse Makefile dumps in $TempF

#test awk & sed

#TempF=$PackgRoot/lime-full/Makefile  	| 
echo "#### cat $TempF ###########"
cat $TempF | awk '
    /endef/ { echo = 0 }
    /define/ { gsub("^.*define", "", $0); echo = 1 }
             { if (echo == 1) { print } }' # \
#	| sed '/Package\/\$(PKG_NAME)/d' \
#	| sed '/URL:=/d' \
#	| sed '/Build/d' \
#	| sed '/MAINTAINER:=/d'\
#	| sed '/INSTALL_DIR/d' \
#	| sed '/@/d' \
#	| sed '/\$/d'
echo "######## END ###########"

##	| sed 's/TITLE:=/\n/' \
#	| sed '/Build\/Compile/d'\
#sed 's/regexp/\'$'\n/g'
}


extrVal(){
   #parse $TempF for  specific values as PKG_NAME , TITLE ...
echo "parse $TempF to $InfoF"
  awk -F':=' '
#	{ print "+" $N }
	{ if ( $1 =="PKG_NAME" ) print $2  }
	{ if ( $1 ~ "TITLE" ) print "   " $2 }
#	{ if ( $N ~ "/description" ) print "   " $2 }
	{ if ( $1 ~ "DEPENDS" ) print "   " $2 "\n\n"}
	' $TempF > $InfoF

}

##############  main
	createTempF;
	extrVal;





