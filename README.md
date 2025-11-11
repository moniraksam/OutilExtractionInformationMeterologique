# Outil d'Extraction d'Information Météorologique

Ce projet a pour objectif de concevoir un outil automatisé d’extraction d’informations météorologiques pour une ville donnée, en s’appuyant sur le service [wttr.in](https://wttr.in).  

Le script principal (`Extracteur\_Meteo.sh`) interroge ce service afin d’obtenir la température actuelle ainsi que la prévision pour le lendemain, puis consigne ces informations dans un fichier texte au format lisible et structuré.  

Le développement du projet est organisé en plusieurs versions successives, chacune introduisant de nouvelles fonctionnalités. L’utilisation de **Git** assure un suivi rigoureux du code, la gestion des différentes itérations du projet et la traçabilité des contributions de chaque membre de l’équipe.  

## Version 1 : Script de base

Le script `Extracteur_Meteo.sh` réalise les étapes suivantes :

1. **Récupération des données météorologiques brutes**  
   Utilise `curl` pour interroger le service wttr.in et récupérer les données météorologiques pour la ville spécifiée en argument. 
   Les données brutes sont sauvegardées dans un fichier temporaire local.  
   Dans la ligne : `curl -s "wttr.in/${ville}?2&T&m&lang=en" > meteo_brute.txt`  
   - `curl -s "wttr.in/${ville}?2&T&m&lang=en"` → récupère les données météo brutes depuis wttr.in  
   - `> meteo_brute.txt` → les sauvegarde dans un fichier local (meteo_brute.txt)  
 
2. **Extraction des températures**  
   Le script extrait à partir du fichier brut :
   * La température actuelle de la ville  
   * La prévision pour le lendemain  

3. **Formatage des informations**  
   Les températures extraites sont formatées pour être lisibles et compréhensibles.  
   
   Code :  

   `if [ "$temp_demain_number" -gt 0 ]; then`  
       `temp_demain="+${temp_demain_number}°C"`  
   `else`  
       `temp_demain="${temp_demain_number}°C"`  
   `fi`

   Explications :  
  
   Ce bloc ajoute le signe + ou - si nécessaire et le symbole °C, ce qui rend la température lisible et compréhensible pour l’utilisateur.  

  
4. **Enregistrement dans meteo.txt**
   Les informations sont enregistrées sur une seule ligne dans le fichier meteo.txt avec la structure suivante :
   [Date] - [Heure] - Ville : [Température actuelle] - [Prévision du lendemain]  
 
   Code:  

   `echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt`  

   Explications :  
     
   - `${date_jour}` → date du jour (YYYY-MM-DD)  
   - `${heure}` → heure actuelle (HH:MM)  
   - `${ville}` → nom de la ville passée en argument  
   - `${temp_actuelle}` → température actuelle récupérée via curl  
   - `${temp_demain}` → température prévisionnelle formatée  

   Le `>> meteo.txt` indique que tout est écrit sur une seule ligne dans le fichier meteo.txt.  

Sur macOS, le script ne fonctionne pas correctement à cause de différences dans la gestion des caractères et des outils système par rapport à Linux. Les tableaux renvoyés par wttr.in ne sont pas interprétés de la même façon, ce qui empêche le calcul des températures. Le script ne peut donc pas être lancer sur macOS.



