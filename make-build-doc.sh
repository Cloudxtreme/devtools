#!/bin/bash
#make-build-doc
#20150126rh
#dev needs more work
#
# do be called AFTER build

#infos of installed packages found in 
#BUILDROOT/build_dir/target-mips-xxxx/root-$BOARD/usr/lib/opkg/status
#
#set -x
set -u

    ######## Globals ##########
    
    BUILDROOT="/home/br15/barrier_breaker"	#TOPDIR=$(pwd)	#should be in (buildroot dir)
	SAVEROOT=~/BR15-MAIN/BR15-builds/save/
    EDITION="BR15L" #libre-mesh
    	
	######  functions   ##########

	DEBH() {
		[[ $DebugSw = 1 ]] && "$@" || :
	}

	
	trap 'ExitHandler' 0 #trap EXIT 0
	ExitHandler() {
	   local _excode=$?
	   if [ 0 -eq $_excode ]
		then echo " exitcode : $_excode" 
		else echo " exitcode : $_excode"
	   fi
	    exit
	}
		
    getRouterDetails(){  # extract ARCH , ROUTER,MODEL from .config

	    DEBH echo -ne "grep .config for ARCH &  BOARD .."
	    wARCH=$(IFS="="; grep CONFIG_ARCH $BUILDROOT/.config | \
	    	        { read variable value ; echo "$value" | sed -e 's/\"//g'; })
	    DEBH echo -ne "found ARCH : $wARCH .. "

	    wBOARD=$(IFS="="; grep CONFIG_TARGET_BOARD $BUILDROOT/.config |\
	                { read variable value ; echo "$value" | sed -e 's/\"//g'; })
	    DEBH echo -ne "found board :$wBOARD .."
			# .config 	CONFIG_TARGET_ar71xx_generic_GLINET=y
			#		CONFIG_TARGET_ar71xx_generic=y
			#grep "^CONFIG_TARGET_"${wBOARD}'_generic_' $BUILDROOT/".config"
	    wMODEL=$(grep "^CONFIG_TARGET_${wBOARD}_generic_" $BUILDROOT/".config" |\
	                grep -o -P '(?<='generic_').*(?='=y')')
	    DEBH echo "found router model: $wMODEL"
}

  getSvnInfo(){	#get inforfomations frm svn

	wHERE=$(pwd)
	DEBH echo "working BUILDROOT :$BUILDROOT"
    cd $BUILDROOT
    
		#br15@deb7VM:~/barrier_breaker$ svn info
		#Path: .
		#URL: svn://svn.openwrt.org/openwrt/branches/barrier_breaker
		#Repository Root: svn://svn.openwrt.org/openwrt
		#Repository UUID: 3c298f89-4303-0410-b956-a3cf2f4a3e73
		#Revision: 44077
		#Node Kind: directory
		#Schedule: normal
		#Last Changed Author: nbd
		#Last Changed Rev: 44065
		#Last Changed Date: 2015-01-20 18:41:46 +0200 (Tue, 20 Jan 2015)

	wREVISION=$(echo $(svn info | grep Revision) |  sed 's/Revision: //')
	DEBH echo "svn Revision : $wREVISION"

	wBRANCH=$(echo $(svn info | grep URL: ) |  sed 's/URL: //')
	wBRANCH="${wBRANCH##svn:*/}"
	DEBH echo "wBRANCH : $wBRANCH"

    wDATE=$(date -d @"$(stat -c%Z .config)" +'%Y%m%d-%H%M') # use change date of .config file
    DEBH echo "wDATE : $wDATE"
	cd $wHERE
}

mkSaveDir(){
    # create the save dir
	saveDIR="OWrt-"$wBRANCH-r$wREVISION-$wBOARD-$wMODEL-$EDITION-$wDATE
    #saveDIR : OWrt-barrier_breaker-r44077-ar71xx-GLINET-BR15L-20150126-1749	
	DEBH echo "saveDIR : $saveDIR"

	DEBH echo "mkdir -p ${SAVEROOT}$saveDIR"
	#mkdir -p /home/br15/BR15-MAIN/BR15-builds/save/OWrt-barrier_breaker-r44077-ar71xx-GLINET-BR15L-20150126-1749

	#mkdir -p ${SAVEROOT}$saveDIR
}


saveBuild(){

    wSOURCEBINDIR=$BUILDROOT/bin/$wBOARD/
	DEBH echo "wSOURCEBINDIR : $wSOURCEBINDIR"

}
######## main ###########
    echo -e "\n start : make-build-doc \n\n"
    
    DebugSw=1

    getRouterDetails
    getSvnInfo
    mkSaveDir





