#!/bin/bash	

# Author Github:   https://github.com/g666gle	
# Author Twitter:  https://twitter.com/g666g1e	
# Date: 12/1/2019	
# Usage: ./compress.sh	
# Usage: ./compress.sh /home/user/full/path/to/folder	
# Description:	This script takes in no parameters, checks to make sure that the	
#		user is in the correct directory and compresses every top	
#		level directory using Facebook's zstd standard. Giving each file	
#		a .zst extension. Compression data is printed to the user.	


RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

#  Make sure the user is in the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then
	if [ $# -eq 0 ];then

		let orig_bytes=0
		declare -a arr
		#  Find all of the uncompressed directories 
		while read -r uncompressed_dir; do
			arr=(${uncompressed_dir})
			if [ "$uncompressed_dir" != "data/" ];then
				file_bytes=$(du -sb "$uncompressed_dir"/ | cut -f 1)
				let orig_bytes=$orig_bytes+$file_bytes
				name="$(echo "$uncompressed_dir" | cut -f 2- -d "/")"
				#tar --use-compress-program=zstd -cf data/0.tar.zst data/0
				tar --use-compress-program=zstd -cf data/"$name".tar.zst "$uncompressed_dir" && rm -rf "$uncompressed_dir"
			fi
			_constr+="${arr[2]}"	
		done< <(find data/ -maxdepth 1 -type d | sort)

		compressed_bytes=$(du -sb data/ | cut -f 1)
		if [[ $orig_bytes -ne 0 && $compressed_bytes -ne 0 ]];then
			comp_div_ori=$( awk -v orig="$orig_bytes" -v comp="$compressed_bytes" 'BEGIN{printf("%.2f\n",comp/orig*100)}' )
			multiples_compressed=$(( $orig_bytes/$compressed_bytes ))
			echo 
			printf "${RED}[*] Your data is $multiples_compressed""x times smaller! (~$comp_div_ori%% of the original size)${NC}\n"
			printf "${YELLOW}[!] Original number of bytes	$orig_bytes${NC}\n"
			printf "${YELLOW}[!] Compressed number of bytes	$compressed_bytes${NC}\n"

			printf "[*] Your data is $multiples_compressed""x times smaller! (~$percentage_compressed%% of the original size)\n" >> ./Logs/ActivityLogs.log
			printf "[!] Original number of bytes	$orig_bytes\n" >> ./Logs/ActivityLogs.log
			printf "[!] Compressed number of bytes	$compressed_bytes\n" >> ./Logs/ActivityLogs.log
		fi

	elif [ $# -eq 1 ];then
		# $1 should be the parent directory to the database ex) /home/user/Desktop/data
		let orig_bytes=0
		declare -a arr
		#  Find all of the uncompressed directories 
		while read -r uncompressed_dir; do
			arr=(${uncompressed_dir})
			file_bytes=$(du -sb "$uncompressed_dir"/ | cut -f 1)
			let orig_bytes=$orig_bytes+$file_bytes
			#  Grabs just the letter of the dir ex) a
			name="$(echo "$uncompressed_dir" | rev | cut -f 1 -d '/' | rev)"

			#cut_away_letter_dir=${uncompressed_dir%/*}
			#grab_last_dir="$(echo $cut_away_letter_dir | rev | cut -d '/' -f 1 | rev)"
			#path_second_to_last_dir=${1%/*}

			#echo $uncompressed_dir
			#echo $cut_away_letter_dir
			#echo $grab_last_dir
			#echo $path_second_to_last_dir
			#echo "$1/$name".tar.zst
			#echo -C "$path_second_to_last_dir $grab_last_dir"

			#echo "tar --use-compress-program=zstd -cvf $1/$name.tar.zst -C $1 $name"
			#exit
			if [ ! -f "$1"/"$name".tar.zst ]; then
				touch "$1"/"$name".tar.zst
			fi
			tar --use-compress-program=zstd -cf "$1"/"$name".tar.zst -C "$1" "$name" && rm -rf "$uncompressed_dir"
			#exit
			_constr+="${arr[2]}"	
		done< <(find "$1" -maxdepth 1 -type d | sort | tail -n +2)

		compressed_bytes=$(du -sb "$1" | cut -f 1)
		if [[ $orig_bytes -ne 0 && $compressed_bytes -ne 0 ]];then
			comp_div_ori=$( awk -v orig="$orig_bytes" -v comp="$compressed_bytes" 'BEGIN{printf("%.2f\n",comp/orig*100)}' )
			multiples_compressed=$(( $orig_bytes/$compressed_bytes ))
			echo 
			printf "${RED}[*] Your data is $multiples_compressed""x times smaller! (~$comp_div_ori%% of the original size)${NC}\n"
			printf "${YELLOW}[!] Original number of bytes	$orig_bytes${NC}\n"
			printf "${YELLOW}[!] Compressed number of bytes	$compressed_bytes${NC}\n"

			printf "[*] Your data is $multiples_compressed""x times smaller! (~$percentage_compressed%% of the original size)\n" >> ./Logs/ActivityLogs.log
			printf "[!] Original number of bytes	$orig_bytes\n" >> ./Logs/ActivityLogs.log
			printf "[!] Compressed number of bytes	$compressed_bytes\n" >> ./Logs/ActivityLogs.log
		fi
	else
		echo "ERROR: Wrong amount of parameters passed!"
		printf "ERROR: Wrong amount of parameters passed!" >> ./Logs/ActivityLogs.log
	fi
	
else
	# If the users working directory is not BaseQuery while trying to run the script
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	printf "ERROR: Please change directories to the BaseQuery root directory\n" >> ./Logs/ActivityLogs.log
fi
	
