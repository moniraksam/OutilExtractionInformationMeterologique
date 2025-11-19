# Extracteur d’Informations Météorologiques  (Version 1.0)

## Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

Le script interroge l’API textuelle de `wttr.in`, extrait la **température actuelle** ainsi que la **température moyenne prévue pour le lendemain**, puis enregistre ces données dans un fichier texte au format structuré.  

---

## Exemple d’exécution

### Script principal : `Extracteur_Météo.sh` 

Le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "nomDeVille"
```

Exemple de sortie :


```
2025-11-12 - 14:30 - Paris : +11°C - +8°C
```

Sortie affichée sur terminal et aussi ajoutée à `meteo.txt`.

---

## Structure du projet

```
.
├── Extracteur_Météo.sh    # Script principal
├── meteo_brute.txt        # Données brutes temporaires (wttr.in)
└── meteo.txt              # Historique des relevés formatés
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

