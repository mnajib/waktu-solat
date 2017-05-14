#!/bin/bash

#fzon1="tmp/zon-waktusolat-page1.html"
#fzon2="tmp/zon-waktusolat-page2.html"
#fzon3="tmp/zon-waktusolat-page3.html"
fzon4="tmp/zon-waktusolat-page4.html"
fzon="tmp/zon-waktusolat.csv"
fzontmp="tmp/zon-waktusolattmp.csv"

#curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php" > $fzon1
#curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=2" > $fzon2
#curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=3" > $fzon3
curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php" > $fzon4
curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=2" >> $fzon4
curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=3" >> $fzon4

##tr '[A-Z]' '\012' < ussmall

cat $fzon4 | \
	hxnormalize | hxclean | \
	tr "\n" "\ " | \
	sed 's/\ \ //g' | \
	sed 's/<tr\ /<TR /g' | \
	sed 's/<td\ /<TD /g' | \
	sed 's/<\/tr>/<\/TR>/g' | \
	sed 's/<\/td>/<\/TD>/g' | \
	sed 's/<\/TR>/<\/TR>\n/g' | \
	sed -E 's/<\/TD>/<\/TD>\n/g' | \
	sed 's/<TR\ class.*/<TR>/g' | \
	sed 's/<!---able to update solution only--->/\n/g' | \
	sed 's/^\ //g' | \
	sed -E 's/<TR\ bgcolor=\"#.{6}\">/<TR>\n/g' | \
	grep '^<TD' | \
	grep 'tabletext' | \
	sed -E "s/<TD\ class='tabletext' vAlign='top' align='left'>//g" | sed -E "s/<\/TD>//g" | \
	sed -E "s/<TD align=\"left\" class=\"tabletext\" valign=\"top\">//g" | \
	sed -E "s/&nbsp;//g" | \
	sed -E "s/<div align=\"left\"><b>//g" | sed -E "s/<\/b><\/div>//g" | \
	sed -E "s/<TD class='tabletext' vAlign=top align=left>//g" | \
	sed -E "s/^\ *//g" | \
	sed -E "s/,\ */, /g" \
	> $fzon
#cat $fzon

cat $fzon > $fzontmp
ed - $fzontmp << EOF
,s/^/"/
,s/$/"/
,s/\ "$/"/
w
q
EOF
#cat $fzontmp

#cat $fzon > $fzontmp
while read line1; do 
	read line2
	read line3
	read line4
	#echo "${line1}, ${line4}, ${line2}, ${line3}" 
	echo "${line4}, ${line2}, ${line3}" 
done < $fzontmp > $fzon
cat $fzon
