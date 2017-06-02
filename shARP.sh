#! /bin/bash 
# Forked by:
#▂▃▅▇█▓▒░ HIEHOOX7 ░▒▓█▇▅▃▂ 
#
# USAGE :
# sudo ./smARP.sh -[o;d;r] <iface>
# -o or --offense ==> attacks the arp spoofer once detected ( kicks them off the network )
# -d or --deffense ==> defences you from the arp spoofer
# -r or --reset ==> resets the interace state
# <iface> ==> network interface ( e.g wlan0 )


# This script needs root permissions to work
echo "Please provide root priveleges"
sudo clear

#############
# EXIT TRAP #
#############

#CTRL+C trap -- when you press CTRL+C the ctrl_c() function will be executed 
#this function does a 'graceful' exit of the script
trap ctrl_c INT
ctrl_c () {
	echo -e "\n${BOLD}--- CLEANING UP ---\n"
	echo -e "\n[${YELLOW}*${NC}] Stopping monitor mode.."
	sudo airmon-ng stop ${iface_mon}
	sudo ifconfig ${iface} down
	echo -e "\n[${YELLOW}*${NC}] Resetting mac.."
	sudo macchanger ${iface} -a
	sudo ifconfig ${iface} up
	echo -e "[${YELLOW}*${NC}] Restarting Network Manager.."
	sudo service network-manager restart
	clear
	echo -e "[${YELLOW}*${NC}] Exitting in 3..."
	sleep 1
	clear
	echo -e "[${YELLOW}*${NC}] Exitting in 2.."
	sleep 1
	clear
	echo -e "[${YELLOW}*${NC}] Exitting in 1."
	sleep 1
	sudo nmcli radio wifi on
cat << "EOF"

##########################
# THANKS FOR USING smARP #
###################################
# the credit for the script goes ##
# to the original creator of shARP#
# I just went ahead  ##############
# and forked it because ###### 
# i didn't like it  ##### 
#######################
# BY #
############################
#▂▃▅▇█▓▒░ HIEHOOX7 ░▒▓█▇▅▃▂ #
############################
EOF
echo -e ${YELLOW}
cat << "EOF"
              _
             ( )
             | |      _
             | |_ _  / |
         __  |-/ \ \/ /
        /_ `\|_| | | /
          `\ ` \_/_/-|
            \    '   |
             \  .`  /____________________
             |     |/                    \
            /     / | *Keep it cool brah |
            |     | \_   ________________/
             \     \  |/
              | .__.\
              \_____/ 
              
EOF
echo -e ${NC}
exit
}



#######################
# DECLARING VARIABLES #
#######################

# Defining colors
RED='\033[1;31m'
NB_RED='\033[0;31m' # NOT BOLD RED
GREEN='\033[1;32m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
LIGHTCYAN='\033[1;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' #No Color

#iface_mon=""

#default gateway ( e.g 192.168.1.1 )
ROUTER_GATEWAY=$(ip route list | sed -n -e "s/^default.*[[:space:]]\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\).*/\1/p")

#checking if the network interface is passed to the bash script, if not then ask for it
if [ -z $2 ]; then
   echo -n -e "[${YELLOW}?${NC}] Network Interface for script (i.e ${GREEN}wlan0${NC}):${GREEN} "
   read iface
   iface_mon=${iface}mon
   echo -e "${NC}"
else
   iface=$2   
   iface_mon=$2'mon'    # e.g wlan0mon
fi


#checking if the network interface is passed to the bash script, if not then ask for it
if [ -z $1 ]; then
   echo -n -e "[${YELLOW}?${NC}] Choose script mode (offense,defense,reset) : [${YELLOW}o;d;r${NC}] : "
   read script_arg
   script_arg='-'${script_arg}
   echo -e "${NC}"
else
   script_arg=$1   
fi

# Determining the router channel from wireless interface frequency using iwconfig
router_channel=`sudo iwconfig ${iface} | awk 'match($0,"Frequency"){print substr($0,RSTART+10,+5)}'`
if [[ ${router_channel} == '2.412' ]] ; then
	router_channel='1'
elif [[ ${router_channel} == '2.417' ]] ; then
	router_channel='2'
elif [[ ${router_channel} == '2.422' ]] ; then
	router_channel='3'
elif [[ ${router_channel} == '2.427' ]] ; then
	router_channel='4'
elif [[ ${router_channel} == '2.432' ]] ; then
	router_channel='5'
elif [[ ${router_channel} == '2.437' ]] ; then
	router_channel='6'
elif [[ ${router_channel} == '2.442' ]] ; then
	router_channel='7'
elif [[ ${router_channel} == '2.447' ]] ; then
	router_channel='8'
elif [[ ${router_channel} == '2.452' ]] ; then
	router_channel='9'
elif [[ ${router_channel} == '2.457' ]] ; then
	router_channel='10'
