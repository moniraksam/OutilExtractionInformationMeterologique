# Extracteur d’Informations Météorologiques  (Version 3.0 et Variantes)

## Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

La version 3.0 ajoute de nouvelles données (Vitesse de vent, taux d'humidité et visiblité), une option d'archive et de sortie format JSON et un
système de logs d'erreurs.

## Nouveautés de la Version 3.0

Cette nouvelle version améliore significativement la version 1.0 en ajoutant avec une option d'archive et 3 fonctionnalités majeures.

## Option de Gestion d'Historique

La fonctionnalité d'archive permet de sauvegarder un journal quotidien des données météorologiques dans un fichier texte daté. À chaque exécution du script avec l'option `-a`, les informations météo actuelles sont ajoutées à un fichier nommé :

`meteo_YYYYMMDD.txt`

où YYYYMMDD correspond à la date du jour.

Cela permet de garder un historique des températures, de la vitesse du vent, de l'humidité, de la visibilité et des prévisions.

```bash
./Extracteur_Météo.sh -a
```

## Variantes Demandées au TP


### 1. Informations météo supplémentaires
Le script récupère désormais automatiquement :

- La vitesse du vent

- Le taux d’humidité

- La visibilité

Ces données sont intégrées directement dans la sortie standard et dans les fichiers générés.

### 2. Option de sauvegarde au format JSON

Le script compte maintenant une option de sortie JSON : 

```bash
./Extracteur_Météo.sh --json
```
Lorsqu'elle est activée :

-   un fichier `meteo.json` est généré ou mis à jour
-   chaque entrée ajoute une structure complète :


### 3. System de gestion des erreurs et de logs

En cas de problème avec la connexion à wttr.in, le script écrit un message d'erreur dans un fichier de logs d'erreur : `meteo_erreur.log`.\
Le script rajoute aussi des timestamps pour faciliter le suivi d'erreurs.


---

## Fonctionnement général

Le script `Extracteur_Météo.sh` :

- Récupère la météo (température, vitesse vent, humidité, visibilité) depuis wttr.in

- Obtient la température du lendemain

- Affiche les données puis les enregistre dans meteo.txt

- Utilise une ville par défaut (Toulouse) si aucun argument n’est fourni

- Change de comportement en fonctions des options 

---

## Exemple d’exécution

Le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "nomDeVille"
```

Si il n'y a pas de nom de ville fournis en argument `$1` alors "Toulouse" va être la ville utilisée par défaut.\
Sortie ajoutée à `meteo.txt`

Example de sortie:

```
2025-11-19 - 21:08 - Toulouse : Aujourd'hui : +9°C, Vitesse Vent : →12km/h, Humidité : 81%, Visibilite: 19 km
Prévision Temp Demain : +4°C
```

## Example avec options

```bash
$ ./Extracteur_Météo.sh "nomDeVille" --json
```

Sortie ajoutée à `meteo.json`

Exemple de output en format JSON : 

``` json
{
    "date": "2025-11-19",
    "heure": "21:08",
    "ville": "Toulouse",
    "temperature": "+9°C",
    "prevision": "+4°C",
    "vent": "→12km/h",
    "humidite": "81%",
    "visibilite": "19 km"
}

```

Autres exemples :

```bash
$ ./Extracteur_Météo.sh --json # Ville par défaut Toulouse
$ ./Extracteur_Météo.sh --json -a
$ ./Extracteur_Météo.sh -a
$ ./Extracteur_Météo.sh -a --json
$ ./Extracteur_Météo.sh nomDeVille --json -a 
```

---

## Structure du projet

```
.
├── Extracteur_Météo.sh    # Script principal
├── meteo_brute.txt        # Données brutes temporaires (wttr.in)
└── meteo.txt              # Historique des relevés formatés
└── meteo.json             # Format JSON si spécifié avec option '--json'
└── meteo_erreur.log       # Fichier contenant les logs d'erreurs
└── meteo_YYYYMMDD.txt     # Fichier contenant toutes les prévisions récupérées dans une journée, option '-a'

```


## Compatibilité

| Système | Compatibilité | Détails |
|----------|----------------|----------|
| **Linux** | ✅ Compatible | Bash, awk et curl sont requis. |
| **Windows (WSL)** | ✅ Compatible | Bash, awk et curl sont requis. |
| **macOS** | ⚠️ Partiellement compatible | Le script peut échouer à cause des différences UTF-8 dans `awk` et du rendu des caractères de bordure (`┌ ┤`).



## Auteurs

Projet réalisé dans le cadre du **TP Config Pour Un Poste De Travaille — MIAGE L2 UT3 Toulouse**.  
**Contributeurs :**  
Alexandre Monirak SAM, Joachim MORF, Carlo NEUNGOUE, Noé STEINBACH

