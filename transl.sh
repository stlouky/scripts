#!/bin/bash

# Skript pro překlad titulků v souboru .srt z cizího jazyka do češtiny

# Zkontrolujte, zda je nainstalován nástroj trans
if ! command -v trans &> /dev/null
then
    echo "Nástroj 'trans' není nainstalován. Instalujte jej před spuštěním tohoto skriptu."
    echo "Postup instalace nástroje 'trans':"
    echo "1. Ujistěte se, že máte nainstalovaný 'curl' a 'git'."
    echo "   Můžete je nainstalovat pomocí příkazu: sudo apt-get install curl git"
    echo "2. Stáhněte a nainstalujte 'translate-shell' pomocí těchto příkazů:"
    echo "   git clone https://github.com/soimort/translate-shell.git"
    echo "   cd translate-shell"
    echo "   make"
    echo "   sudo make install"
    echo "3. Ověřte instalaci pomocí příkazu: trans -V"
    exit 1
fi

# Zadejte název vstupního souboru .srt
read -p "Zadejte cestu k souboru s titulky (.srt): " INPUT_FILE

# Zadejte název výstupního souboru .srt
read -p "Zadejte cestu k uloženému přeloženému souboru (.srt): " OUTPUT_FILE

# Zkontrolujte, zda vstupní soubor existuje
if [ ! -f "$INPUT_FILE" ]; then
    echo "Zadaný soubor neexistuje."
    exit 1
fi

# Překlad titulků
echo "Začínám překládat titulky..."

while IFS= read -r line
do
    # Pokud je řádek prázdný nebo obsahuje pouze čísla (časová razítka), nepřekládejte
    if [[ -z "$line" || $line =~ ^[0-9]+$ || $line =~ --> ]]; then
        echo "$line" >> "$OUTPUT_FILE"
    else
        # Přeložte řádek do češtiny
        translated_line=$(echo "$line" | trans -b :cs)
        echo "$translated_line" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

echo "Překlad dokončen. Přeložené titulky byly uloženy do souboru: $OUTPUT_FILE"
