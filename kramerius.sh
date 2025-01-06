#!/bin/bash

# Skript pro stahování DJVU stránek a vytvoření DJVU dokumentu

# Ukončí skript při jakékoliv chybě
set -e

# Funkce pro získání uživatelského vstupu
get_user_input() {
    read -p "Vložte adresu první stránky a stiskněte [ENTER]: " FIRST_URL
    read -p "Vložte adresu poslední stránky a stiskněte [ENTER]: " SECOND_URL
    read -p "Vložte jméno dokumentu a stiskněte [ENTER]: " NAME_TITLE
}

# Funkce pro přípravu proměnných
prepare_variables() {
    PREFIX=2
    URL="${FIRST_URL%=*}"
    START_SUBPAGE="${FIRST_URL##*=}"
    END_SUBPAGE="${SECOND_URL##*=}"
    FIRST_PAGE="${FIRST_URL##*_}"
    FIRST_PAGE="${FIRST_PAGE%.*}"
    LAST_PAGE="${SECOND_URL##*_}"
    LAST_PAGE="${LAST_PAGE%.*}"
    CORE_URL="${FIRST_URL%_*}"
}

# Funkce pro stahování jedné stránky
download_page() {
    local page_number=$1
    local out_name="${page_number}.djvu"
    if wget "${CORE_URL}_${page_number}.djvu?id=${START_SUBPAGE}" -O "${out_name}"; then
        echo "Stránka ${page_number} byla úspěšně stažena."
    else
        echo "Chyba při stahování stránky ${page_number}."
        exit 1
    fi
    ((START_SUBPAGE += PREFIX))
}

# Funkce pro stahování všech stránek
download_all_pages() {
    echo "Začínám stahovat soubory..."
    for ((i = FIRST_PAGE; i <= LAST_PAGE; i++)); do
        download_page "$i"
    done
}

# Funkce pro vytvoření DJVU dokumentu
create_djvu_document() {
    echo "Soubory byly staženy, vytvářím dokument..."
    shopt -s extglob
    local outfile="${NAME_TITLE}.djvu"
    local defmask="*.djvu"
    local mask="${1:-$defmask}"

    if djvm -c "${outfile}" $mask; then
        echo "Dokument ${outfile} byl úspěšně vytvořen."
    else
        echo "Chyba při vytváření dokumentu ${outfile}."
        exit 1
    fi
}

# Funkce pro úklid stažených souborů
cleanup() {
    echo "Dokument vytvořen, mažu soubory..."
    rm -r *.djvu
    echo "Hotovo!!!"
}

# Hlavní část skriptu
main() {
    get_user_input
    prepare_variables
    download_all_pages
    create_djvu_document
    cleanup
}

# Spuštění hlavní funkce
main
