# Extracteur d’Informations Météorologiques  (Version 3.0)

## Nouveautés de la Version 3.0

Cette nouvelle version améliore significativement la version 1.0 en ajoutant trois fonctionnalités majeures :

### 1. Informations météo supplémentaires
Le script récupère désormais automatiquement :

- La vitesse du vent

- Le taux d’humidité

- La visibilité

Ces données sont intégrées directement dans la sortie standard et dans les fichiers générés.

### 2. Option de sauvegarde au format JSON

Le script compte maintenant une option : 

```bash
./Extracteur_Météo.sh "nomDeVille" --json
```
Lorsqu'elle est activée :

-   un fichier `meteo.json` est généré ou mis à jour
-   chaque entrée ajoute une structure complète :

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

### 3. System de gestion des erreurs et de logs

En cas de problème avec la connexion à wttr.in, le script écrit un message d'erreur dans un fichier de logs d'erreur : `meteo_erreur.log`.

Le script rajoute aussi des timestamps pour faciliter le suivi d'erreurs.

## Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

La version 3.0 ajoute de nouvelles données (Vitesse de vent, taux d'humidité et visiblité), une option JSON et un
système de logs d'erreurs.

---

## Fonctionnement général

### Script principal : `Extracteur_Météo.sh` 

Le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "nomDeVille"
```

Si il n'y a pas de nom de ville fournis en argument `$1` alors "Toulouse" va être la ville utilisée par défaut.

## Structure du projet

```
.
├── Extracteur_Météo.sh    # Script principal
├── meteo_brute.txt        # Données brutes temporaires (wttr.in)
└── meteo.txt              # Historique des relevés formatés
└── meteo.json             # Format JSON si spécifié avec option -json
└── meteo_erreur.log       # Fichier contenant les logs d'erreurs
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
| **Linux** | ✅ Compatible | Bash, awk et curl sont requis. |
| **Windows (WSL)** | ✅ Compatible | Bash, awk et curl sont requis. |
| **macOS** | ⚠️ Partiellement compatible | Le script peut échouer à cause des différences UTF-8 dans `awk` et du rendu des caractères de bordure (`┌ ┤`).Nous avons une branche avec une version de scripte disponible pour macOS en travaille.|



## Auteurs

Projet réalisé dans le cadre du **TP Config Pour Un Poste De Travaille — MIAGE L2 UT3 Toulouse**.  
**Contributeurs :**  
Alexandre Monirak SAM, Joachim MORF, Carlo NEUNGOUE, Noé STEINBACH

