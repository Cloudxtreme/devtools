#!/bin/bash
#save-builds
# copies build bin files to extra save dir together with info.file (rev...)
#20150120rh
#20150202rh dev/test

#set -x
set -e
set -u


#places for informations :
#	profiles : /BuildRoot/target/linux/ar71xx/generic/profiles
#   BUILDROOT/tmp/ info files

#useful build commands

#make kernel_menuconfig
#svn diff target/linux/

#ionice -c 3 nice -n 20 make -j 2 V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log | egrep -i '(warn|error)'
#make V=s 2>&1 | tee build.log | grep -i error


#search .config for details

    #CONFIG_TARGET_ar71xx_generic_GLINET=y
    #openwrt-ar71xx-generic-gl-inet-v1-squashfs-sysupgrade.bin

    #CONFIG_TARGET_PREINIT_IFNAME=""
    #CONFIG_TARGET_PREINIT_IP="192.168.1.1"
    #CONFIG_TARGET_PREINIT_NETMASK="255.255.255.0"
    #CONFIG_TARGET_PREINIT_BROADCAST="192.168.1.255"

    #CONFIG_PACKAGE_firewall=y
    #CONFIG_DEFAULT_dnsmasq=y
    #CONFIG_DEFAULT_odhcp6c=y
    #CONFIG_DEFAULT_odhcpd=y

    #CONFIG_DEFAULT_ppp=y
    #CONFIG_DEFAULT_ppp-mod-pppoe=y
    
    #CONFIG_AUDIO_SUPPORT=y

    # CONFIG_BUSYBOX_DEFAULT_IPADDR is not set
    # CONFIG_BUSYBOX_DEFAULT_IPLINK is not set
    # CONFIG_BUSYBOX_DEFAULT_IPROUTE is not set
    # CONFIG_BUSYBOX_DEFAULT_IPTUNNEL is not set
    # CONFIG_BUSYBOX_DEFAULT_IPRULE is not set
#####################################################

set -x

    SaveDir="$HOME/BR15-MAIN/BR15-builds/save/"
    BuildRoot=$HOME/"barrier_breaker"
    cf="${BuildRoot}/.config"	#config file to be searched

    mkdir -p  $TargetDir	#make subdirs

	######  functions   ##########

	DEBH() {
		[[ $DebugSw = 1 ]] && "$@" || :
	}

	
	trap 'ExitHandler' 0 #trap EXIT 0
	ExitHandler() {
	   local _excode=$?
	   if [ 0 -eq $_excode ]
		then echo "exitcode $_excode" 
		else echo " exitcode $_excode"
	   fi
	    exit
	}
		
    createTargetNames(){

        Board=$(grep "CONFIG_TARGET_BOARD" $cf | cut -d \" -f 2)  # get chipset/Board 'ar71xx'

            #grep 'CONFIG_TARGET_ar71xx' $cf |grep =y
            #grep "CONFIG_TARGET_${Board}" $cf |grep =y	#yields in
    		#CONFIG_TARGET_ar71xx=y
    		#CONFIG_TARGET_ar71xx_generic=y
    		#CONFIG_TARGET_ar71xx_generic_GLINET=y

        RouterTitle=$(grep "^CONFIG_TARGET_${Board}_generic_" $cf)	#CONFIG_TARGET_ar71xx_generic_GLINET=y
            #exampl a="CONFIG_TARGET_ar71xx_generic_GLINET=y"; b=${a%=y};echo "b:$b";c=${b##*_};echo "c:$c"

        RouterTitle=${RouterTitle%=y}	#cut '=y'
        RouterTitle=${RouterTitle#*_}	#cut front until first '_' 
        RouterTitle=${RouterTitle#*_}	# and second ->	'ar71xx_generic_GLINET'

        Router=${RouterTitle##*_}	#cut frm front until last '_' -> 'GLINET'

        HereDir=$(pwd)
        cd $BuildRoot

        #get svn revision
        Revision=$(echo $(svn info | grep Revision) |  sed 's/Revision: //')

        TargetDir="${SaveDir}${Board}"	#Router

        #RouterTitle="ar71xx-generic-gl-inet-v1"
        #"openwrt-ar71xx-generic-gl-inet-v1-squashfs-sysupgrade.bin" "ar71xx-generic-GLINET"

        BuildFile="openwrt-$RouterTitle-squashfs-sysupgrade.bin"

        echo "BuildFile:$BuildFile : TargetDir:$TargetDir Board:$Board RouterTitle: $RouterTitle  Revision: $Revision"
    }

    copyBuild2Target(){
        #save bin files  #.i.e. openwrt-ar71xx-generic-gl-inet-v1-squashfs-sysupgrade.bin
        echo cp -vu --backup=numbered "$BuildRoot/bin/$Board/$BuildFile" /$TargetDir/$RouterTitle-r$Revision"-squashfs-sysupgrade.bin"

        #save build config
        echo cp -vu --backup=numbered .config /$TargetDir/$RouterTitle-r$Revision".config"

        #save svn info
        svn info . > svninfo.txt
        svn info feeds/packages >> svninfo.txt
        svn info feeds/luci >> svninfo.txt

        echo cp -vu --backup=numbered svninfo.txt /$TargetDir/$RouterTitle-r$Revision"-svninfo.txt"
    }
    
    
    ########## MAIN ###########
    
    
    

