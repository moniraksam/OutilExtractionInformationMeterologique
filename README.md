# Extracteur d’Informations Météorologiques (Version 2.0 Automatisation périodique)

## Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

Cette version ajoute la capacité d’exécuter automatiquement le script météo et d’utiliser une ville par défaut si aucun argument n’est fourni. 

---

## Fonctionnement général

Le script `Extracteur_Météo.sh` :

- Récupère la météo depuis wttr.in
- Obtient la température moyenne du lendemain
- Affiche les données puis les enregistre dans meteo.txt
- Utilise une ville par défaut (Toulouse) si aucun argument n’est fourni
- Fonctionne avec cron grâce à un chemin dynamique qui lui permet d’enregistrer les fichiers dans le même dossier que le script

---

## Exemple d’exécution

### Script principal : `Extracteur_Météo.sh` 

Dans la version 1.0 le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "nomDeVille"
```

Mais dans cette version 2.0, si aucun nom de ville est spécifié dans l'argument `$1` alors la ville par défaut qui va être utilisée est "Toulouse". On peut donc utiliser le script de la manière suivante sans arguments :

```bash
./Extracteur_Météo.sh
```

Exemple de sortie :


```
2025-11-12 - 14:30 - Paris : +11°C - +8°C
```

Sortie affichée sur terminal et aussi ajoutée à `meteo.txt`.

---

## Automatisation avec CRON

Le contenu pour cron est dans le fichier `meteo.cron` :

```
0 * * * * /chemin de votre script/Extracteur_Météo.sh
```

Pour mettre en marche la tache cron, il faut :  

   - Assurer que le script `Extracteur_météo.sh` est exécutable avec la commande : `chmod u+x` 
   - Remplacer dans le fichier meteo.cron `/chemin de votre script/` par le chemin réelle vers Extracteur_Météo.sh  
   - Puis exécuter la commande `(crontab -l 2>/dev/null; cat /chemin de meteo.cron/meteo.cron) | crontab - ` après avoir changer `/chemin de meteo.cron/` par le chemin réelle  
   - Vous pouvez ensuite vérifier vos crontab avec la commande `crontab -e` pour s'assurer que la commande a bien été prise en compte  

Explication de la commande `(crontab -l 2>/dev/null; cat /chemin de meteo.cron/meteo.cron) | crontab - `:  
   - `crontab -l 2>/dev/null` récupère les tâches cron existantes (sans erreur si aucune n’existe)  
   - `cat /chemin de meteo.cron/meteo.cron` lit le contenu du fichier `meteo.cron`  
   - Les parenthèses `( … ; … )` combinent les deux sorties en un seul flux  
   - Le pipe `| crontab -` installe toutes les tâches combinées dans la table cron de l’utilisateur  
Les anciennes tâches cron sont donc conservées et la nouvelle est ajoutée.

Vous pouvez vous renseigner sur la syntaxe et la documentation cron auprès de ce lien : [Cron et crontab](https://www.linuxtricks.fr/wiki/cron-et-crontab-le-planificateur-de-taches)


---

## Structure du projet

```
.
├── Extracteur_Météo.sh    # Script principal
├── meteo_brute.txt        # Données brutes temporaires (wttr.in)
└── meteo.txt              # Historique des relevés formatés
└── meteo.cron             # Skelette pour le fichier de config cron
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

