# Extracteur d’Informations Météorologiques (Version 2.0 Automatisation périodique)

## Présentation

Ce projet consiste à développer un **outil automatisé en Bash** permettant d’extraire et de consigner les **informations météorologiques essentielles** d’une ville donnée à partir du service en ligne [wttr.in](https://wttr.in).  

Cette version ajoute la capacité d’exécuter automatiquement le script météo et d’utiliser une ville par défaut si aucun argument n’est fourni. 

---

## Fonctionnement général

Le script `Extracteur_Météo.sh` :

- Récupère la météo depuis wttr.in

- Obtient la température du lendemain

- Affiche les données puis les enregistre dans meteo.txt

- Utilise une ville par défaut (Toulouse) si aucun argument n’est fourni

- Fonctionne avec cron grâce à un chemin dynamique, ce qui permet d’enregistrer tous les fichiers dans le même dossier que le script

---

## Exemple d’exécution

### Script principal : `Extracteur_Météo.sh` 

Dans la version 1.0 le script s’exécute depuis le terminal avec le nom d’une ville en argument :

```bash
./Extracteur_Météo.sh "nomDeVille"
```

Dans la version 2.0, si aucun nom de ville n’est spécifié dans l’argument $1, alors la ville par défaut utilisée est Toulouse. On peut donc exécuter :

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

Par défaut, 0 * * * * signifie que la tâche cron exécutera le script toutes les heures, chaque jour, chaque semaine.

Vous pouvez vous renseigner sur la syntaxe et la documentation cron auprès de ce lien : [Cron et crontab](https://www.linuxtricks.fr/wiki/cron-et-crontab-le-planificateur-de-taches)

## Mise en place CRON

Pour mettre en marche la tache cron, il faut :  

1. S’assurer que le script Extracteur_Météo.sh est exécutable : `chmod u+x Extracteur_Météo.sh`
2. Utiliser la commande realpath dans le répertoire contenant le script : `realpath Extracteur_Météo.sh`
3. Remplacer dans le fichier meteo.cron le chemin /chemin/de/votre/script/ par le chemin réel obtenu.
4. Installer le cron via : `crontab meteo.cron`
5. Vérifier l’installation avec : `crontab -l`


Les résultats seront enregistrés dans meteo.txt, présent dans le même répertoire que le script.
Le script utilise `SCRIPT_DIR=$(dirname "$(realpath "$0")")` afin de garantir que tous les fichiers générés apparaissent dans le même répertoire que le script.


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
| **macOS** | ⚠️ Partiellement compatible | Le script peut échouer à cause des différences UTF-8 dans `awk` et du rendu des caractères de bordure (`┌ ┤`).



## Auteurs

Projet réalisé dans le cadre du **TP Config Pour Un Poste De Travaille — MIAGE L2 UT3 Toulouse**.  
**Contributeurs :**  
Alexandre Monirak SAM, Joachim MORF, Carlo NEUNGOUE, Noé STEINBACH

