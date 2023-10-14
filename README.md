# scripts

kramerius.sh	 => stahuje stránky [*.djvu] z nkp.cz a vytváří z nich dokument [*.djvu]

krameriusmag.sh	 => nová verze kramerius.sh vytváří [book.djvu]

transl.sh	 => najde v adresáři soubor *.srt a přeloží ho na google translátor..
		    vytvoří českou kopii [cs_*.srt]
            
shout.sh	 => přehrává vybrané stanice ze streamu [shoutcast] [mplayer]

bashrc_bak	 => kopie bashrc z archlinux (hledá: google výraz, git-completion??,nastavena path na #HOME/bin...atd.)) 


# Skript pro stahování DJVU stránek a vytvoření DJVU dokumentu

Tento skript umožňuje stáhnout DJVU stránky z určeného rozsahu a vytvořit z nich jeden DJVU dokument.

## Použití

1. Spusťte skript pomocí příkazu `./download_djvu.sh`.

2. Postupně zadejte následující informace:

   - Adresu první stránky DJVU dokumentu.
   - Adresu poslední stránky DJVU dokumentu.
   - Jméno pro vytvořený DJVU dokument.

3. Skript stáhne všechny stránky mezi první a poslední stránkou, včetně. Po dokončení stažení vytvoří DJVU dokument.

4. Vytvořený DJVU dokument bude mít název, který jste zvolili.

5. Skript také smaže všechny dočasné DJVU soubory po dokončení.

## Poznámky

- Skript vyžaduje nástroj `wget` pro stahování souborů a `djvm` pro vytvoření DJVU dokumentu.

- Buďte opatrní, protože skript smaže všechny DJVU soubory v aktuálním adresáři po vytvoření dokumentu.

- Pokud máte speciální požadavky na název stránek nebo složky, měli byste provést další úpravy skriptu podle svých potřeb.

- Používejte tento skript pouze na souborech, na kterých máte právo stahovat a zpracovávat.
