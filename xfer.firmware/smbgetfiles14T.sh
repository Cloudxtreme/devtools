#!/bin/bash
#smbgetfiles14.sh
#27022012rh
#20140507
#BRUCE14T
# get files  form PC win7 sourcedir to THIS dir
#
set -xeu
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

COMMENT
#_sourcedir="/rh-pc/pannet-trunk-alfa/"
#_sourcedir="/rh-pc/pannet-trunk-alfa/"
#_sourcedir="/rh-pc/data_e/3zlRepos/BRUCE/alfa-livetest/"
_sourcedir="/RH-PC/DEV.firmware/" 
_passwd="T71597"
_flist="BRtree.txt"
set -x
doFiles(){
echo "filter files in $_flist"
#for file in $(cat $_flist);
while read -r file
 do
	[ -z $file ] && continue	
	echo "file:$file firstchar:" ${file:0:1}
	if [ "#" = "${file:0:1}" ] #-o "/" = "${file:0:1}" ]
	  then echo "$file : skipped"
	  else
		echo "remove :$file"
		rm -f $file 
        smbget --quiet -n -D -u rh -p $_passwd smb:/${_sourcedir}${file} >> /dev/null;
		echo "rename $file to $file.bak"		
		#mv $file $file.bak
		# % sed -e "s/^M//" filename > newfilename
		#sed -e 's/^M//g' $file.bak > $file
		#sed -e 's/[^ -~]//g' $file.bak > $file # CAVE globbers files
	fi
done < $_flist
echo "delete files *.bak "
rm *.bak
}
	
#smbget --quiet -n -D -u rh -p T71597 smb:/${_sourcedir}${_flist} >> /dev/null;
smbget --quiet -n -D -u rh -p  -R T71597 smb://RH-PC/DEV.firmware/ >> /dev/null;
doFiles;

