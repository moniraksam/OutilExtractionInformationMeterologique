#!/bin/bash


#Cas dont la ville est vide (argument positionnel 1 vide)

if [ -z "$1" ]; then
	echo "Usage Invalide."
	echo "Dans cette version il faut spécifié une ville au 1er argument"
	echo "Usage : $0 'nomDeVille'"
	exit 1
fi

ville=$1


# Curl données métérologique dans fichier meteo.txt

curl https://wttr.in/$ville > meteo.txt
