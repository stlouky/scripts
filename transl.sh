#!/bin/bash

## vyžaduje nainstalovaný [translator-shell]
## a připojení k internetu

# Inicializace proměnných
NAME_FILE_IN=""					        #upravovany soubor s titulky
NAME_FILE_OUT=""				        #upravený soubor
TARGET_LANG="cs"				        #cílový jazyk
SOURCE_LANG="en"				        #zdrojový jazyk

echo -n "Zadej jméno souboru: "			#prompt
read NAME_FILE_IN				        #přečte nazev souboru

#vytvoři jmeno vystunpniho souboru
NAME_FILE_OUT=$TARGET_LANG"_"$NAME_FILE_IN	
touch $NAME_FILE_OUT				    #vytvoří výstupní soubor


# Funkce vytvoří pole [array] z vloženého
# textového souboru
getArray(){
	array=()
	while IFS= read -r line
	do
		array+=("$line")
	done < "$1"
}

#zavolá funkci pro vytvoření pole
getArray $NAME_FILE_IN				
echo "Začínám překládat...."

# přeloží všechny řádky souboru
for e in "${array[@]}"
do
   # přeloží a zapíše do soubouru text mezi tagy [<i>  </i>]
   if [[ ${e:0:1} =~ "<" ]]; then
        wor_d=${e:3}
        wor_d=${wor_d::-5}
        echo "<i> "$(translate-shell -brief "$wor_d" $SOURCE_LANG:$TARGET_LANG)" </i>" >> $NAME_FILE_OUT
    fi
   #echo $e
	#podmínky
	re='[a-z A-Z]'				
	ra="'"
	ri="-"
	ro='"'	
       	# Vyhodnotí záznam pokud splňuje podmínky přeloží ho
	if [[ ${e:0:1} =~ $re || ${e:0:1} =~ $ra || ${e:0:1} =~ $ri || ${e:0:1} =~ $ro ]]; then
		echo $(translate-shell -brief "$e" $SOURCE_LANG:$TARGET_LANG) >> $NAME_FILE_OUT
	else
		# při nesplnění podmínky zapíše do souboru nepřeložený text
		# pokud řádka začína tagem <i> nezapíše nic
		if [[ ${e:0:1} != "<" ]]; then
            echo $e >> $NAME_FILE_OUT
        fi
	fi
done

echo "Hotovo!!! "
