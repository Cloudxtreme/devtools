#!/bin/bash
#files.wput
#proj BRUCET BRupdate
#syn : ftp xfer files dir to URL
#main:rh
#20140512
#Test
set -x
# GLOBALS
 SOURCEBNAME="/home/rh/BRUCET/BRUCE14T/DEV.firmware/"  #"/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build"
 SOURCE="${SOURCEBNAME}files.build"
 
 TARGETHOST="ftp.trizonelabs.com" #"ftp.trizonelabs.com/BRUCET14T/BRupdate14Ta/"
 TARGETDIR="/BRUCET14T/BRupdate14Ta/"
 TRPASSWD="XCjiXTHe"
 TRUSER="trizonelabs.com"
 
 LOGFILE="files.wput.log"

tar -zcvf files.tgz $SOURCE

do_upload(){
	
	wput -v -t 1 -T10 -o  $LOGFILE --basename=$SOURCEBNAME $SOURCE ftp://$TRUSER:$TRPASSWD@$TARGETHOST$TARGETDIR

}

echo "start files.wput with $TARGETHOST $TARGETDIR $SOURCE"
do_upload

