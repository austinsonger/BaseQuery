#!/bin/bash

# Author Github:   https://github.com/g666gle
# Author Twitter:  https://twitter.com/g666g1e
# Date: 12/4/2019
#
# Using the default BaseQuery directory
# Usage: ./query.sh test@example.com 
# Usage: ./query.sh test@
# Usage: ./query.sh @example.com
# Usage: ./query.sh /home/user/Desktop/file.txt
#
# Using an external BaseQuery directory
# Usage: ./query.sh test@example.com /home/user/Desktop/data
# Usage: ./query.sh test@ /home/user/Desktop/data
# Usage: ./query.sh @example.com /home/user/Desktop/data
# Usage: ./query.sh /home/user/Desktop/file.txt /home/user/Desktop/data
#
# Description:	First query.sh checks to make sure that the user is in the correct
#		directory. Checks to see if the query is a file or is a email address
#		calls the search.sh script with the correct params. The user is able 
#		to use this script in a few different ways. You can search for a specific 
#		email address, a username of an email address, any username for a specific 
#		domain name, or pass a path to a file to automate the past three options. 
#		If a external data/ directory is given as a second parameter the data will be
#		queried there instead of the normal ./data/ directory inside BaseQuery.

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

#  Checks to see if the user forgot to enter input
if [ $# -eq 1 ];then
	if [ "${PWD##*/}" == "BaseQuery" ];then
		# Checks to see if the file exists in the working directory
		if ! [ -e "$1" ];then
			#  Only one email (file doesn't exist)
			./search_rg.sh "$1"
		else
			# A file was given
			filename="$(echo "$1" | rev | cut -f 1 -d "/" | rev)" #test.txt
			printf "${GREEN}[+]${NC} Outputting all results to ${GREEN}./OutputFiles/""$(echo "$filename" | cut -f 1 -d "." )""_output.txt${NC}\n"
			cat "$1" | while read -r email;do
				#  The first param is the email address the second is telling ./search that it 
				#  is a file so the user is not prompted
				./search_rg.sh "$email" "$filename"
				
			done
		fi
	else
		printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	fi
	exit
fi

###################################################################################################################################################

#  Check to see if an external data directory was given
if [ $# -eq 2 ];then
	if [ "${PWD##*/}" == "BaseQuery" ];then
		# Checks to see if the file exists in the working directory
		if ! [ -f "$1" ];then
			#  Only one email (file doesn't exist)
			./search_rg_external.sh "$1" "$2"
		else
			# A file was given
			filename="$(echo "$1" | rev | cut -f 1 -d "/" | rev)" #test.txt
			printf "${GREEN}[+]${NC} Outputting all results to ${GREEN}./OutputFiles/""$(echo "$filename" | cut -f 1 -d "." )""_output.txt${NC}\n"
			cat "$1" | while read -r email;do
				#  The first param is the email address the second is telling ./search that it 
				#  is a file so the user is not prompted
				./search_rg_external.sh "$email" "$2"
				
			done
		fi
	else
		printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	fi
else
	printf "${YELLOW}[!]${NC} Please enter one email address or a file with one email address per line\n"
fi
