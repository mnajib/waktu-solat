#!/bin/bash
#
# Author:
#    Muhammad Najib bin Ibrahim <mnajib@gmail.com>
#
# Usage:
#    ~/bin/waktu-solat.sh SGR01
#    ~/bin/waktu-solat.sh SGR02
#    ~/bin/waktu-solat.sh SGR03
#    ~/bin/waktu-solat.sh SGR04
#
# Requirement:
#    xmlstarlet
#
# Install:
#    apt-get install xmlstarlet
#
# Zone:
#    SGR01 Gombak, H.Selangor, Rawang, H.Langat, Sepang, Petaling, S.Alam
#    SGR02
#    SGR03
#    SGR04 Putrajaya
#

#file='/tmp/waktu-solat-najib.xml'
#file="/tmp/waktu-solat-${USER}.xml"
file="tmp/waktu-solat.xml"
getzon="bin/zon-solat.sh"
zonelist="tmp/zonelist.csv"

defaultZone="SGR04"
if [ "$1" == "" ]; then
  zone=$defaultZone
else
  zone=$1
fi

# get list of zon solat
bash $getzon > $zonelist

# grep/awk/sed zone code
#zonecode=$zone
zonecode=`cat $zonelist | grep -i "$zone" | awk '{ print $1 }'| sed 's/"//g' | sed 's/,//g' | head -1`
#echo "zonecode=$zonecode"

# if get zone code failed
# print error and help/usage

#curl -s "http://www2.e-solat.gov.my/xml/today/?zon=${zone}" > $file
curl -s "http://www2.e-solat.gov.my/xml/today/?zon=${zonecode}" > $file
echo "======================================"

#cat $file | xmlstarlet sel -T -t -m /rss/channel -v "concat('Location: $zone (', description, ')')" -n

# Print zone
#location=`cat $file | xmlstarlet sel -T -t -m /rss/channel -v "description" -n | sed 's/\ *//g' | sed 's/,/, /g'`
#location=`cat $file | xmlstarlet sel -T -t -m /rss/channel -v "description" -n`
location=`cat $file | xmlstarlet sel -T -t -m /rss/channel -v "description" -n | sed 's/\ \ *//g' | sed 's/,/, /g' | sed 's/\ *$//g'`
#echo "Location: $zone ($location)"
echo "Location: $zonecode ($location)"

# Print current data and time
cat $file | xmlstarlet sel -T -t -m /rss/channel -v "concat('Current date/time: ', dc:date)" -n

echo "--------------------------------------"

# ...
cat $file | xmlstarlet sel -T -t -m /rss/channel/item -v "concat(title, ' ', description)" -n

echo "======================================"
