#!/bin/bash

#vstupy
read -p "Vlož adresu první stránky a stiskni [ENTER]: " FIRST_URL
read -p "Vlož poslední stránku a stiskni [ENTER]: " SECOND_URL
read -p "Vlož jméno dokumentua a stiskni [ENTER]: " NAME_TITLE
PREFIX=2

URL="${FIRST_URL%=*}"+"="

#	subpage			#
START_SUBPAGE="${FIRST_URL##*=}"
END_SUBPAGE="${SECOND_URL##*=}"
SUBPAGE=$START_SUBPAGE

#	page			#
FIRST_PAGE="${FIRST_URL##*_}"
FIRST_PAGE="${FIRST_PAGE%.*}"
LAST_PAGE="${SECOND_URL##*_}"
LAST_PAGE="${LAST_PAGE%.*}"

#	core url		#
CORE_URL="${FIRST_URL%_*}"

echo "Začínám stahovat soubory..."

#stahován dokumentů
for((i = $FIRST_PAGE ; i <= $LAST_PAGE; i++));do
	OUT_NAME=$i".djvu"
	wget ""$CORE_URL""_"$i".djvu?id="$START_SUBPAGE" -O "$OUT_NAME"
	((START_SUBPAGE = START_SUBPAGE + $PREFIX))
done

echo "Soubory byly staženy vytvářim dokument..."

shopt -s extglob

OUTFILE=$NAME_TITLE.djvu
DEFMASK="${OUT_NAME:0:4}*.djvu"

if [-n "$1" ]; then
   MASK=$1
else
   MASK=$DEFMASK
fi

djvm -c $OUTFILE $MASK

echo "Dokument vytvořen, mažu soubory..."

rm -r ${OUT_NAME:0:4}*.djvu

echo "hotovo!!!"

