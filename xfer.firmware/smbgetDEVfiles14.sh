#!/bin/bash
#smbgetDEVfiles14.sh
#20140518
#tested /eval
#BRUCE14T
# get files  form PC win7 sourcedir to THIS dir
#
#set -xeu
:<<'COMMENT'
Usage: smbget [OPTION...]
  -a, --guest                 Work as user guest
  -e, --encrypt               Encrypt SMB transport (UNIX extended servers only)
  -r, --resume                Automatically resume aborted files
  -U, --update                Download only when remote file is newer than local file or local file is missing
  -R, --recursive             Recursively download files
  -u, --username=STRING       Username to use
  -p, --password=STRING       Password to use
  -w, --workgroup=STRING      Workgroup to use (optional)
  -n, --nonprompt             Don't ask anything (non-interactive)
  -d, --debuglevel=INT        Debuglevel to use
  -o, --outputfile=STRING     Write downloaded data to specified file
  -O, --stdout                Write data to stdout
  -D, --dots                  Show dots as progress indication
  -q, --quiet                 Be quiet
  -v, --verbose               Be verbose
  -P, --keep-permissions      Keep permissions
  -b, --blocksize=INT         Change number of bytes in a block
  -f, --rcfile=STRING         Use specified rc file
WORKGROUP
	\\RH-PC          		
		\\RH-PC\Users          	
		\\RH-PC\IPC$           	Remote-IPC
		\\RH-PC\H$             	Standardfreigabe
		\\RH-PC\G$             	Standardfreigabe
		\\RH-PC\F$             	Standardfreigabe
		\\RH-PC\DEV.firmware   	
		\\RH-PC\C$             	Standardfreigabe
		\\RH-PC\ADMIN$         	Remoteverwaltung
		\\RH-PC\!IDEAS         	
	\\DEBIAN6ESXI    		debian6esxi server
		\\DEBIAN6ESXI\IPC$           	IPC Service (debian6esxi server)
		\\DEBIAN6ESXI\print$         	Printer Drivers
rh@debian6esxi:~/Xfer$ 

rh@debian6esxi:~/Xfer/BRUCExfer$ smbget --quiet -R -n -D -u rh -p T71597 smb://RH-PC/DEV.firmware/files/ >> /dev/null;
creates files folder
cp -r ./SourceFolder ./DestFolder
find . -name *.bak -exec rm {} \;
#find $TARGETDIR -type f -exec removeCR{} \; >results.out
#find $TARGETDIR -name \*.* -exec cat {} \;
#find $TARGETDIR -name \*.* -exec removeCR {} \;
COMMENT

PASSWD="T71597"

TFOLDER="files"
TARGETDIR="./$TFOLDER"	#"/home/rh/Xfer/BRUCExfer/$TFOLDER/"

TARGETTEMP="/$TFOLDER"
SOURCEDIR="/RH-PC/DEV.firmware/" 
SOURCEFILES="${SOURCEDIR}/$TFOLDER"

BUILDFOLDER='/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build/'
#"/home/rh/BRUCET/BRUCET14T/DEV.firmware/files.build/"
	    	#"/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build/"
GITFOLDER='/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.git/'

getDevFiles(){
	echo "getDevFiles from $SOURCFILES ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	echo "getDEVfiles"
	#echo "removing $TARGETTEMP"
	#[ -e "$TARGETTEMP" ] && 
	rm -r "./files" #"$TARGETTEMP" && 
	mkdir "files"	#mkdir $TARGETTEMP
	cd "files" 	#$TARGETTEMP
	smbget -n -D -R -u rh -p T71597 smb:/$SOURCEFILES  #>> /dev/null;
}

cleanFilesAndMark(){  # remove CR / 015 WINDOWS leftovers
	echo "cleanFilesAndMark ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	#TFILES="${TARGETDIR}*"
	echo "processing TARGETDIR $TARGETDIR"
	ls "./files" # "$TARGETDIR"
for f in $(find "$TARGETDIR" -name "*" );do
		#echo "file:$f"
	  	[ -d "$f" ] && continue	
		#echo "insert timestamp"
		#sed -i "3s|^|#rev.$(date '+%Y%m%d %H:%M' )\n |" "$f"
#replace "#rev." with rev.date / timestamp
	sed -i "s/##rev./##rev.$(date -u)/" "$f"
		#echo "rename $f to $f.bak"		
		#mv $f $f.bak
		#echo " tr remove CTRL M"
		#tr -d '\r' < $f.bak > $f
		#sed -e "s/^M//" "$f.bak" > "$f" #sed -i -e '/^M/d' "README.md"
		echo "sed remove CR frm $f"
		sed -i -e "s/\^M//g" "$f"
		#echo "remove $f.bak"
		#rm "$f.bak"
done
}

copyFiles(){
	echo "copyFiles to $BUILDFOLDER ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	#clean BUILDFOLDER
	#rm -r  /home/rh/BRUCET/archive/files14T/*
	echo "copy to BUILDFOLDER:$BUILDFOLDER"
	cp -r ./files/* "$BUILDFOLDER"
#	copy to BUILDFOLDER:/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build/
#	cp: cannot stat `./files/*': No such file or directory
#cp -r ./files/* /home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build/

	echo "copyFiles to GITFOLDER:$GITFOLDER ? [y]"
	read answer
	[ $answer == "y" ] || exit 0
	echo "copy to GITFOLDER:$GITFOLDER"
	cp -r ./files/* "$GITFOLDER"
}

do_git(){
	echo "do_git ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	#cd /home/rh/BRUCET/archive/files14T/
	cd $GITFOLDER
	git add .
	git commit -a #-m "$date"

	echo "do_git push ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	git push # Passww :sieben6207155
}

#########MAIN
echo "###################### start SMB get files from $SOURCEDIR to $TARGETDIR"
#smbtree 
getDevFiles
cleanFilesAndMark;
copyFiles
do_git



