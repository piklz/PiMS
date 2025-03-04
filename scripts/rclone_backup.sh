		#add enable file for rclone
		[ -d ~/PiMS/PiMSBackups ] || sudo mkdir -p ~/PiMS/PiMSBackups/
		sudo chown pi:pi -R ~/PiMS/PiMSBackups

    if ls ~/PiMS/ | grep -w 'docker-compose.yml' >> /dev/null ; then

		#create the list of files to backup
        echo "./docker-compose.yml" >list.txt
        echo "./services/" >>list.txt
        echo "./volumes/" >>list.txt

        #setup variables
        logfile=./PiMSBackups/log_local.txt
        backupfile="PiMSbackup-$(date +"%Y-%m-%d_%H-%M").tar.gz"

        #compress the backups folders to archive
        echo -e "\e[32m=====================================================================================\e[0m"
        echo -e "\e[36;1m    Creating backup file ... \e[0m"
                        sudo tar -czf \
                        ./PiMSBackups/$backupfile \
                        -T list.txt
                        rm list.txt

        #set permission for backup files
        sudo chown pi:pi ./PiMSBackups/PiMS*

        #create local logfile and append the latest backup file to it
        echo -e "\e[36;1m    Backup file created \e[32;1m $(ls -t1 ~/PiMS/PiMSBackups/PiMS* | head -1 | grep -o 'PiMSbackup.*')\e[0m"
        sudo touch $logfile
        sudo chown pi:pi $logfile
        echo $backupfile >>$logfile

        #remove older local backup files
        #to change backups retained,  change below +5 to whatever you want (days retained +1)
        ls -t1 ./PiMSBackups/PiMS* | tail -n +5 | sudo xargs rm -f
        echo -e "\e[36;1m    Backup files are saved in \e[34;1m~/PiMS/PiMSBackups/\e[0m"
        echo -e "\e[36;1m    Only recent 4 backup files are kept\e[0m"

		# check if rclone is installed and gdrive: configured 
	if dpkg-query -W rclone 2>/dev/null | grep -w 'rclone' > /dev/null && rclone listremotes | grep -w 'gdrive:' &> /dev/null ; then

        #sync local backups to gdrive (older gdrive copies will be deleted)
		echo -e "\e[36;1m    Syncing to Google Drive ... \e[0m"
        rclone sync -P ./PiMSBackups --include "/PiMSbackup*"  gdrive:/PiMSBackups/ > ./PiMSBackups/rclone_sync_log
        echo -e "\e[36;1m    Sync with Google Drive \e[32;1mdone\e[0m"
        echo -e "\e[32m=====================================================================================\e[0m"
	else

        echo -e "\e[36;1m    \e[34;1mrclone\e[0m\e[36;1m not installed or \e[34;1m(gdrive)\e[0m\e[36;1m not configured \e[32;1monly local backup created\e[0m"
        echo -e "\e[32m=====================================================================================\e[0m"
	fi

else
                echo -e "\e[32m=====================================================================================\e[0m"
		        echo -e "                                                             "
		        echo -e "            \e[41m    =============================   \e[0m"
    			echo -e "            \e[41m     Containers not deployed yet    \e[0m"
               	echo -e "            \e[41m          Nothing to backup         \e[0m"
				echo -e "            \e[41m    =============================   \e[0m"
				echo -e "                                                             "
			    echo -e "\e[32m=====================================================================================\e[0m"
		fi