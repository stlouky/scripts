#!/bin/bash

## vyžaduje nainstalovaný [translator-shell]
## a připojení k internetu

# Inicializace proměnných
NAME_FILE_IN=""					#upravovany soubor s titulky
NAME_FILE_OUT=""				#upravený soubor
TARGET_LANG="cs"				#cílový jazyk
SOURCE_LANG="en"				#zdrojový jazyk

echo -n "Zadej jméno souboru: "			#prompt
read NAME_FILE_IN				#přečte nazev souboru
NAME_FILE_OUT=$TARGET_LANG"_"$NAME_FILE_IN	#vytvoři jmeno vystunpniho souboru
touch $NAME_FILE_OUT				#vytvoří výstupní soubor

# Funkce vytvoří pole [array]
# z vloženého textového souboru
getArray(){
	array=()
	while IFS= read -r line
	do
		array+=("$line")
	done < "$1"
}

getArray $NAME_FILE_IN				#zavolá funkci pro vytvoření pole
echo "Začínám překládat...."

for e in "${array[@]}"
do
	#podmínky
	re='[a-z A-Z]'				
	ra="'"
	ri="-"
	ro='"'
       	# Vyhodnotí záznam pokud splňuje podmínky přeloží ho
	if [[ ${e:0:1} =~ $re || ${e:0:1} =~ $ra || ${e:0:1} =~ $ri || ${e:0:1} =~ $ro ]]; then
		echo $(translate-shell -brief "$e" $SOURCE_LANG:$TARGET_LANG) >> $NAME_FILE_OUT
	else
		# při nesplnění podmínky vloži nepřeložený text
		echo $e >> $NAME_FILE_OUT
	fi
done

echo "Hotovo!!! "
