#!/bin/bash

fzon1="tmp/zon-waktusolat-page1.html"
fzon2="tmp/zon-waktusolat-page2.html"
fzon3="tmp/zon-waktusolat-page3.html"
fzon="tmp/zon-waktusolat.csv"
fzontmp="tmp/zon-waktusolattmp.csv"

curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php" > $fzon1
curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=2" > $fzon2
curl -s "http://www2.e-solat.gov.my/zon-waktusolat.php?PageNo=3" > $fzon3

#tr '[A-Z]' '\012' < ussmall

cat $fzon1 | hxnormalize | hxclean | tr "\n" "\ " | sed 's/\ \ //g' | sed 's/<tr\ /<TR /g' | sed 's/<td\ /<TD /g' |sed 's/<\/tr>/<\/TR>/g' | sed 's/<\/td>/<\/TD>/g' | sed 's/<\/TR>/<\/TR>\n/g' | sed -E 's/<\/TD>/<\/TD>\n/g' | sed 's/<TR\ class.*/<TR>/g' | sed 's/-->/\n/g' | sed 's/^\ //g' | grep '^<TD' | grep -v div | sed -E "s/^<TD\ class='tabletext' vAlign='top' align='left'>&nbsp;//g" | sed -E "s/<\/TD>//g" | sed -E "s/<TD align=\"left\" class=\"tabletext\" valign=\"top\">&nbsp;\ //g" > $fzon

cat $fzon2 | hxnormalize | hxclean | tr "\n" "\ " | sed 's/\ \ //g' | sed 's/<tr\ /<TR /g' | sed 's/<td\ /<TD /g' |sed 's/<\/tr>/<\/TR>/g' | sed 's/<\/td>/<\/TD>/g' | sed 's/<\/TR>/<\/TR>\n/g' | sed -E 's/<\/TD>/<\/TD>\n/g' | sed 's/<TR\ class.*/<TR>/g' | sed 's/-->/\n/g' | sed 's/^\ //g' | grep '^<TD' | grep -v div | sed -E "s/^<TD\ class='tabletext' vAlign='top' align='left'>&nbsp;//g" | sed -E "s/<\/TD>//g" | sed -E "s/<TD align=\"left\" class=\"tabletext\" valign=\"top\">&nbsp;\ //g" >> $fzon

cat $fzon3 | hxnormalize | hxclean | tr "\n" "\ " | sed 's/\ \ //g' | sed 's/<tr\ /<TR /g' | sed 's/<td\ /<TD /g' |sed 's/<\/tr>/<\/TR>/g' | sed 's/<\/td>/<\/TD>/g' | sed 's/<\/TR>/<\/TR>\n/g' | sed -E 's/<\/TD>/<\/TD>\n/g' | sed 's/<TR\ class.*/<TR>/g' | sed 's/-->/\n/g' | sed 's/^\ //g' | grep '^<TD' | grep -v div | sed -E "s/^<TD\ class='tabletext' vAlign='top' align='left'>&nbsp;//g" | sed -E "s/<\/TD>//g" | sed -E "s/<TD align=\"left\" class=\"tabletext\" valign=\"top\">&nbsp;\ //g" >> $fzon

cat $fzon > $fzontmp
ed - $fzontmp << EOF
,s/^/"/
,s/$/"/
,s/\ "$/"/
w
q
EOF

while read line1; do read line2; echo "${line2}, ${line1}"; done < $fzontmp > $fzon

cat $fzon
