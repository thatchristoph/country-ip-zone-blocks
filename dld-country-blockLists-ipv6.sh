
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

    # remove any old list that might exist from previous runs of this script
    rm "${WRKDIR}"/"${CTRYABBV[$i]}"-aggregated".${IPV}."zone

    # Pull the latest aggregated IP zone files
    if [[ ${IPV} == "ipv4" ]]; then 
      wget -P . http://www.ipdeny.com/ipblocks/data/aggregated/${CTRYABBV[$i]}-aggregated.zone
    fi

    if [[ ${IPV} == "ipv6" ]]; then
      wget -P . http://www.ipdeny.com/ipv6/ipaddresses/aggregated/${CTRYABBV[$i]}-aggregated.zone
    fi
    
    # Pull the latest non-aggregated IP zone files
    #wget -P . http://www.ipdeny.com/ipblocks/data/countries/${CTRYABBV[$i]}.zone

    mv ${CTRYABBV[$i]}-aggregated.zone ${WRKDIR}/${CTRYABBV[$i]}-aggregated".${IPV}."zone

    i=$[ $i+1 ]

  done
fi
# Restore iptables
#/sbin/iptables-restore < /etc/iptables.firewall.rules

