#!/bin/bash

#první stránka dokumentu
read -p "Vlož adresu první stránky a stiskni [ENTER]: " FIRST_URL
#poslední stránka dokumentu
read -p "Vlož poslední stránku a stiskni [ENTER]: " LAST_URL
#název vytvořeného dokumentu
NAME_TITLE="book.djvu"

IFS='_' read -ra NAMES <<< "$FIRST_URL"
IFS='.' read -ra URL_SUPP <<< "${NAMES[1]}"
IFS='=' read -ra URL_TTTT <<< "${URL_SUPP[1]}"

CORE_URL=${NAMES[0]}"_"									# kramerius.nkp.cz/kramerius/document/ABA001_
URL_FIRST_IDENT=${URL_SUPP}								# 444a003a  [4176700001]
URL_FIRST_COUNT=${URL_TTTT[1]}								# 6666185	[17554324]
URL_SUPPLEMENT="."${URL_TTTT[0]}"="							# .djvu?id=

IFS='_' read -ra LASTURL <<< "$LAST_URL"
IFS='.' read -ra LAST_URL_SUPP <<< "${LASTURL[1]}"		

URL_LAST_IDENT=${LAST_URL_SUPP}								# 444a011a 	[4176700170]

echo "Počítám pole adres..."

#--------------------------------------VÝPOČET ADDRES----------------------------------------------------------------#

FIRST_IDENT_INDEX=${URL_FIRST_IDENT:(-4)}						# 444a003a  ->   003a  
CORE_IDENT=${URL_FIRST_IDENT::-4}			
IS_PERIODICAL=1										# MÁ NA KONCI PÍSMENO
IS_FIRST_TRANSIT=1 									# 1PRUCHOD->a 2PRUCHOD->b
IDENT=""

#test konec ident je písmeno dej 4 znaky [3 znaky]
if [  "${URL_FIRST_IDENT:(-1)}" == "a" ];then						# JE TO ČASOPIS?
	#vytvoření pole ident časopis
	L_Ident=${FIRST_IDENT_INDEX%?};
		while [[ "$IDENT" != "$URL_LAST_IDENT" ]];do
			if [ $IS_FIRST_TRANSIT -eq 1 ];then
				temp=$(printf "%03d" $L_Ident)
				IDENT=$CORE_IDENT$temp'a'
				LIST_IDENT=(${LIST_IDENT[@]} "$IDENT")
		
				IS_FIRST_TRANSIT=0
			else
				temp=$(printf "%03d" $L_Ident)
				IDENT=$CORE_IDENT$temp'b'
		
				LIST_IDENT=(${LIST_IDENT[@]} "$IDENT")
				IS_FIRST_TRANSIT=1		
				((L_Ident++))
			fi
		done										
else
	P_IDENT=${FIRST_IDENT_INDEX}
	while [[ "$IDENT" != "$URL_LAST_IDENT"  ]]; do
		temp=$(printf "%04d" $P_IDENT)
		IDENT=$CORE_IDENT$temp
		LIST_IDENT=(${LIST_IDENT[@]} "$IDENT")
		((P_IDENT++))
	done											
fi

echo "Sestavuji adresy....

#------------------------------------------SESTAVENÍ ADRESS-----------------------------------------------------------------#

for i in "${LIST_IDENT[@]}";do
	if [[ -n "$i" ]];then
		URL=$CORE_URL$i$URL_SUPPLEMENT$URL_FIRST_COUNT
		OUT_NAME=$i".djvu"
		#sestaveni adresy stránky a stažení do aktualního adresáře
		wget $URL -O "$OUT_NAME"
		((URL_FIRST_COUNT=URL_FIRST_COUNT+2))
	fi
done

echo "Soubory byly staženy vytvářim dokument..."

#-----------------------------------------VYTVÁŘÍM DOKUMENT------------------------------------------------------------------#

shopt -s extglob

#jméno vytvářeného dokumentu
OUTFILE=$NAME_TITLE.djvu
#maska nazvu jednotlivých stránek
DEFMASK="${OUT_NAME:0:4}*.djvu"

if [-n "$1" ]; then
   MASK=$1
else
   MASK=$DEFMASK
fi
#vytvoření dokumentu
djvm -c $OUTFILE $MASK

echo "Dokument vytvořen, mažu soubory..."
#smazaní nepotřebných stránek
rm -r ${OUT_NAME:0:4}*.djvu
echo "hotovo!!!"
