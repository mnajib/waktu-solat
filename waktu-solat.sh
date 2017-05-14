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
#    bash
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

defaultZone="SGR04"
if [ "$1" == "" ]; then
  zone=$defaultZone
else
  zone=$1
fi

file="/tmp/waktu-solat-${USER}.xml"

curl -s "http://www2.e-solat.gov.my/xml/today/?zon=${zone}" > $file
echo "======================================"

location=`cat $file | xmlstarlet sel -T -t -m /rss/channel -v "description" -n | sed 's/\ *//g' | sed 's/,/, /g'`
echo "Location: $zone ($location)"

cat $file | xmlstarlet sel -T -t -m /rss/channel -v "concat('Current date/time: ', dc:date)" -n
echo "--------------------------------------"

cat $file | xmlstarlet sel -T -t -m /rss/channel/item -v "concat(title, ' ', description)" -n
echo "======================================"
