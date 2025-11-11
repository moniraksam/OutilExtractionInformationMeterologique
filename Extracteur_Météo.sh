#!/bin/bash


#Cas dont la ville est vide (argument positionnel 1 vide)

if [ -z "$1" ]; then
	echo "Usage Invalide."
	echo "Dans cette version il faut spécifié une ville au 1er argument"
	echo "Usage : $0 'nomDeVille'"
	exit 1
fi

ville=$1

# Récupération de la date et de l'heure
date_jour=$(date +%F)      # date
heure=$(date +%H:%M)       # heure

# Température actuelle 
temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t")


# Utilisation de curl pour récupérer la météo 
curl -s "wttr.in/${ville}?2&T" > meteo_brute.txt #2& récupérer météo daujourd'hui +demmain et T enlever la couleur

temp_demain_number=$(
    awk '
    BEGIN {
        sum = 0
        count = 0
        found_second_table = 0
    }

    # Chercher le 2ème jour (on skip le premier tableau qui est aujourdhui)
    /Morning.*Noon.*Evening.*Night/ {
        found_second_table++
    }

    # On traite seulement le 2ème tableau
    found_second_table == 2 {
        # Chercher les températures uniquement (pas km/h, pas mm, pas "km")
        if ($0 ~ /°C/ && $0 !~ /km\/h/ && $0 !~ /mm/ && $0 !~ / km/) {
            # Extraire toutes les températures de la ligne
            line = $0
            while (match(line, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
                temp_str = substr(line, RSTART, RLENGTH)
                # Nettoyer pour garder juste le nombre
                gsub(/ ?°C/, "", temp_str)
                gsub(/\(.*\)/, "", temp_str)  # Enlever (13) dans +14(13)
                
                # Convertir en nombre
                if (temp_str ~ /^[+-]?[0-9]+$/) {
                    sum += temp_str
                    count++
                }
                
                # Continuer la recherche dans le reste de la ligne
                line = substr(line, RSTART + RLENGTH)
            }
        }
    }

    # Arrêter après le 2ème tableau
    found_second_table == 2 && /Location:/ {
        exit
    }

    END {
        if (count > 0) {
            avg = sum / count
            print sprintf("%.0f", avg)
        }
    }
    ' meteo_brute.txt
)


# Si on n'a rien trouvé, on met une valeur vide
if [ -z "$temp_demain_number" ]; then
    echo "Erreur : impossible d’extraire les températures de demain."
    exit 4
fi

# On reformate en chaîne avec le signe et °C
if [ "$temp_demain_number" -gt 0 ]; then
    temp_demain="+${temp_demain_number}°C"
else
    temp_demain="${temp_demain_number}°C"
fi

echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt