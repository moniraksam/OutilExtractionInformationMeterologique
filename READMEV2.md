\# Outil d'Extraction d'Information Météorologique



Ce projet a pour objectif de concevoir un outil automatisé d’extraction d’informations météorologiques pour une ville donnée, en s’appuyant sur le service \[wttr.in](https://wttr.in).  



Le script principal (`Extracteur\\\_Meteo.sh`) interroge ce service afin d’obtenir la température actuelle ainsi que la prévision pour le lendemain, puis consigne ces informations dans un fichier texte au format lisible et structuré.  



Le développement du projet est organisé en plusieurs versions successives, chacune introduisant de nouvelles fonctionnalités. L’utilisation de \*\*Git\*\* assure un suivi rigoureux du code, la gestion des différentes itérations du projet et la traçabilité des contributions de chaque membre de l’équipe.  



\## Version 1 : Script de base



Le script `Extracteur\_Meteo.sh` réalise les étapes suivantes :



1\. \*\*Récupération des données météorologiques brutes\*\*  

&nbsp;  Utilise `curl` pour interroger le service wttr.in et récupérer les données météorologiques pour la ville spécifiée en argument. 

&nbsp;  Les données brutes sont sauvegardées dans un fichier temporaire local.  

&nbsp;  Dans la ligne : `curl -s "wttr.in/${ville}?2\&T\&m\&lang=en" > meteo\_brute.txt`  

&nbsp;  - `curl -s "wttr.in/${ville}?2\&T\&m\&lang=en"` → récupère les données météo brutes depuis wttr.in  

&nbsp;  - `> meteo\_brute.txt` → les sauvegarde dans un fichier local (meteo\_brute.txt)  

&nbsp;

2\. \*\*Extraction des températures\*\*  

&nbsp;  Le script extrait à partir du fichier brut :

&nbsp;  \* La température actuelle de la ville  

&nbsp;  \* La prévision pour le lendemain  



3\. \*\*Formatage des informations\*\*  

&nbsp;  Les températures extraites sont formatées pour être lisibles et compréhensibles.  

&nbsp;  

&nbsp;  Code :  



&nbsp;  `if \[ "$temp\_demain\_number" -gt 0 ]; then`  

&nbsp;      `temp\_demain="+${temp\_demain\_number}°C"`  

&nbsp;  `else`  

&nbsp;      `temp\_demain="${temp\_demain\_number}°C"`  

&nbsp;  `fi`



&nbsp;  Explications :  

&nbsp; 

&nbsp;  Ce bloc ajoute le signe + ou - si nécessaire et le symbole °C, ce qui rend la température lisible et compréhensible pour l’utilisateur.  



&nbsp; 

4\. \*\*Enregistrement dans meteo.txt\*\*

&nbsp;  Les informations sont enregistrées sur une seule ligne dans le fichier meteo.txt avec la structure suivante :

&nbsp;  \[Date] - \[Heure] - Ville : \[Température actuelle] - \[Prévision du lendemain]  

&nbsp;

&nbsp;  Code:  



&nbsp;  `echo "${date\_jour} - ${heure} - ${ville} : ${temp\_actuelle} - ${temp\_demain}" >> meteo.txt`  



&nbsp;  Explications :  

&nbsp;    

&nbsp;  - `${date\_jour}` → date du jour (YYYY-MM-DD)  

&nbsp;  - `${heure}` → heure actuelle (HH:MM)  

&nbsp;  - `${ville}` → nom de la ville passée en argument  

&nbsp;  - `${temp\_actuelle}` → température actuelle récupérée via curl  

&nbsp;  - `${temp\_demain}` → température prévisionnelle formatée  



&nbsp;  Le `>> meteo.txt` indique que tout est écrit sur une seule ligne dans le fichier meteo.txt.  



Sur macOS, le script ne fonctionne pas correctement à cause de différences dans la gestion des caractères et des outils système. Les tableaux renvoyés par wttr.in ne sont pas interprétés de la même façon, ce qui empêche le calcul des températures. Le script ne peut donc pas être lancer sur macOS.



\## Version 2 : Automatisation périodique  



Pour rendre le projet plus pratique, la version 2 introduit :  



1\. \*\*Ville par défaut\*\*  

   Le script peut maintenant fonctionner sans argument.  

&nbsp;  Si aucune ville n’est fournie, il utilise Toulouse comme ville par défaut:  

   `if \[ -z "$1" ]; then`  

&nbsp;  	`echo "Aucun nom de ville spécifié, utilisation de la ville par défaut : Toulouse"`  

&nbsp;  	`ville="Toulouse"`  

 

2\. \*\*Tâche cron pour l’automatisation\*\*  

   Pour mettre en marche la tache cron, il faut :  

&nbsp;  - Rendre le script exécutable avec la commande : `chmod +x /chemin de votre script/Extracteur\_Meteo.sh`  

&nbsp;  - Remplacer dans le fichier meteo.cron `/chemin de votre script/` par le chemin réelle vers Extracteur\_Meteo.sh  

&nbsp;  - Puis exécuter la commande `(crontab -l 2>/dev/null; cat /chemin de meteo.cron/meteo.cron) | crontab - ` après avoir changer `/chemin de meteo.cron/` par le chemin réelle  





























