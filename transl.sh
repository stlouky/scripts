#!/bin/bash

## vyžaduje nainstalovaný [translator-shell]
## a připojení k internetu

# Inicializace proměnných
NAME_FILE_IN=""                         #upravovany soubor
NAME_FILE_OUT=""                        #upravený soubor
TARGET_LANG="cs"                        #cílový jazyk
SOURCE_LANG="en"                        #zdrojový jazyk

# patern tagy
FI_TG="<i>" LA_TG="</i>" MEZ=" "
# patern znaky [first char]
re='[a-z A-Z]' ra="'" ri="-" ro='"'

echo -n "Zadej jméno souboru: "         #prompt
read NAME_FILE_IN                       #přečte nazev souboru

# vytvoři jmeno vystunpniho souboru
NAME_FILE_OUT=$TARGET_LANG"_"$NAME_FILE_IN
#vytvoří výstupní soubor
touch $NAME_FILE_OUT                    


# Funkce vytvoří pole [array] z vloženého textového souboru
getArray(){
	array=()
	while IFS= read -r line
	do
		array+=("$line")
	done < "$1"
}

# zavolá funkci pro vytvoření pole
getArray $NAME_FILE_IN

echo "Začínám překládat...."

for e in "${array[@]}"
do
    echo $e
    # smaž vše od [>]
    FIRST_TAG=${e:0:3}    
    # smaž vše až do [<]
    LAST_TAG=${e:(-5)}
    
    # prvni char
    FIRST_CHAR=${e:0:1}
        
    # testuj na tag [<i>] [</i>]
    if [[ $FIRST_TAG =~ $FI_TG || $LAST_TAG =~ $LA_TG ]]; then
        # smaž tagy [nejdou přeložit]          
        e="${e/$FI_TG/$MEZ}" 
        e="${e/$LA_TG/$MEZ}"
        
        echo "<i>"$(translate-shell -brief "$e" $SOURCE_LANG:$TARGET_LANG)"</i>" >> $NAME_FILE_OUT
    else    
        # test na písmeno a interpunkci? prvního znaku [a-z A-Z] [' " - . ,]
        if [[ $FIRST_CHAR =~ $re ||
              $FIRST_CHAR =~ $ra ||
              $FIRST_CHAR =~ $ri ||
              $FIRST_CHAR =~ $ro ]]; then
              
            echo $(translate-shell -brief "$e" $SOURCE_LANG:$TARGET_LANG) >> $NAME_FILE_OUT 
        else
            # při nesplnění podmínky zapíše do souboru nepřeložený text
            echo $e >> $NAME_FILE_OUT
        fi        
    fi    
done

echo "Hotovo!!!"

