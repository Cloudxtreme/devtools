#!/bin/sh
#build-save-docs.sh
#20150903rh
#script to build firmware + docs and save to specific folder
#

    #GLOBALS
    
    BUILDROOT="/home/br15/barrier_breaker"	# BuildRoot=$HOME/"barrier_breaker"
    #TOPDIR=$(pwd)	#should be in (buildroot dir)
	SAVEROOT=~/BR15-MAIN/BR15-builds/save/  # SaveDir="$HOME/BR15-MAIN/BR15-builds/save/"
    CONFFILE="${BuildRoot}/.config"	#config file to be searched   	

    EDITION="BR15L" #bruce-15-Libremesh

########################

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


    getConfRouterDetails(){  # extract ARCH , ROUTER,MODEL from .config

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


    getSvnInfo(){	#get revision, branch from svn

	    local wHere=$(pwd)
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

	    wRevision=$(echo $(svn info | grep Revision) |  sed 's/Revision: //')
	    DEBH echo "svn Revision : $wRevision"

	    wBranch=$(echo $(svn info | grep URL: ) |  sed 's/URL: //')
	    wBranch="${wBranch##svn:*/}"
	    DEBH echo "wBranch : $wBranch"

    }


    function prepBuild () {
    
        #change date of .config
        wDate=$(date -d @"$(stat -c%Z .config)" +'%Y%m%d-%H%M') # change date of .config file
        DEBH echo "wDate : $wDate"
	    cd $wHere
    }


    function buildFirmware (){

    }


    function prepDocs (){

    }


function saveDocs () {

}

#MAIN
    echo "build-save-docs:"
    prepBuild
    build
    prepDocs
    saveDocs


