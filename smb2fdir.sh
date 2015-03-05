#!/bin/bash
#smb2fdir.sh
#27022012rh
#19052012rh
# get files from rh server and copy to /builddir/files
#
#set -e
#set -x
set -u
	_flist='bfilelist.txt'

	_targetdir='/home/rh/OpenWRT/trunk/target/linux/atheros'
	_sourcedir='//rh-pc/data_e/3zlRepos/BRUCE/alfa-livetest/' #_getdir='pannet-trunk-alfa/'

getfiles(){
	echo 
	echo "smbget  and filter files in $_flist"
	echo "--------------------"
	cat $_flist
	echo "--------------------"
	read yno

 while read -r file
 do
	[[ -z $file ||  "/" = "${file:0:1}" || "#" = "${file:0:1}" ]] && continue	
	#echo "file:$file firstchar:" ${file:0:1}
	#if [ "#" = "${file:0:1}" ]  
	 # then echo "$file : skipped"
	  #else
		echo "remove file  :$file"
		rm -f $file 
		echo -en "..smbget --quiet -n -D -u rh -p P71391 smb:${_sourcedir}${file}"
		if smbget --quiet -n -D -u rh -p P71391 smb:${_sourcedir}${file} >/dev/null 2>&1;
		then
			echo "got :$file.."
		else 
			echo "smbget error: "
			exit 1
		fi

		echo -en "..rename $file to $file.bak"		
		mv $file $file.bak
		echo " ..and filter CR"
		tr -d '\r' < $file.bak > $file
		rm $file.bak
	#fi
done < $_flist
#echo "delete files *.bak "
#rm *.bak
}


cpfiles(){
	
	while read -r file ;do # copy files to dirs in flist
	  [[ -z $file || "#" = "${file:0:1}" ]] && continue	
		#echo "file:$file firstchar:" ${file:0:1}
		if [ "/" = "${file:0:1}" ]   	#dir
		  then 				# build target dir
		    _tdir=${_bdir}${file:1}
		    echo "$file : set _tdir: $_tdir"
		  else
		   echo "copy $file to $_tdir"	 
	 	   [ -z "$_tdir" ] && echo "_tdir error:$_tdir" || cp -f $file $_tdir #-f -i
		fi
		 
	done < $_flist

}

main(){
	_bdir='/home/rh/OpenWRT/trunk/target/linux/atheros/base-files/' #"/home/rh/OpenWRT/8.09/files/" 
	_tdir=

echo -n "files g)et c)opy  [g | c ] to <$_bdir>"
read yno

case $yno in
        [g] | [yY][Ee][Ss] )
                echo "getfiles"
				read yno
		getfiles
                ;;

        [c] | [n|N][O|o] )
                echo "copy files";
				read yno
                cpfiles
                ;;
        *) echo "Invalid input"
            ;;
esac
	echo "copyfiles"
	#cpfiles
}

main $*
	

