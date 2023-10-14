#!/bin/bash

# Skript pro stahování DJVU stránek a vytvoření DJVU dokumentu

# Zadejte adresu první stránky DJVU dokumentu
read -p "Vložte adresu první stránky a stiskněte [ENTER]: " FIRST_URL

# Zadejte adresu poslední stránky DJVU dokumentu
read -p "Vložte adresu poslední stránky a stiskněte [ENTER]: " SECOND_URL

# Zadejte jméno vytvořeného dokumentu
read -p "Vložte jméno dokumentu a stiskněte [ENTER]: " NAME_TITLE

# Příprava proměnných
PREFIX=2
URL="${FIRST_URL%=*}"
START_SUBPAGE="${FIRST_URL##*=}"
END_SUBPAGE="${SECOND_URL##*=}"
SUBPAGE=$START_SUBPAGE
FIRST_PAGE="${FIRST_URL##*_}"
FIRST_PAGE="${FIRST_PAGE%.*}"
LAST_PAGE="${SECOND_URL##*_}"
LAST_PAGE="${LAST_PAGE%.*}"
CORE_URL="${FIRST_URL%_*}"

# Funkce pro stahování jedné stránky
function download_page() {
    page_number=$1
    OUT_NAME="${page_number}.djvu"
    wget "${CORE_URL}_${page_number}.djvu?id=${START_SUBPAGE}" -O "${OUT_NAME}"
    ((START_SUBPAGE = START_SUBPAGE + PREFIX))
}

echo "Začínám stahovat soubory..."

# Stahování dokumentu od prvního do posledního
for ((i = FIRST_PAGE; i <= LAST_PAGE; i++)); do
    download_page "$i"
done

echo "Soubory byly staženy, vytvářím dokument..."

# Příprava pro vytvoření DJVU dokumentu
shopt -s extglob
OUTFILE="${NAME_TITLE}.djvu"
DEFMASK="*.djvu"

if [ -n "$1" ]; then
    MASK="$1"
else
    MASK="$DEFMASK"
fi

# Vytvoření DJVU dokumentu
djvm -c "${OUTFILE}" $MASK

echo "Dokument vytvořen, mazu soubory..."

# Smazání nepotřebných stránek
rm -r *.djvu

echo "Hotovo!!!"
