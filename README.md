# Extracteur d’Informations Météorologiques  
*(Projet Bash — wttr.in Data Parser)*

## 🧭 Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

Le script interroge l’API textuelle de `wttr.in`, extrait la **température actuelle** ainsi que la **température moyenne prévue pour le lendemain**, puis enregistre ces données dans un fichier texte au format structuré.  

---

## Fonctionnement général

### Script principal : `Extracteur_Météo.sh`

Le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "Toulouse"
```

### Étapes principales

1. **Vérification des arguments**  
   Le script vérifie qu’une ville a bien été spécifiée :

   ```bash
   if [ -z "$1" ]; then
       echo "Usage : $0 'nomDeVille'"
       exit 1
   fi
   ```

2. **Récupération des métadonnées locales**  
   Extraction de la date et de l’heure actuelles :

   ```bash
   date_jour=$(date +%F)   # ex: 2025-11-12
   heure=$(date +%H:%M)    # ex: 14:35
   ```

3. **Obtention de la température actuelle**  
   Utilisation de `curl` avec le format minimaliste de wttr.in :

   ```bash
   temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t&m&lang=en")
   ```

   - `format=%t` : affiche uniquement la température actuelle  
   - `m` : unités métriques  
   - `lang=en` : garantit des données cohérentes pour le parsing  

4. **Téléchargement des prévisions brutes (aujourd’hui + demain)**  
   Le script télécharge le tableau ASCII complet de wttr.in :

   ```bash
   curl -s "wttr.in/${ville}?2&T&m&lang=en" > meteo_brute.txt
   ```

   - `2` : inclut la prévision d’aujourd’hui et de demain  
   - `T` : désactive les séquences de terminal (pas de couleur)  
   - `m` : unités métriques  
   - `lang=en` : langue anglaise  

5. **Extraction de la température moyenne du lendemain**  
   Le bloc `awk` analyse la structure ASCII renvoyée par wttr.in :  
   - Détecte le **deuxième tableau** du rendu (correspondant à “Tomorrow”)  
   - Extrait toutes les valeurs numériques suivies de “°C”  
   - Ignore les lignes contenant des unités parasites (`km/h`, `mm`, `km`)  
   - Calcule la **moyenne des températures journalières**

   ```bash
   awk '
   /^┌/ && /┤/ { ... }  # détection des tableaux
   /°C/ && !/km\/h|mm| km/ { ... }  # extraction des températures
   ' meteo_brute.txt
   ```

6. **Formatage et enregistrement du résultat final**  
   Une fois la température moyenne calculée, elle est formatée et ajoutée dans un fichier `meteo.txt` :

   ```bash
   echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt
   ```

   Exemple de sortie :

   ```
   2025-11-12 - 14:35 - Toulouse : +16°C - +13°C
   ```

---

## Structure du projet

```
.
├── Extracteur_Météo.sh    # Script principal
├── meteo_brute.txt        # Données brutes temporaires (wttr.in)
└── meteo.txt              # Historique des relevés formatés
```

---

## Exemple d’exécution

```bash
$ ./Extracteur_Météo.sh "Paris"
```

Sortie ajoutée à `meteo.txt` :

```
2025-11-12 - 14:30 - Paris : +11°C - +8°C
```

---

## Compatibilité

| Système | Compatibilité | Détails |
|----------|----------------|----------|
| **Linux** | ✅ Fonctionne parfaitement | Bash, awk et curl sont requis |
| **Windows (WSL)** | ✅ Compatible | Fonctionne sans modification |
| **macOS** | ⚠️ Partiellement compatible | Le script peut échouer à cause des différences UTF-8 dans `awk` et du rendu des caractères de bordure (`┌ ┤`). Il est recommandé d’utiliser **gawk** :<br>`brew install gawk` |
 Nous avons une branche avec une version de scripte disponible pour macOS en travaille.


## Auteurs

Projet réalisé dans le cadre du **TP Config Pour Un Poste De Travaille — MIAGE UT3 Toulouse**.  
**Contributeurs :**  
- Alexandre Sam Monirak  
- Joachim Morf
- Carlos Neungoue
- Noe Steinbach
