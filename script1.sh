##############################################################################################
## Script 1 : Ajout d'une ligne au fichier de log <connexion.log>                           ##
##############################################################################################
## Auteur   : Ahmet BASBUNAR                                                                ##
##############################################################################################
## SAE 1.03 - 2024-2025                                                                     ##
##############################################################################################
## Usage   : ./script1.sh <utilisateur>                                                     ##
## Exemple : ./script1.sh e26350u                                                           ##
##############################################################################################

#!/bin/bash

LOG_FILE="connexion.log"   # Nom du fichier de log

# Récupération des infos de connexion
IP=$(hostname -I | awk '{print $1}')             # Récupération de la première adresse IP
USER_NAME=$(whoami)                               # Récupération du nom d'utilisateur courant
HOST_NAME=$(hostname)                             # Récupération du nom de la machine
DATE_CONNEXION=$(date +"%A %d %B %Y %H:%M:%S %Z") # Date/heure en français complet

# Ajout des infos de connexion dans "connexion.log"
echo "$IP;
      $USER_NAME;$HOST_NAME;$DATE_CONNEXION" >> "$LOG_FILE"

# Message de confirmation
echo "--------------------------------------------"
echo "Une ligne a été ajoutée dans $LOG_FILE :"
echo "--------------------------------------------"
echo "Adresse IP        : $IP"
echo "Nom d'utilisateur : $USER_NAME"
echo "Nom de la machine : $HOST_NAME"
echo "Date de connexion : $DATE_CONNEXION"
echo "--------------------------------------------"
