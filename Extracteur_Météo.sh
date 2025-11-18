#!/bin/bash

# Ville par défaut
if [ -z "$1" ]; then
    echo "Aucun nom de ville spécifié, utilisation de la ville par défaut : Toulouse"
    ville="Toulouse"
else
    ville="$1"
fi

# Récupération de la date et de l'heure
date_jour=$(date +%F)      # date avec option au format YYYY-MM-DD
heure=$(date +%H:%M)       # heure avec option au format HH:MM

# Température actuelle (forcée en unités métriques et langue anglaise)
temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t&m&lang=en")

# Récupérer la météo brute aujourd'hui + demain en texte en °C anglais
curl -s "wttr.in/${ville}?2&T&m&lang=en" > meteo_brute.txt

# Calcul de la température moyenne de demain et regex avec awk
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
        if (header_count == 2) { # Determine si on est dans le tab de demain
            in_second = 1      
        }
        
    }

    # Traiter juste le deuxieme tab
    in_second {
        # Regex pour garder les lignes avec °C, sans km/h, mm, km
        if ($0 !~ /°C/ || $0 ~ /km\/h/ || $0 ~ /mm/ || $0 ~ / km/) next

        ligne = $0
        # Extraire toutes les températures de la ligne
        while (match(ligne, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
            temp_str = substr(ligne, RSTART, RLENGTH)
            gsub(/ ?°C/, "", temp_str)
            gsub(/\(.*\)/, "", temp_str)  # enlever les valeurs dans les parantheses (deuxiemes valeur de meteos)

            if (temp_str ~ /^[+-]?[0-9]+$/) {
                sum += temp_str + 0
                count++
            }

            ligne = substr(ligne, RSTART + RLENGTH)
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

# Version 3 
vitesse=$(curl -s "https://wttr.in/$ville?format=%w") # Documentation readme.md wttr.in one line output
humidite=$(curl -s "https://wttr.in/$ville?format=%h") # Documentation readme.md wttr.in one line output
visibilite=$(grep -Eo '[0-9]+ km' meteo_brute.txt | head -n 1) # Grep avec extended regex pour visibilite



# Si on n'a rien trouvé, on met une erreur
if [ -z "$temp_demain_number" ]; then
    echo "Erreur : impossible d’extraire les températures de demain."
    exit 1
fi

# Reformater en chaîne avec signe et °C
if [ "$temp_demain_number" -gt 0 ]; then
    temp_demain="+${temp_demain_number}°C"
else
    temp_demain="${temp_demain_number}°C"
fi

# Echo dans le format specifique demandé au TP 
echo -e "${date_jour} - ${heure} - ${ville} : Aujourd'hui : ${temp_actuelle}, Vitesse Vent : ${vitesse}, Humidité : ${humidite}, Visibilite: ${visibilite}\nPrévision Temp Demain : ${temp_demain}" >> meteo.txt
echo -e "${date_jour} - ${heure} - ${ville} : Aujourd'hui : ${temp_actuelle}, Vitesse Vent : ${vitesse}, Humidité : ${humidite}, Visibilite: ${visibilite}\nPrévision Temp Demain : ${temp_demain}"
