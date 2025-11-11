#!/bin/bash

# Cas dont la ville est vide (argument positionnel 1 vide)
if [ -z "$1" ]; then
    echo "Usage invalide."
    echo "Dans cette version il faut spécifier une ville au 1er argument"
    echo "Usage : $0 'nomDeVille'"
    exit 1
fi

ville=$1

# Récupération de la date et de l'heure
date_jour=$(date +%F)      # date au format YYYY-MM-DD
heure=$(date +%H:%M)       # heure au format HH:MM

# Température actuelle (forcée en unités métriques et langue anglaise)
temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t&m&lang=en")

# Récupérer la météo brute aujourd'hui + demain, en texte, en °C, anglais
curl -s "wttr.in/${ville}?2&T&m&lang=en" > meteo_brute.txt

# Calcul de la température moyenne de demain
temp_demain_number=$(
    awk '
    BEGIN {
        header_count = 0
        in_second = 0
        sum = 0
        count = 0
    }

    # Chaque jour commence par une grosse ligne de tableau
    /^┌/ && /┤/ {
        header_count++
        if (header_count == 2) {
            in_second = 1      # on est dans le tableau de demain
        } else if (header_count > 2 && in_second == 1) {
            in_second = 0      # sécurité si jamais il y avait un 3e tableau
        }
    }

    # On traite uniquement le 2e tableau (demain)
    in_second {
        # garder seulement les lignes avec °C, sans km/h, mm, km
        if ($0 !~ /°C/ || $0 ~ /km\/h/ || $0 ~ /mm/ || $0 ~ / km/) next

        line = $0
        # Extraire toutes les températures de la ligne
        while (match(line, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
            temp_str = substr(line, RSTART, RLENGTH)
            gsub(/ ?°C/, "", temp_str)
            gsub(/\(.*\)/, "", temp_str)  # enlever (8) dans +9(8)

            if (temp_str ~ /^[+-]?[0-9]+$/) {
                sum += temp_str + 0
                count++
            }

            line = substr(line, RSTART + RLENGTH)
        }
    }

    END {
        if (count > 0) {
            avg = sum / count
            printf "%.0f\n", avg   # arrondi à l’entier le plus proche
        }
    }
    ' meteo_brute.txt
)

# Si on n'a rien trouvé, on met une erreur
if [ -z "$temp_demain_number" ]; then
    echo "Erreur : impossible d’extraire les températures de demain."
    exit 4
fi

# Reformater en chaîne avec signe et °C
if [ "$temp_demain_number" -gt 0 ]; then
    temp_demain="+${temp_demain_number}°C"
else
    temp_demain="${temp_demain_number}°C"
fi

echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt
