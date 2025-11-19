#!/bin/bash

#logger les erreurs
log_error() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ERREUR: $message" >> meteo_error.log
    echo "[$timestamp] ERREUR: $message" >&2  # Afficher aussi sur invitée de commande
}

# Ville par défaut
if [ -z "$1" ]; then
    echo "Aucun nom de ville spécifié, utilisation de la ville par défaut : Toulouse"
    ville="Toulouse"
else
    ville="$1"
fi

format_json=false

# Version 3 partie 2 sauvegarder format json
if [ "$2" == "--json" ]; then
	format_json=true
fi

# Récupération de la date et de l'heure
date_jour=$(date +%F)      # date avec option au format YYYY-MM-DD
heure=$(date +%H:%M)       # heure avec option au format HH:MM

# Température actuelle (forcée en unités métriques et langue anglaise)
temp_output=$(curl -s -w "\n%{http_code}" "wttr.in/${ville}?format=%t&m&lang=en")
http_code=$(echo "$temp_output" | tail -n 1)
temp_actuelle=$(echo "$temp_output" | head -n 1)

if [ "$http_code" != "200" ]; then
    log_error "Échec de récupération de la température actuelle pour '$ville'. Code HTTP: $http_code"
    exit 1
fi

if [ -z "$temp_actuelle" ] || [ "$temp_actuelle" == "Unknown location" ]; then
    log_error "Température actuelle vide ou ville inconnue: '$ville'"
    exit 1
fi

# Récupérer la météo brute aujourd'hui + demain en texte en °C anglais
curl_output=$(curl -s -w "\n%{http_code}" "wttr.in/${ville}?2&T&m&lang=en")
http_code=$(echo "$curl_output" | tail -n 1)
meteo_content=$(echo "$curl_output" | head -n -1)

if [ "$http_code" != "200" ]; then
    log_error "Échec de récupération des données météo brutes pour '$ville'. Code HTTP: $http_code"
    exit 1
fi

if [ -z "$meteo_content" ]; then
    log_error "Contenu météo vide retourné par wttr.in pour '$ville'"
    exit 1
fi

# Sauvegarder dans le fichier
echo "$meteo_content" > meteo_brute.txt

if [ ! -s meteo_brute.txt ]; then
    log_error "Le fichier meteo_brute.txt est vide après écriture"
    exit 1
fi

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

# Vérifier si AWK a produit une erreur
if [ $? -ne 0 ]; then
    log_error "Erreur lors de l'exécution AWK pour extraire les températures. Sortie: $temp_demain_number"
    temp_demain_number=""
fi

# Version 3 partie 1
vitesse=$(curl -s -w "\n%{http_code}" "https://wttr.in/$ville?format=%w&m&lang=en")
http_code_vitesse=$(echo "$vitesse" | tail -n 1)
vitesse=$(echo "$vitesse" | head -n 1)

if [ "$http_code_vitesse" != "200" ] || [ -z "$vitesse" ]; then
    log_error "Impossible de récupérer la vitesse du vent pour '$ville'. Code HTTP: $http_code_vitesse, valeur='$vitesse'"
    vitesse="N/A"
fi

humidite=$(curl -s -w "\n%{http_code}" "https://wttr.in/$ville?format=%h&m&lang=en")
http_code_humidite=$(echo "$humidite" | tail -n 1)
humidite=$(echo "$humidite" | head -n 1)

if [ "$http_code_humidite" != "200" ] || [ -z "$humidite" ]; then 
    log_error "Impossible de récupérer l'humidité pour '$ville'. Code HTTP: $http_code_humidite, valeur='$humidite'"
    humidite="N/A"
fi

visibilite=$(grep -Eo '[0-9]+ km' meteo_brute.txt | head -n 1)

if [ -z "$visibilite" ]; then
    log_error "Impossible d'extraire la visibilité depuis meteo_brute.txt pour '$ville'"
    visibilite="N/A"
fi

# Si on n'a rien trouvé pour la température de demain
if [ -z "$temp_demain_number" ]; then
    log_error "Impossible d'extraire les températures de demain depuis meteo_brute.txt pour '$ville'. Parsing AWK a échoué."
    temp_demain="N/A"
elif ! [[ "$temp_demain_number" =~ ^[+-]?[0-9]+$ ]]; then
    log_error "La température de demain extraite n'est pas un nombre valide: '$temp_demain_number' pour '$ville'"
    temp_demain="N/A"
else
    # Reformater en chaîne avec signe et °C
    if [ "$temp_demain_number" -gt 0 ]; then
        temp_demain="+${temp_demain_number}°C"
    else
        temp_demain="${temp_demain_number}°C"
    fi
fi

# Echo dans le format specifique demandé au TP 
echo -e "${date_jour} - ${heure} - ${ville} : Aujourd'hui : ${temp_actuelle}, Vitesse Vent : ${vitesse}, Humidité : ${humidite}, Visibilite: ${visibilite}\nPrévision Temp Demain : ${temp_demain}"

# Sauvegarde fichier Json
if [ "$format_json" = true ]; then
    json_file="meteo.json"
    
    # Vérifier si on peut écrire le fichier JSON
    if ! cat > "$json_file" <<EOF
{
    "date": "$date_jour",
    "heure": "$heure",
    "ville": "$ville",
    "temperature": "$temp_actuelle",
    "prevision": "$temp_demain",
    "vent": "$vitesse",
    "humidite": "$humidite",
    "visibilite": "$visibilite"
}
EOF
    then
        log_error "Impossible d'écrire dans le fichier JSON '$json_file'"
        exit 1
    fi
    
    exit 0
fi

# Sauvegarder dans fichier texte
if ! echo -e "${date_jour} - ${heure} - ${ville} : Aujourd'hui : ${temp_actuelle}, Vitesse Vent : ${vitesse}, Humidité : ${humidite}, Visibilite: ${visibilite}\nPrévision Temp Demain : ${temp_demain}" >> meteo.txt; then
    log_error "Impossible d'écrire dans le fichier meteo.txt"
    exit 1
fi