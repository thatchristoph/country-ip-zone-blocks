
DEBUGSCRIPT=0
IPV="ipv6"

MY_DIR="$(dirname "$0")"

if [[ ! -v CTRYLIST ]]; then
        source ${MY_DIR}/country-list.sh
fi

LENLIST=${#CTRYLIST[@]}

p=0
k=0
while [ $k -lt ${LENLIST} ]
do
  p=$[ $p+1 ]
  m=$[ $k+1 ]
  CTRYNAME[$p]="${CTRYLIST[$k]}"
  echo ${CTRYNAME[$p]}
  CTRYABBV[$p]="${CTRYLIST[$m]}"
  echo ${CTRYABBV[$p]}
  k=$[ $k+2 ]
done
LENCTRY=${#CTRYNAME[@]}

if [ $DEBUGSCRIPT -eq 1 ];then
  for n in ${CTRYNAME[@]}
  do
    echo $n 
  done
  for n in ${CTRYABBV[@]}
  do
    echo $n 
  done
  echo $LENCTRY
fi

if [ $DEBUGSCRIPT -ne 1 ]; then
  WRKDIR=${MY_DIR}/country-ip-zones
  if [ ! -d ${WRKDIR} ]; then
    mkdir ${WRKDIR}
  fi
  #cd $WRKDIR

  i=0
  while [ $i -le ${LENCTRY} ]
  do 
#	echo "i : $i"
#	echo "LENCTRY : ${LENCTRY}"
#	echo "CTRYNAME[$i] : ${CTRYNAME[$i]}"
#	echo "CTRYABBV[$i] : ${CTRYABBV[$i]}"

    ipset -X "${CTRYNAME[$i]}.${IPV}"
    ipset -N "${CTRYNAME[$i]}.${IPV}" hash:net
    for j in $(cat ${WRKDIR}/${CTRYABBV[$i]}-aggregated.${IPV}.zone ); do ipset -A "${CTRYNAME[$i]}.${IPV}" $j; done

    i=$[ $i+1 ]

  done
fi
# Restore iptables
#/sbin/iptables-restore < /etc/iptables.firewall.rules

