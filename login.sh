#!/bin/bash

RED="\033[1.31m"
NO_COLOR="\033[00m"
GREEN="\033[2;32m"
MAGENTA="\033[2;35m"
BLANC="\e[97m"
HOSTNAME=$(uname -n)

LOAD1=$(awk -F " " '{print $1}' /proc/loadavg)
LOAD5=$(awk -F " " '{print $2}' /proc/loadavg)
LOAD15=$(awk -F " " '{print $3}' /proc/loadavg)
MEM=$(free -t -m | grep "Total" | awk '{print $3" MB";}')
MEM2=$(free -t -m  | grep "Mem" | awk '{print $2" MB";}')
RACINE=$(df -Ph | grep vg_sys-slash  | awk '{print $4}' | tr -d '\n')
USR=$(df -Ph | grep vg_sys-usr | awk '{print $4}' | tr -d '\n')

if [ -f /etc/redhat-release ];then

grep -q Linux /etc/redhat-release 2> /dev/null
  if [ $? -eq 0  ]
    then 
        REDHAT=$(cat /etc/redhat-release  | awk '{print $4}' | awk -F  "." '{print $1}')
  else

        REDHAT=$(cat /etc/redhat-release  | awk '{print $3}' | awk -F  "." '{print $1}')
  fi
fi

needrestart () {

	if [ -f /usr/bin/needs-restarting ]
    then
            if [ "$REDHAT" -eq 7  ] || [ "$REDHAT" -gt 7  ] 
                then 
			        RSERVICE=$(/usr/bin/needs-restarting -s 2> /dev/null)
			        RKERNEL=$(/usr/bin/needs-restarting -r  |egrep -v 'More|http' 2> /dev/null )
            else 
			        RSERVICE=$(/usr/bin/needs-restarting 2> /dev/null)
			        RKERNEL=$(/usr/bin/needs-restarting 2> /dev/null)
            fi
    elif [ -f /usr/sbin/needrestart ]
        then
            RSERVICE=$(/usr/sbin/needrestart -r l -b  2> /dev/null)
           echo $RSERVICE  | grep -q "NEEDRESTART-KEXP"   && RKERNEL=$( echo $RSERVICE |grep "NEEDRESTART-KEXP" )
    else 
            echo -e  "$MAGENTA yum install need-restarting ? $NO_COLOR"

	fi

}

echo -e " $GREEN
	=================== $BLANC$HOSTNAME$GREEN ===============================
$BLANC      - CPU usage ............. $MAGENTA $LOAD1,$LOAD5,$LOAD15 $BLANC
      - DISK SPACE ............ $MAGENTA $RACINE  restant sur slash $BLANC , $MAGENTA $USR restant sur /usr . $BLANC
      - MEMORY USED ................ $MAGENTA $MEM / $MEM2
    $GREEN     ================= $BLANC NEEDREBOOT $GREEN ================================ $NO_COLOR	  
"
needrestart
if [ !  -z "$RSERVICE" ]    
	then 
	echo -e  " $BLANC      - DES SERVICES NEED TO RESTART ..............  $MAGENTA \n$RSERVICE $NO_COLOR"
else 
	echo -e " $MAGENTA 0 services need RESTART "
fi
if [  ! -z "$RKERNEL" ]
	then 
	echo -e "$BLANC       - KERNEl NEED REBOOT........... \n$MAGENTA $RKERNEL "
	 echo -e "       $GREEN ============================== $NO_COLOR"

else 
	echo -e "	$GREEN ============================== $MAGENTA"
	echo -e " - NO REBOOT NEEDED , KERNEL OK ! $NO_COLOR "

fi 

