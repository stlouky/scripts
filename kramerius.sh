#!/bin/bash

#první stránka dokumentu
read -p "Vlož adresu první stránky a stiskni [ENTER]: " FIRST_URL
#poslední stránka dokumentu
read -p "Vlož poslední stránku a stiskni [ENTER]: " SECOND_URL
#název vytvořeného dokumentu
read -p "Vlož jméno dokumentua a stiskni [ENTER]: " NAME_TITLE
PREFIX=2

URL="${FIRST_URL%=*}"+"="

#podstránka		#
START_SUBPAGE="${FIRST_URL##*=}"
END_SUBPAGE="${SECOND_URL##*=}"
SUBPAGE=$START_SUBPAGE

#první a poslední stránka#
FIRST_PAGE="${FIRST_URL##*_}"
FIRST_PAGE="${FIRST_PAGE%.*}"
LAST_PAGE="${SECOND_URL##*_}"
LAST_PAGE="${LAST_PAGE%.*}"

#core url		#
CORE_URL="${FIRST_URL%_*}"

echo "Začínám stahovat soubory..."

#stahován dokumentu od prvního do posledního
for((i = $FIRST_PAGE ; i <= $LAST_PAGE; i++));do
	#jméno stahované stránky
	OUT_NAME=$i".djvu"
	#sestaveni adresy stránky a stažení do aktualního adresáře
	wget ""$CORE_URL""_"$i".djvu?id="$START_SUBPAGE" -O "$OUT_NAME"
	((START_SUBPAGE = START_SUBPAGE + $PREFIX))
done

echo "Soubory byly staženy vytvářim dokument..."

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