elif [[ ${router_channel} == '2.462' ]] ; then
	router_channel='11'
elif [[ ${router_channel} == '2.467' ]] ; then
	router_channel='12'
elif [[ ${router_channel} == '2.472' ]] ; then
	router_channel='13'
elif [[ ${router_channel} == '2.484' ]] ; then
	router_channel='14'
fi

###########################
# FULFILLING REQUIREMENTS #
###########################

# checks whether the packages needed are installed or not , and acts acordinglly
if [ $(dpkg-query -W -f='${Status}' macchanger 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo -e "\n MACCHANGER not detected , installing \n"
	sudo apt-get install macchanger
fi
if [ $(dpkg-query -W -f='${Status}' aircrack-ng 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo -e "\n AIRCRACK-NG not detected , installing \n"
	sudo apt-get install aircrack-ng
fi

#Creating a directory for files
if [  smARP-files/ = false ] && [ smARP-files/ != true ]; then
sudo mkdir smARP-files  
fi


##############
# RESET MODE #
##############

if [ " $script_arg " = ' -r ' ] || [ " $script_arg " = ' --reset ' ]; then
	ctrl_c
fi


################
# DEFENCE MODE #
################

#ascii art
cat ascii.art
echo -e "forked by ${NB_RED} ▂▃▅▇█▓▒░ 31CHEECH ░▒▓█▇▅▃▂  ${NC}"

if [ " $script_arg " = ' -d ' ] || [ " $script_arg " = ' --defence ' ]; then
	echo -e "\n ${CYAN} defence mode  ${NC}"
elif [ " $script_arg " = ' -o ' ] || [ " $script_arg " = ' --offense ' ]; then
	echo -e "\n ${NB_RED} offense mode  ${NC}"
fi

router_mac_old=`sudo arp gateway -i wlan0 | grep gateway | awk '{print $3}'`
iface_ipv4=`hostname -I`
echo -e "\n INTERFACE IPV4 ADDRESS : ${GREEN} ${iface_ipv4} ${NC}"
echo -e " ROUTER MAC ADDRESS : C${GREEN}${router_mac_old}${NC}"
echo -e " ROUTER CHANNEL : ${GREEN}${router_channel}${NC}"
echo -e "${YELLOW} scanning... ${NC}"
#uncomment the next line if you want to turn on logging
#sudo echo
#echo $(date +"%D") ${router_mac} > smARP-files/gateway.txt #writing mac to logfile 

while :
do
	router_mac_new=`sudo arp gateway -i ${iface}`
	router_mac_new=${router_mac_new%C*}  # delete the part after the C
	router_mac_new=${router_mac_new##*r}  # delete the part before the ether
	router_mac_new=${router_mac_new//[ ]/}
	router_mac=${router_mac_old//[ ]/}
	
	
	if [ " $router_mac_new " != " $router_mac " ]; then
		echo -e " Gateway MAC changed from ${GREEN} ${router_mac} ${NC} to ${RED} ${router_mac_new} ${NC} at time : " $(date +"%T") 
		echo -e "${RED} ${router_mac_new} ${NC} is likely ${BOLD} poisoning your arp cache ${NC}"
		echo -e "Attacker MAC : ${router_mac_new} --- $(date +"| %D | %H:%M:%S")" > smARP-files/attack-log.txt
		if [ " $script_arg " = ' -r ' ] || [ " $script_arg " = '--reset ' ] ; then
			#exectues the same function as if you press CTRL+C , see "EXIT TRAP" at the start of the code
			sudo ctrl_c
			exit
		elif [ " $script_arg " = '-d' ] || [ " $script_arg " = ' --defence ' ]; then
			echo -e " ${BOLD}Executing defense procedure${NC}"
			sudo airmon-ng check kill
			ifconfig ${iface} down
			service network-manager start
			ifconfig ${iface} up
			exit
		elif [ " $script_arg " = ' -o ' ] || [ " $script_arg " = ' --offence ' ]; then
			echo -e " ${BOLD}Executing attack procedure${NC}"
			sudo airmon-ng check kill
			sudo airmon-ng start ${iface}
			sudo ifconfig ${iface_mon} down
			sudo macchanger ${iface_mon} -a
			echo -e "${BOLD}switching channel${NC}"
			sudo iwconfig ${iface_mon} channel ${router_channel}
			sudo ifconfig ${iface_mon} up
			sleep 3
			echo -e "${BOLD} TAKING OUT THE ${RED} HARPOONS${BOLD}!${NC}"
			echo -e "${BOLD} deauthing attacker 1000 times"
			sudo aireplay-ng --deauth 1000 -c ${router_mac_new} -a ${router_mac} ${iface_mon}
			sleep 3
			sudo airmon-ng stop ${iface}
			sudo ifconfig ${iface_mon} up
			sudo service network-manager start
			sleep 5
			sudo nmcli radio wifi on
			sleep 5	
			exit
		fi
		exit
	fi
done
