#!/bin/bash
# @author : dax // shdax
# @name   : Generate Tracking number & Validasi delivered

function check_tracking()
{
    GETAPI=$(curl -sL "https://api.ship24.com/api/parcels/${1}?lang=en" \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: en-US,en;q=0.5' --compressed \
    -H 'Referer: https://www.ship24.com/' \
    -H 'Content-Type: application/json' \
    -H 'Origin: https://www.ship24.com' \
    -H 'Connection: keep-alive' \
    --data-raw '{"userAgent":"","os":"Windows","browser":"Firefox","device":"Unknown","os_version":"windows-10","browser_version":"82.0","uL":"en-US"}')
    if [[ $GETAPI =~ 'tracking_number' ]]; then
        if [[ $GETAPI =~ 'status":"Delivered' ]]; then
            stat=$(echo $GETAPI | jq .data.events[].status | head -1 | cut -d '"' -f 2)
            echo "[ + ] $1 Found! [ Status ? ${stat} ]"
            echo "$1" >> RESULT-TRACKING-Delivered.txt
        else
            echo "[ + ] $1 Found! [ Status ? Unknown ]"
            echo "$1" >> RESULT-TRACKING-Unknown.txt
        fi
    fi
}
function generate_tracking()
{
    NUMRAND=$(shuf -i10000-99999 -n1)
    echo "AQ5888${NUMRAND}CN" >> TEMP.TRACKING
    echo "CH1203${NUMRAND}US" >> TEMP.TRACKING
    echo "CH1253${NUMRAND}US" >> TEMP.TRACKING
    echo "CH1288${NUMRAND}US" >> TEMP.TRACKING
    echo "CN0104${NUMRAND}JP" >> TEMP.TRACKING
    echo "CP0000${NUMRAND}TM" >> TEMP.TRACKING
    echo "CP0619${NUMRAND}TR" >> TEMP.TRACKING
    echo "CP4357${NUMRAND}CN" >> TEMP.TRACKING
    echo "CP9853${NUMRAND}HK" >> TEMP.TRACKING
    echo "CY0004${NUMRAND}CN" >> TEMP.TRACKING
    echo "EB7416${NUMRAND}CN" >> TEMP.TRACKING
    echo "EE0065${NUMRAND}IL" >> TEMP.TRACKING
    echo "EP7258${NUMRAND}MY" >> TEMP.TRACKING
    echo "EV9385${NUMRAND}CN" >> TEMP.TRACKING
    echo "LB0034${NUMRAND}CN" >> TEMP.TRACKING
    echo "LZ6180${NUMRAND}CN" >> TEMP.TRACKING
    echo "LZ7233${NUMRAND}CN" >> TEMP.TRACKING
    echo "LZ7606${NUMRAND}CN" >> TEMP.TRACKING
    echo "RB0746${NUMRAND}SG" >> TEMP.TRACKING
    echo "RN2394${NUMRAND}NL" >> TEMP.TRACKING
    echo "RR0829${NUMRAND}RU" >> TEMP.TRACKING
    echo "RR1186${NUMRAND}RU" >> TEMP.TRACKING
    echo "RR3153${NUMRAND}TO" >> TEMP.TRACKING
    echo "RV0551${NUMRAND}HK" >> TEMP.TRACKING
    echo "RV5261${NUMRAND}CN" >> TEMP.TRACKING
    echo "RZ1094${NUMRAND}MH" >> TEMP.TRACKING
    echo "UD5938${NUMRAND}NL" >> TEMP.TRACKING
    echo "UJ9990${NUMRAND}CN" >> TEMP.TRACKING
    echo "UM6045${NUMRAND}US" >> TEMP.TRACKING
    echo "UU0093${NUMRAND}CN" >> TEMP.TRACKING
    echo "HH0054${NUMRAND}US" >> TEMP.TRACKING
}

sleep 3s && rm -rf LIST-TRACKING.txt TEMP.TRACKING

read -p "[ + ] Melakukan berapa kali putar ? " PUTAR
echo "[ + ] Let's go package portal"
echo "[ + ] Generate tracking number"
for L in `seq 1 $PUTAR`;
do
    generate_tracking $L
done
cat TEMP.TRACKING | sort -u | shuf >> LIST-TRACKING.txt

echo "[ + ] Generate tracking number done"
LIST="LIST-TRACKING.txt"
read -p "[ + ] Send to (5/10/15/...): " SENDTO
read -p "[ + ] Delay(2/5/10/...): " WDELAY
CALC=0
IFS=$'\r\n' GLOBIGNORE='*' command eval 'LIST=($(cat $LIST))'
for (( i = 0; i <"${#LIST[@]}"; i++ )); do
 
  SITES="${LIST[$i]}"
 
  SENDd=$(expr $CALC % $SENDTO)
  if [[ $SENDd == 0 && $CALC > 0 ]]; then
    sleep $WDELAY
  fi
  check_tracking $SITES &
  CALC=$[$CALC+1]
done
wait
