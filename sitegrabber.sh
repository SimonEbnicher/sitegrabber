#!/bin/bash
################################################################################
# Filename: sitegrabber.sh
# Author: Simon Ebnicher
# Description: Grabs status from netio website and stores it in SQlite database.
#              Sites to grab are stored in and read from SQlite table.
#              This program terminates after running through all sites once and
#              must be called periodically (for eg. by "cron").
# 
# Prerequisites: curl, mysql
################################################################################

################################################################################
### CONSTANTS

# Path to the logfile (make sure to have writing permissions there)
LOG_PATH="sitegrabber.log"

# Settings for database
DB_NAME="database"
DB_USER="username"
DB_PASS="password"

# Debug echoes a lot of information to stdout
DEBUG=0

# Delimiter for the batch output of mysql (only change if you know what you are
# doing)
DELIMITER="\t"

################################################################################
### FUNCTIONS
function log {
	echo "$(date '+%F %T'): $1" >> $LOG_PATH
}

################################################################################
### START SCRIPT

# INITIAL CHECKS
ERROR=0

# check if the log file is writeable
touch "$LOG_PATH" >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
	echo "$(date '+%F %T') ERROR: Fatal! Can not write to the log file - PERMISSION ISSUES! Exiting!"
	exit
fi

# check if sqlite3 and curl are installed otherwise log error and exit
mysql -V >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
	log "mysql not installed. Fatal offense!"
	ERROR=1
fi
curl -V >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
	log "curl not installed. Fatal offense!"
	ERROR=1
fi

# check if a critical error ocurred and exit
if [ "$ERROR" -ne 0 ]; then
	log "One or more fatal offenses found. Exiting!"
	exit
fi

# DO ACTUAL WORK

# read enabled stations from database
STATIONS=$(mysql -u$DB_USER -p$DB_PASS -D$DB_NAME -B --silent -e "SELECT id, ip, username, password FROM stations WHERE enabled=1;")
TIMESTAMP=$(date '+%F %T')

# for each line(station: parse parameters, curl website, parse website, write to database 
while read -r LINE
do
	# parse parameters
	LINE=$(echo "$LINE" | iconv -f iso-8859-1 -t us-ascii//TRANSLIT)
	read ID IP USER PASS <<< "$LINE"

	if [ "$DEBUG" -eq 1 ]; then
		echo "ID = $ID"
		echo "IP = $IP"
		echo "USER = $USER"
		echo "PASS = $PASS"
	fi

	# curl website
	WEBSITE=$(curl --connect-timeout 3 -u $USER:$PASS http://$IP/ 2>/dev/null | iconv -f iso-8859-1 -t us-ascii//TRANSLIT)
	if [ "$DEBUG" -eq 1 ]; then
		echo "curl --connect-timeout 3 -u $USER:$PASS http://$IP/ 2>/dev/null | iconv -f iso-8859-1 -t us-ascii//TRANSLIT"
		echo "$WEBSITE"
	fi
	
	# parse states
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>01.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH01=1
	else
		CH01=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>02.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH02=1
	else
		CH02=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>03.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH03=1
	else
		CH03=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>04.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH04=1
	else
		CH04=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>05.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH05=1
	else
		CH05=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>06.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH06=1
	else
		CH06=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>07.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH07=1
	else
		CH07=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>08.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH08=1
	else
		CH08=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>09.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH09=1
	else
		CH09=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>10.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH10=1
	else
		CH10=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>11.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH11=1
	else
		CH11=0
	fi
	STATESTR=$(echo "$WEBSITE" | grep -oP "<tr><td>12.*?ledo.{1,2}\.gif" | grep -oE "ledo.{1,2}\.gif")
	if [ "$STATESTR" = "ledon.gif" ]; then
		CH12=1
	else
		CH12=0
	fi
	AN01=$(echo "$WEBSITE" | grep -oP "ADC1.*?</tr>" | grep -o "<td> = .*</td>" | grep -oE "\-{0,1}[0-9]*[,\.]{0,1}[0-9]+" | tr "," ".")
	AN02=$(echo "$WEBSITE" | grep -oP "ADC2.*?</tr>" | grep -o "<td> = .*</td>" | grep -oE "\-{0,1}[0-9]*[,\.]{0,1}[0-9]+" | tr "," ".")
	AN03=$(echo "$WEBSITE" | grep -oP "ADC3.*?</tr>" | grep -o "<td> = .*</td>" | grep -oE "\-{0,1}[0-9]*[,\.]{0,1}[0-9]+" | tr "," ".")
	AN04=$(echo "$WEBSITE" | grep -oP "ADC4.*?</tr>" | grep -o "<td> = .*</td>" | grep -oE "\-{0,1}[0-9]*[,\.]{0,1}[0-9]+" | tr "," ".")

	if [ "$DEBUG" -eq 1 ]; then
		echo "Website ID = $ID"
		echo "Website IP = $IP"
		echo "Website USER = $USER"
		echo "Website PASS = $PASS"
		echo "CH01 = $CH01"
		echo "CH02 = $CH02"
		echo "CH03 = $CH03"
		echo "CH04 = $CH04"
		echo "CH05 = $CH05"
		echo "CH06 = $CH06"
		echo "CH07 = $CH07"
		echo "CH08 = $CH08"
		echo "CH09 = $CH09"
		echo "CH10 = $CH10"
		echo "CH11 = $CH11"
		echo "CH12 = $CH12"
		echo "AN01 = $AN01"
		echo "AN02 = $AN02"
		echo "AN03 = $AN03"
		echo "AN04 = $AN04"
		echo "**************************************************"
	fi

	# write into database
	$(mysql -u$DB_USER -p$DB_PASS -D$DB_NAME -B --silent -e "INSERT INTO records(id,timestamp,ch01,ch02,ch03,ch04,ch05,ch06,ch07,ch08,ch09,ch10,ch11,ch12,an01,an02,an03,an04) VALUES(\"$ID\",\"$TIMESTAMP\",\"$CH01\",\"$CH02\",\"$CH03\",\"$CH04\",\"$CH05\",\"$CH06\",\"$CH07\",\"$CH08\",\"$CH09\",\"$CH10\",\"$CH11\",\"$CH12\",\"$AN01\",\"$AN02\",\"$AN03\",\"$AN04\");")
	
done < <(echo "$STATIONS")

log "Run successful."
exit
