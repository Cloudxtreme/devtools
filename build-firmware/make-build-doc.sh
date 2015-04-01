#!/bin/bash
#make-build-doc
#20150126rh
#20150331rh dev/test
#dev needs more work
#
# do be called AFTER build

#infos of installed packages found in 
#BUILDROOT/build_dir/target-mips-xxxx/root-$BOARD/usr/lib/opkg/status
#
#set -x

#scratch 
#tar without hidden dirs/files  tar -cvzf devtools.tar.gz devtools/ --exclude '.*'

set -u

    ######## Globals ##########
    HOMEROOT="/home/br15"
    BUILDROOT=$HOMEROOT"/barrier_breaker"	#TOPDIR=$(pwd)	#should be in (buildroot dir)
    PROJECT="BR15L" #libre-mesh
    PROJROOT=$HOMEROOT"/BR15L-MAIN"
	SAVEROOT=$PROJROOT"/builds/save/"
    
    	
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
	
	setGlobals(){
		
        getRouterDetails(){  # extract ARCH , ROUTER,MODEL from .config

	        #DEBH echo -ne "grep .config for ARCH &  BOARD .."
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

        #setGlobals
        getRouterDetails
        getSvnInfo
    } # setGlobals

    
    saveBuild(){
    
        #mkSaveDir create the save dir
        SAVEDIR="OWrt-"$wBRANCH-r$wREVISION-$wBOARD-$wMODEL-$PROJECT-$wDATE
        #SAVEDIR : OWrt-barrier_breaker-r44077-ar71xx-GLINET-BR15L-20150126-1749	
        DEBH echo "mkdir -p ${SAVEROOT}$SAVEDIR"
        #/home/br15/BR15L-MAIN/builds/save/OWrt-barrier_breaker-r44077-ar71xx-GLINET-BR15L-20150327-1326

        mkdir -vp ${SAVEROOT}$SAVEDIR
        
        wSOURCEBINDIR=$BUILDROOT/bin/$wBOARD/

        #saveFiles
	    DEBH echo "wSOURCEBINDIR : $wSOURCEBINDIR"
	    
        echo "start saving files.."
        echo "1."$BUILDROOT "->" ${SAVEROOT}$SAVEDIR 
        cp -f $BUILDROOT/".config" ${SAVEROOT}$SAVEDIR
        cp -f $BUILDROOT/"feeds.conf" ${SAVEROOT}$SAVEDIR

#        echo " copy files.."
#        cp -fvr $PROJROOT"/files" ${SAVEROOT}$SAVEDIR
        
        echo "tar files.."
        tar -czf ${SAVEROOT}$SAVEDIR/files.tar.gz $PROJROOT"/files"

        echo "tar root-ar71xx.."
 #tar -czf ${SAVEROOT}$SAVEDIR/root-ar71xx.tar.gz /home/br15/barrier_breaker/build_dir/target-mips_34kc_uClibc-0.9.33.2/root-ar71xx
        tar -czf ${SAVEROOT}$SAVEDIR/root-ar71xx.tar.gz $BUILDROOT/build_dir/target-mips_34kc_uClibc-0.9.33.2/root-ar71xx
    
        echo "opkg-info.."
        cp -f $BUILDROOT/build_dir/target-mips_34kc_uClibc-0.9.33.2/root-ar71xx/usr/lib/opkg/status ${SAVEROOT}$SAVEDIR
        
    } #saveBuild
    
    
######## main ###########
    echo -e "\n start : make-build-doc \n\n"
    
    DebugSw=1

    setGlobals
    saveBuild
    
 




