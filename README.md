** Outil d'Extraction d'Information Météorologique **

Ce projet permet de récupérer périodiquement les informations météorologiques pour une ville donnée via le service [wttr.in](https://wttr.in).  

Le script principal (`Extracteur\_Meteo.sh`) extrait la température actuelle ainsi que la prévision pour le lendemain et les enregistre dans un fichier texte.  



Le projet est développé en plusieurs versions, avec des fonctionnalités supplémentaires à chaque étape. L'utilisation de \*\*Git\*\* permet de suivre toutes les modifications et de gérer les versions.

## Version 1 : Script de base

Le script `Extracteur_Meteo.sh` réalise les étapes suivantes :

1. **Récupération des données météorologiques brutes**  
   Utilise `curl` pour interroger le service wttr.in et récupérer les données météorologiques pour la ville spécifiée en argument. 
   Les données brutes sont sauvegardées dans un fichier temporaire local.  
   Dans la ligne : `curl -s "wttr.in/${ville}?2&T" > meteo_brute.txt`  
   - `curl -s "wttr.in/${ville}?2&T"` → récupère les données météo brutes depuis wttr.in  
   - `> meteo_brute.txt` → les sauvegarde dans un fichier local (meteo_brute.txt)  
 
2. **Extraction des températures**  
   Le script extrait à partir du fichier brut :
   * La température actuelle de la ville  
       `curl -s "wttr.in/${ville}?format=%t"` → récupère la température actuelle
   * La prévision pour le lendemain  

3. **Formatage des informations**  
   Les températures extraites sont formatées pour être lisibles et compréhensibles.  
   
   Code :  

   if [ "$temp_demain_number" -gt 0 ]; then  
       temp_demain="+${temp_demain_number}°C"  
   else  
       temp_demain="${temp_demain_number}°C"  
   fi

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



