#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

while :
do 
	res=$(curl -s https://rtcquebec.ca/Default.aspx\?tabid\=95\&noArret\=1578\&noParcours\=800\&codeDirection\=2\&language\=fr-CA | sed -n '/horaireBorneVirtuelle/,/horaireEnteteAvis/p')
	busNumber=$(echo "${res}" | grep -oP 'parcoursNo">\K.*(?=</)')
	timeRemaining=( $(echo "${res}" | grep -oP 'minutes">\K[0-9]+(?=</)' | bc) )

	res2=$(curl -s https://rtcquebec.ca/Default.aspx\?tabid\=95\&noArret\=1578\&noParcours\=801\&codeDirection\=2\&language\=fr-CA | sed -n '/horaireBorneVirtuelle/,/horaireEnteteAvis/p')
	busNumber2=$(echo "${res2}" | grep -oP 'parcoursNo">\K.*(?=</)')
	timeRemaining2=( $(echo "${res2}" | grep -oP 'minutes">\K[0-9]+(?=</)' | bc) )

	if [ "${timeRemaining[0]}" -le 6 ]; then
		colorTime="${RED}"
	elif [ "${timeRemaining[0]}" -le 8 ]; then
		colorTime="${YELLOW}"
	elif [ "${timeRemaining[0]}" -gt 8 ]; then
		colorTime="${GREEN}"
	fi

	if [ "${timeRemaining2[0]}" -le 6 ]; then
		colorTime2="${RED}"
	elif [ "${timeRemaining2[0]}" -le 8 ]; then
		colorTime2="${YELLOW}"
	elif [ "${timeRemaining2[0]}" -gt 8 ]; then
		colorTime2="${GREEN}"
	fi

	echo -e "prochain bus numéro ${busNumber}  dans : ${colorTime}${timeRemaining[0]} min(s)${NC}, prochain bus numéro ${busNumber2}  dans : ${colorTime2}${timeRemaining2[0]} min(s)${NC}\e[1A"
	# notify-send "prochain bus numéro ${busNumber}  dans : ${colorTime}${timeRemaining} min(s)${NC}, prochain bus numéro ${busNumber2}  dans : ${colorTime2}${timeRemaining2} min(s)${NC}\e[1A"

	sleep 10
done
