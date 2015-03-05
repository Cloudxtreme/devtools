#!/bin/bash
#process-files.sh
#20140612
#eval & test rh
#20140612
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
TDIR=""	#mktemp
TFOLDER="files"
TARGETDIR="$TDIR/$TFOLDER"	#"/home/rh/Xfer/BRUCExfer/$TFOLDER/"

TARGETTEMP="/$TFOLDER"
SOURCEDIR="/RH-PC/DEV.firmware/" 
SOURCEFILES="${SOURCEDIR}/$TFOLDER"

BUILDFOLDER='/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build'
GITFOLDER='/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.git'
answer=


getDevFiles(){
set -x
	echo "getDevFiles from $SOURCEFILES -> $TDIR? [y]"
	read answer
	[ $answer == "y" ] || return 1
	echo "getDEVfiles"
	#cd  "$TEMPDIR/files"	#$TARGETTEMP
	#echo "removing $TARGETTEMP"
	#[ -e "$TARGETTEMP" ] && 
	#rm -r "$TEMPDIR/files" 	#"$TARGETTEMP" && 
	#mkdir "$TEMPDIR/files"					#mkdir $TARGETTEMP
	smbget -n -D -R -u rh -p T71597 smb:/$SOURCEFILES  #>> /dev/null;
set +x	
}


cleanFilesAndMark(){  # remove CR / 015 WINDOWS leftovers
	local f=
	echo "cleanFilesAndMark ? [y]"
	read answer
	[ $answer == "y" ] || { 
		echo "Abbruch" 
		return 1
		}
set -x
	echo "processing TDIR:$TDIR"
	ls "$TDIR"
	local tmark="$(date -u '+%Y%m%d %H:%M')-"	
	for f in $(find "$TDIR" -name "*" );do
			echo "file:$f"
			[ -d "$f" ] && continue	
			echo "insert timestamp"
			#sed -i "3s|^|#@rev.$tmark\n |" "$f"
			#replace "#@rev." with rev.date / timestamp
			#sed -i "s/#@rev./#@rev.$(date -u)/" "$f"
			sed -i "s/#@rev./#@rev.$tmark/" "$f"
			echo "sed remove CR frm $f" # doesnt work !!!!!!! sed -i -e "s/\^M//g" "$f"
			sed -i -e 's/\r$//' "$f"  # works ?! 12062012rh
	done
set +x
}

copyFiles(){
	echo "copyFiles to $BUILDFOLDER ? [y]"
	read answer
	[ $answer == "y" ] || { 
		echo "Abbruch" 
		return 1 
		}
	echo "clean BUILDFOLDER $BUILDFOLDER"
	rm -r $BUILDFOLDER/*	
	echo "copy to BUILDFOLDER:$BUILDFOLDER"
	cp -r  $TDIR/files/* "$BUILDFOLDER"

echo "copyFiles TDIR:$TDIR to GITFOLDER:$GITFOLDER ? [y]"
	read answer
	[ $answer == "y" ] || return 1
	#echo "remove GITFOLDER : $GITFOLDER/*"
	#rm -r $GITFOLDER/*
	echo "copy TDIR:$TDIR to GITFOLDER:$GITFOLDER"
	cp -r $TDIR/files/* "$GITFOLDER"
#
		
	rm -r ./files/*
	#mv files.tgz files-$(date -u '+%Y%m%d %H:%M:%S').tgz
}

do_git(){
	echo "do_git  commit? [y]"
	read answer
	[  $answer == "y" ] || { 
		echo "Abbruch" 
		return 1
 	}
	cd $GITFOLDER
	git add .
	git commit -a #-m "$date"

	echo "do_git push ? [y]"
	read answer
	[ $answer == "y" ] || { 
		echo "Abbruch" 
		return 1 
	}
	git push # Passww :sieben6207155
}

uploadFiles(){
	local _sourceDir="/home/rh/BRUCET/BRUCE14T/DEV.firmware/"  #"/home/rh/BRUCET/BRUCE14T/DEV.firmware/files.build"
	local _source="${_sourceDir}files.build"
	
 	local _ftpHost="ftp.trizonelabs.com" #"ftp.trizonelabs.com/BRUCET14T/BRupdate14Ta/"
	local _ftpDir="/BRUCET14T/BRupdate14Ta/"
	local FTPPASSWD="XCjiXTHe"
	local _ftpUser="trizonelabs.com"
 	local _ftpLog="files.wput.log"
	echo "upload of   $_sourceDir $_source to $_ftpHost$_ftpDir ? "
	read  answer
	[ $answer == "y" ] || { 
		echo "cancel" 
		return 1 
	}
	if wput -v -t 1 -T10 -o  $_ftpLog --basename=$_sourceDir $_source ftp://$_ftpUser:$FTPPASSWD@$_ftpHost$_ftpDir ;then
		echo " ok "
	else
		echo "ERROR wput upload"
	fi	
	read answer
}

doBackup(){
	echo "tar & backup ? "
	read  answer
	[ $answer == "y" ] || { 
		echo "cancel" 
		return 1 
	}
	read answer
}

doDialog(){
	DIALOG=${DIALOG=dialog}
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
	trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "BRUCET14T" \
	--title "process-files " --clear \
        --radiolist "slect one of the steps " 20 61 5 \
        "GET"  "smb copy DevFiles from RH-PC" ON \
        "CLEAN+MARK"  "clean files off CR and mark #@rev." off \
        "COPY"    "copy files to files.build & files.git" off \
        "UPLOAD"    "upload files to trizonelabs.com" off \
        "GIT"   "git update Bitbucket " off  2> $tempfile
retval=$?
choice=$(cat $tempfile)
case $retval in
  0)
    echo "'$choice'  selected"
	case $choice in
		GET)		getDevFiles;_gtsw="off";_clsw="ON";;
		CLEAN+MARK)	cleanFilesAndMark;_clsw="off";_cpsw="ON";;
		COPY)		copyFiles;_cpsw="off";_ulsw="ON";;
		UPLOAD)	uploadFiles;_ulsw="off";_git="ON";;
		GIT)			do_git;;
		*) echo "UNKNOWN command";;
	esac;;	

	1) echo "Cancel pressed.";exit;;
	*) echo "ESC pressed.";exit;;
 	esac
}

loopDialog(){
	_gtsw="ON" _clsw="off" _cpsw="off" _ulsw="off" _git="off"
	echo "loopDialog"
	while  doDialog; do
		echo "any key to preoceed"
		read answer
		#dialog --title "Hello" --msgbox 'Hello world!' 6 20
		clear
		echo "done" 
	done
}


#########MAIN

HERE="$pwd"
#touch $HOME/tmp
#TEMPDIR="$HOME/tmp"
#TDIR= ~tmp
TDIR="$(mktemp  -d)"
echo "TDIR:$TDIR created"
mkdir $TDIR/files
cd  $TDIR/files
echo "...in $TDIR/files"
ls -al

#echo "##### start SMB get files from $SOURCEDIR to $TARGETDIR"
loopDialog
#DEBUG smbtree 
#doDialog
#getDevFiles
#cleanFilesAndMark
#copyFiles
#uploadFiles
#do_git
#cd $HERE


