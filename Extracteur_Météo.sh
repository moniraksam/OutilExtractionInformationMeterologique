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
        header_count = 0
        in_second = 0
        sum = 0
        count = 0
    }

    # Détection du 2e tableau en cherchant la date de demain
    # Plus robuste que les caractères unicode
    /Mon [0-9]+ Nov|Tue [0-9]+ Nov|Wed [0-9]+ Nov|Thu [0-9]+ Nov|Fri [0-9]+ Nov|Sat [0-9]+ Nov|Sun [0-9]+ Nov/ {
        header_count++
        if (header_count == 2) in_second = 1
    }
    
    # Arrêter après le 2e tableau
    /Location:/ {
        in_second = 0
    }

    in_second {
        # ne prend QUE les lignes avec °C ET évite celles avec km/h, mm, ou km
        if ($0 !~ /°C/ || $0 ~ /km\/h|mm| km/) next

        # Regex plus stricte : le °C doit être collé ou avec UN SEUL espace
        while (match($0, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
            temp = substr($0, RSTART, RLENGTH)
            gsub(/ ?°C/, "", temp)
            
            # Si format 9(8), on garde le premier chiffre
            if (match(temp, /^[+-]?[0-9]+/)) {
                val_str = substr(temp, RSTART, RLENGTH)
                val = val_str + 0
                sum += val
                count++
            }
            
            # Effacer la partie déjà lue pour continuer
            $0 = substr($0, RSTART + RLENGTH)
        }
    }

    END {
        if (count > 0) {
            avg = sum / count
            avg_int = sprintf("%.0f", avg)
            print avg_int
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