#!/bin/bash

# Author Github:   https://github.com/g666gle
# Author Twitter:  https://twitter.com/g666g1e
# Date: 12/1/2019
# Usage: ./run.sh
# Description:	This is the main file of the BaseQuery program. It houses the interactive menu
#		and deals with all of the logic pertaining to the users choices. Calls all other 
#		scripts within the program. 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# change the window size to fit the art
# requires xterm as a dependency 
resize -s 25 134

#ctrl+C
trap finish INT

function finish {
	printf "[*] Exit Trap Reached (CTRL+C)\n" >> ./Logs/ActivityLogs.log
	clear
	exit
}
clear


#Make sure that the user is in the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then

	#Log entry
	echo "[*] Executed run.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log

	while true;do
		echo "           _               _                  _            _               _       _                  _            _    _        _   "
		echo "          / /\            / /\               / /\         /\ \            /\ \    /\_\               /\ \         /\ \ /\ \     /\_\ "
		echo "         / /  \          / /  \             / /  \       /  \ \          /  \ \  / / /         _    /  \ \       /  \ \\\\ \ \   / / / "
		echo "        / / /\ \        / / /\ \           / / /\ \__   / /\ \ \        / /\ \ \ \ \ \__      /\_\ / /\ \ \     / /\ \ \\\\ \ \_/ / /  "
		echo "       / / /\ \ \      / / /\ \ \         / / /\ \___\ / / /\ \_\      / / /\ \ \ \ \___\    / / // / /\ \_\   / / /\ \_\\\\ \___/ /   "
		echo "      / / /\ \_\ \    / / /  \ \ \        \ \ \ \/___// /_/_ \/_/     / / /  \ \_\ \__  /   / / // /_/_ \/_/  / / /_/ / / \ \ \_/    "
		echo "     / / /\ \ \___\  / / /___/ /\ \        \ \ \     / /____/\       / / / _ / / / / / /   / / // /____/\    / / /__\/ /   \ \ \     "
		echo "    / / /  \ \ \__/ / / /_____/ /\ \   _    \ \ \   / /\____\/      / / / /\ \/ / / / /   / / // /\____\/   / / /_____/     \ \ \    "
		echo "   / / /____\_\ \  / /_________/\ \ \ /_/\__/ / /  / / /______     / / /__\ \ \/ / / /___/ / // / /______  / / /\ \ \        \ \ \   "
		echo "  / / /__________\/ / /_       __\ \_\\\\ \/___/ /  / / /_______\   / / /____\ \ \/ / /____\/ // / /_______\/ / /  \ \ \        \ \_\  "
		echo "  \/_____________/\_\___\     /____/_/ \_____\/   \/__________/   \/________\_\/\/_________/ \/__________/\/_/    \_\/         \/_/  "
		echo 
		echo
		echo "Options:"
		echo "	       [1] Import Your data"
		echo "	       [2] Calculate Import Time"
		echo "	       [3] Query"
		echo "	       [4] Harvest Emails Using Hunter.io"
		echo "	       [5] Clear importedDB.log"
		echo "	       [6] Secret Message"
		echo "	       [Q] Quit"
		echo
		read -p "Option Number-> " answer

		#  Check to see if the answer is only letters
		if [[ "$answer" =~ ^[a-zA-Z]+$ ]];then
			if [[ "$answer" == [Qq] ]];then
				# Log entry
				echo "[*] run.sh COMMAND 'q'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo >> ./Logs/ActivityLogs.log
				clear
				exit
			fi

		#  Check to see if the answer is only numbers
		elif [[ "$answer" =~ ^[0-9]+$ ]];then
			
			if [ "$answer" -eq 1 ];then
				#Log entry
				echo "[+] run.sh COMMAND '1'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo "[!] Executing ./Import.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log
				read -p "Do you need to import data from an external drive or export data to a different location? [y/n] " external_answer
				if [[ $external_answer == [Nn] ]]; then
					start=$SECONDS
					./Import.sh
					stop=$SECONDS
					difference=$(( stop - start ))
					printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
					echo
				elif [[ $external_answer == [Yy] ]];then
					read -p "Enter Full Path for Import [Hit Enter For Default] " import_full_path
					read -p "Enter Full Path for Export [Hit Enter For Default] " export_full_path
					#  If the user chose defaults for both; run import normally
					if [[ "$import_full_path" == "" && "$export_full_path" == "" ]];then
						start=$SECONDS
						./Import.sh 
						stop=$SECONDS
						difference=$(( stop - start ))
						printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
						echo 

					#  See if only export path is provided
					elif [[ "$import_full_path" == "" && "$export_full_path" != "" ]];then
						#  Check to make sure the directory exists
						if [ -d "$export_full_path" ];then
							start=$SECONDS
							./Import.sh "$export_full_path"
							stop=$SECONDS
							difference=$(( stop - start ))
							printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
							echo
						else
							printf "${RED}[!]${NC} Invalid input entered, please enter a valid full direcotry path\n" 
						fi
					
					#  See if only import path is provided 
					elif [[ "$import_full_path" != "" && "$export_full_path" == "" ]];then
						# Make sure the import dir exists
						if [ -d "$import_full_path" ];then
							start=$SECONDS
							./ImportExternal.sh "$import_full_path"
							stop=$SECONDS
							difference=$(( stop - start ))
							printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
							echo
						else
							printf "${RED}[!]${NC} Invalid input entered, please enter a valid full direcotry path\n" 
						fi

					#  If the user wants to specify the import and export path
					else
						if [ -d "$import_full_path" ] && [ -d "$export_full_path" ];then
							start=$SECONDS
							./ImportExternal.sh "$import_full_path" "$export_full_path"
							stop=$SECONDS
							difference=$(( stop - start ))
							printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
							echo
						else
							printf "${RED}[!]${NC} Invalid input entered, please make sure both full directory paths exist!\n"
						fi
					fi
				else
					printf "${RED}[!]${NC} Invalid input entered, please enter Y or N\n" 
				fi # User answers

			elif [ "$answer" -eq 2 ];then
				echo
				while true;do
					printf "${YELLOW}[!]${NC} This writes to a temporary directory and won't touch your BaseQuery database!\n"
					printf "${YELLOW}[!]${NC} This will tell you how much time is needed to import the specified amount of lines...\n"
					read -p "('q' to quit) Lines>> " num_lines
					echo
					if [[ $num_lines != [Qq] ]]; then
						if [[ "$num_lines" =~ ^[0-9]+$ ]];then
							# Log Entry
							echo "[+] run.sh COMMAND '2' arg [$num_lines]	[ $(date) ]" >> ./Logs/ActivityLogs.log
							printf "${GREEN}[+]${NC} Starting Benchmark! This Will Take 30 Seconds.\n"
							/usr/bin/python3.7 benchmark.py "$num_lines"
						else
							printf "${YELLOW}[!]${NC} Invalid Input\n"
						fi
						echo

					else # If the user enters q or Q
						printf "${YELLOW}[!]${NC} Exiting Calculate Import Time\n"
						break
					fi
				done
				

			elif [ "$answer" -eq 3 ];then
				read -p "Do you need to search an external directory? [y/n] " external_answer
				while [[ $external_answer != [YyNn] ]];do
					read -p "Do you need to search an external directory? [y/n] " external_answer
				done
				if [[ $external_answer == [Yy] ]]; then
					read -p "Please provide the full path! ex) /home/user/Desktop/data >>" data_dir
					while [[ $data_dir == "" ]];do
						read -p "Please provide the full path! ex) /home/user/Desktop/data >>" data_dir
					done
				fi
				echo
				printf "Please enter enter an email address in one of the following formats \n"
				printf "	ex) test@example.com			 [ Searches for all passwords associated with this address ]\n"
				printf "	ex) test@				 [ Searches for all passwords for any email addresses starting with this username ]\n"
				printf "	ex) @example.com			 [ Searches for all passwords for any email addresses ending with this domain name ]\n"
				printf "	ex) /home/user/Desktop/email_list.txt	 [ Searches line by line through the file for all passwords for each email address ]\n\n"
				while true;do
					read -p "('q' to quit) Email>> " email
					#  If the user doesn't want to search an external BaseQuery directory
					if [[ $external_answer == [Nn] ]]; then
						if [[ $email != [Qq] ]]; then
							if [ "$email" != "" ];then
								# Log Entry
								echo "[+] run.sh COMMAND '3' arg [$email]	[ $(date) ]" >> ./Logs/ActivityLogs.log
								echo "[!] Executing query.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log
								./query.sh "$email"
								echo
							else
								continue
							fi
						else
							echo
							printf "${YELLOW}[!]${NC} Exiting Query\n"
							break
						fi
					#  The user wants the use an external directory
					else
						if [[ $email != [Qq] ]]; then
							if [ "$email" != "" ];then
								# Log Entry
								echo "[+] run.sh COMMAND '3' arg [$email]	[ $(date) ]" >> ./Logs/ActivityLogs.log
								echo "[!] Executing query.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log
								./query.sh "$email" "$data_dir"
								echo
							else
								continue
							fi
						else
							echo
							printf "${YELLOW}[!]${NC} Exiting Query\n"
							break
						fi
					fi
				done

				#  Compress all of the data
				echo 
				printf "${YELLOW}[!]${NC} Compressing all stored data\n"
				./compress.sh "$data_dir"
				printf "${GREEN}[+]${NC} Finished compressing!\n"
				echo
				
			elif [ "$answer" -eq 4 ];then
				echo
				echo "[+] run.sh COMMAND '4'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				printf "${RED}\tMake sure you added your apikey in Logs/api_keys.yml If you don't have one go to hunter.io to get one for free!${NC}\n"
			    printf "${YELLOW}[1]${NC} ${GREEN}Domain Search\t${NC} [Returns all the email addresses found using one given domain name, with sources]\n" 
			    printf "${YELLOW}[2]${NC} ${GREEN}Email Finder\t${NC} [Guesses the most likely email of a person using his/her first name, last name and a domain name]\n" 
			    printf "${YELLOW}[3]${NC} ${GREEN}Email Verifier\t${NC} [Checks the deliverability of a given email address, verifies if it has been found in our database]\n" 
			    printf "${YELLOW}[4]${NC} ${GREEN}Email Count\t\t${NC} [You can check how many email addresses Hunter has for a given domain]\n" 
			    printf "${YELLOW}[5]${NC} ${GREEN}Account Information\t${NC} [You can check your account information]\n" 
			    printf "${YELLOW}[6]${NC} ${GREEN}Help Menu\t\t${NC} [Explains every option]\n" 
			    printf "${YELLOW}[Q]${NC} ${GREEN}Quit${NC}\n\n"
			    read -p "Option Number -> " hunter_search

			    # Run until user quits
			    while [[ $hunter_search != [Qq] ]];do
				    while [[ "$hunter_search" != [1-6Qq] ]];do
				    	read -p "Option Number (1-6 or Q)-> " hunter_search
				    done
				    #  Domain Search
				    if [ "$hunter_search" -eq 1 ];then

				    	read -p "Would you like to output the results to a file? [Y/N] " out_to_file
				    	while [[ $out_to_file != [YyNn] ]];do
				    		read -p "Would you like to output the results to a file? [Y/N] " out_to_file
				    	done

				    	#  Asking for the Domain name ex) google.com
				    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
	    				read -p "" domain
	    				if [[ $domain == "" ]];then
	    					domain="None"
	    				fi
	    				#  Asking for the Company name ex) Google
	    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
	    				read -p "" company
	    				if [[ $company == "" ]];then
	    					company="None"
	    				fi

	    				#  Check to see if the user hit enter for both 
	    				while [[ $company == "None" && $domain == "None" ]];do
	    					printf "${RED}[!] Domain AND OR Company needs to be defined!${NC}\n"

					    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
		    				read -p "" domain
		    				if [[ $domain == "" ]];then
		    					domain="None"
		    				fi
		    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
		    				read -p "" company
		    				if [[ $company == "" ]];then
		    					company="None"
		    				fi
	    				done	

	    				printf "[NUMBER OF RESULTS RETURNED! Hit Enter for 10]${GREEN} Limit${NC}: "
	    				read -p "" limit
					    while [[ ! "$limit" =~ ^[0-9]+$  && "$limit" != "" ]];do
		    				printf "[MUST BE A NUMBER! Hit Enter for 10]${GREEN} Limit${NC}: "
		    				read -p "" limit
					    done				
	    				if [[ $limit == "" ]];then
	    					limit="None"
	    				fi

	    				printf "[THE NUMBER OF EMAILS TO SKIP! Hit Enter for 0]${GREEN} Offset${NC}: "
	    				read -p "" offset
					    while [[ ! "$offset" =~ ^[0-9]+$  && ! "$offset" == "" ]];do
		    				printf "[THE NUMBER OF EMAILS TO SKIP! Hit Enter for 0]${GREEN} Offset${NC}: "
		    				read -p "" offset
					    done
	    				if [[ $offset == "" ]];then
	    					offset="None"
	    				fi

	    				printf "['personal' or 'generic' Hit Enter for Both]${GREEN} Emails Type${NC}:"
	    				read -p "" emails_type
	    				while [[ $emails_type != "personal" && $emails_type != "Personal" && $emails_type != "generic" && $emails_type != "Generic" && $emails_type != "" ]];do
		    				printf "['personal' or 'generic' Hit Enter for None]${GREEN} Emails Type${NC}:"
		    				read -p "" emails_type
	    				done
	    				if [[ $emails_type == "" ]];then
	    					emails_type="None"
	    				fi

	    				# Check if the user wants to output to a file
	    				if [[ $out_to_file == [Yy] ]];then
				    		python3.7 hunter_io_API_calls.py -ds True --domain="$domain" --company="$company" --limit="$limit" --offset="$offset" --emails_type="$emails_type" --out_to_file="True"
				    	else
				    		python3.7 hunter_io_API_calls.py -ds True --domain="$domain" --company="$company" --limit="$limit" --offset="$offset" --emails_type="$emails_type" --out_to_file="False"
				    	fi

				    #  Email Finder
				    elif [ "$hunter_search" -eq 2 ];then

				    	#  Asking for the Domain name ex) google.com
				    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
	    				read -p "" domain
	    				if [[ $domain == "" ]];then
	    					domain="None"
	    				fi
	    				#  Asking for the Company name ex) Google
	    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
	    				read -p "" company
	    				if [[ $company == "" ]];then
	    					company="None"
	    				fi

	    				#  Check to see if the user hit enter for both 
	    				while [[ $company == "None" && $domain == "None" ]];do
	    					printf "${RED}[!] Domain AND OR Company needs to be defined!${NC}\n"

					    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
		    				read -p "" domain
		    				if [[ $domain == "" ]];then
		    					domain="None"
		    				fi
		    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
		    				read -p "" company
		    				if [[ $company == "" ]];then
		    					company="None"
		    				fi
	    				done

	    				printf "[Hit Enter for None] ${GREEN}First Name${NC}: "
	    				read -p "" first_name
	    				if [[ $first_name == "" ]];then
	    					first_name="None"
	    				fi

	    				printf "[Hit Enter for None] ${GREEN}Last Name${NC}: "
	    				read -p "" last_name
	    				if [[ $last_name == "" ]];then
	    					last_name="None"
	    				fi

	    				printf "[Hit Enter for None] ${GREEN}Full Name${NC}: "
	    				read -p "" full_name
	    				if [[ $full_name == "" ]];then
	    					full_name="None"
	    				fi

	    				#  Checks to make sure that either both first and last name are given or a full name is
	    				while [[ $first_name == "None" || $last_name == "None" ]] && [[ $full_name == "None" ]];do
	    					printf "\n${RED}If you don't specify a first AND last name you must specify a full name.${NC}\n"
		    				printf "[Hit Enter for None] ${GREEN}First Name${NC}: "
		    				read -p "" first_name
		    				if [[ $first_name == "" ]];then
		    					first_name="None"
		    				fi

		    				printf "[Hit Enter for None] ${GREEN}Last Name${NC}: "
		    				read -p "" last_name
		    				if [[ $last_name == "" ]];then
		    					last_name="None"
		    				fi

		    				printf "[Hit Enter for None] ${GREEN}Full Name${NC}: "
		    				read -p "" full_name
		    				if [[ $full_name == "" ]];then
		    					full_name="None"
		    				fi
	    				done

				    	python3.7 hunter_io_API_calls.py -ef True --domain="$domain" --company="$company" --first_name="$first_name" --last_name="$last_name" --full_name="$full_name"

				    #  Email Verifier
				    elif [ "$hunter_search" -eq 3 ];then
				    	printf "${GREEN}Email Address${NC}: "
	    				read -p "" email
					    while [[ $email == "" ]];do
					    	printf "${GREEN}Email Address${NC}: "
		    				read -p "" email
					    done
				    	python3.7 hunter_io_API_calls.py -ev True  --email="$email"

				    #  Email Count
				    elif [ "$hunter_search" -eq 4 ];then
				    	#  Asking for the Domain name ex) google.com
				    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
	    				read -p "" domain
	    				if [[ $domain == "" ]];then
	    					domain="None"
	    				fi
	    				#  Asking for the Company name ex) Google
	    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
	    				read -p "" company
	    				if [[ $company == "" ]];then
	    					company="None"
	    				fi

	    				#  Check to see if the user hit enter for both 
	    				while [[ $company == "None" && $domain == "None" ]];do
	    					printf "${RED}[!] Domain AND OR Company needs to be defined!${NC}\n"

					    	printf "[MUST BE DEFINED IF 'Company' IS NOT! Enter for None]${GREEN} Domain${NC}: "
		    				read -p "" domain
		    				if [[ $domain == "" ]];then
		    					domain="None"
		    				fi
		    				printf "[MUST BE DEFINED IF 'Domain' IS NOT! Enter for None]${GREEN} Company${NC}: " 
		    				read -p "" company
		    				if [[ $company == "" ]];then
		    					company="None"
		    				fi
	    				done	
					    python3.7 hunter_io_API_calls.py -ec True  --domain="$domain" --company="$company"

				    #  Account Information
				    elif [ "$hunter_search" -eq 5 ];then
					    python3.7 hunter_io_API_calls.py -ai True

				    #  Help
				    elif [ "$hunter_search" -eq 6 ];then
				    	python3.7 hunter_io_API_calls.py --help
				    fi
				    #  Wait to clear the screen until the user hits enter
				    read -sp "Press Enter to continue..." 
				    #  Restart the prompt until the user enters Q
				    clear
					echo
					echo "[+] run.sh COMMAND '4'	[ $(date) ]" >> ./Logs/ActivityLogs.log
					printf "${RED}\tMake sure you added your apikey in Logs/api_keys.yml If you don't have one go to hunter.io to get one for free!${NC}\n"
				    printf "${YELLOW}[1]${NC} ${GREEN}Domain Search\t${NC} [Returns all the email addresses found using one given domain name, with sources]\n" 
				    printf "${YELLOW}[2]${NC} ${GREEN}Email Finder\t${NC} [Guesses the most likely email of a person using his/her first name, last name and a domain name]\n" 
				    printf "${YELLOW}[3]${NC} ${GREEN}Email Verifier\t${NC} [Checks the deliverability of a given email address, verifies if it has been found in our database]\n" 
				    printf "${YELLOW}[4]${NC} ${GREEN}Email Count\t\t${NC} [You can check how many email addresses Hunter has for a given domain]\n" 
				    printf "${YELLOW}[5]${NC} ${GREEN}Account Information\t${NC} [You can check your account information]\n" 
				    printf "${YELLOW}[6]${NC} ${GREEN}Help Menu\t\t${NC} [Explains every option]\n" 
				    printf "${YELLOW}[Q]${NC} ${GREEN}Quit${NC}\n\n"
				    read -p "Option Number -> " hunter_search
				done
			    printf "${YELLOW}[!]${NC} Exiting Harvest Emails Using Hunter.io\n"


			elif [ "$answer" -eq 5 ];then
				read -p "Are you sure? This log file contains all hashes for previously imported databases! [y/n] " answer
				while [[ "$answer" != [YyNn] ]];do
					printf "${YELLOW}[!]${NC} Please enter either \"y\" or \"n\"!\n"
					read -p "Are you sure? This log file contains all hashes for previously imported databases! [y/n] " answer 
				done

				if [[ "$answer" == [Yy] ]];then
					: > Logs/importedDBS.log
					printf "${GREEN}[!] importedDBS.log has been cleared!${NC}\n"
				fi

			elif [ "$answer" -eq 6 ];then
				# Log Entry
				echo "[+] run.sh COMMAND '5'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo
				echo "Hey... thanks for downloading BaseQuery, I've spent way too many hours coding this"
				echo "BaseQuery is a OSINT tool to help you organize and query all those pesky public databases/combo-lists you have laying around"
				echo "With a quadruple nested structure and a careful design your queries should be INSTANTANEOUS! Or ya know like really fast."
				echo "Something broken? Check the logs and then message me!"
				echo "For more information regarding use check the README.md file"
				echo "Found a bug? Just want to talk? Message me on GitHub or Twitter https://github.com/g666gle"
				echo "					                        https://twitter.com/g666g1e"
				echo "													          V2"
				echo "Give credit where credit's due:"
				printf "@ZacEllis on Github: \n\tHis fork of BaseQuery started to implement importing from an external directory, I stole some of his code\n"
				printf "@VonStruddle on Github: \n\tWrote PyHunter, an awesome hunter.io interface, which I use (option 4) and made a nice interactive menu for\n"
				echo 

			fi

		fi
		read -sp "Press Enter to continue..." 
		clear
		
	done
else
	#Log entry
	echo "[!] ERROR: run.sh NOT executed in the BaseQuery directory; Exiting	[ $(date) ]" >> ./Logs/ActivityLogs.log
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
fi


