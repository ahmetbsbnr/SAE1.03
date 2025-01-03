##############################################################################################
## Script 2 : statistiques sur le fichier connexion.log par journée et par utilisateur      ##
##############################################################################################
## Auteur   : Ahmet BASBUNAR                                                                ##
##############################################################################################
## SAE 1.03 - 2024-2025                                                                     ##
##############################################################################################
## Usage   : ./script2.sh <utilisateur> <jourSemaine> <jour> <mois> <année>                 ##
## Exemple : ./script2.sh e26350u mercredi 01 janvier 2025                                  ##
##############################################################################################

#!/bin/bash

# 1) Vérification du nombre de paramètres
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <utilisateur> <jour semaine> <jour> <mois> <année>"
    echo "Exemple: $0 e26350u mercredi 01 janvier 2025"
    exit 1
fi

# 2) Paramètres
USERNAME=$1        # e.g. e26350u
DAY_OF_WEEK=$2     # e.g. mercredi
DAY=$3             # e.g. 01
MONTH=$4           # e.g. janvier
YEAR=$5            # e.g. 2025
LOG_FILE="connexion.log"

# 3) Construction de la date pour correspondre au format écrit par script 1
#    -> "mercredi 01 janvier 2025"
DATE_PATTERN="$DAY_OF_WEEK $DAY $MONTH $YEAR"

# 4) Filtrage des logs : on récupère les lignes correspondant à l'utilisateur et à la date construite
FILTERED_LOG=$(grep ";${USERNAME};" "$LOG_FILE" | grep "$DATE_PATTERN")

# 5) Vérification si des logs existent
if [ -z "$FILTERED_LOG" ]; then
    echo "Aucun log trouvé pour l'utilisateur '$USERNAME' à la date '$DATE_PATTERN'."
    exit 1
fi

############################################
# Fonctions de statistiques
############################################

# Fonction 1 : Connexions par heure
Connexions_par_heure() {
    # On suppose que le 4e champ contient : <mercredi 01 janvier 2025 14:31:58 CET>
    # Découpage en 6 segments séparés par des espaces :
    #  1) mercredi
    #  2) 01
    #  3) janvier
    #  4) 2025
    #  5) 14:31:58
    #  6) CET
    #
    # On veut extraire l'heure => 5e segment => ex: <14:31:58> => puis on coupe par <:> => on prend le 1er champ => <14>

    echo "--------------------------------------------"
    echo "Connexions par heure pour $USERNAME le $DATE_PATTERN :"
    echo "--------------------------------------------"

    echo "$FILTERED_LOG" \
      | awk -F';' '{print $4}' \
      | cut -d' ' -f5 \
      | cut -d':' -f1,2 \
      | sort \
      | uniq -c
}

# Fonction 2 : Machines différentes utilisées
Machines_differentes() {
    echo "--------------------------------------------"
    echo "Machines utilisées par $USERNAME le $DATE_PATTERN :"
    echo "--------------------------------------------"

    echo "$FILTERED_LOG" \
      | awk -F';' '{print $3}' \
      | sort \
      | uniq

    echo "Nombre total de machines : $(echo "$FILTERED_LOG" | awk -F';' '{print $3}' | sort | uniq | wc -l)"
}

# Fonction 3 : Adresses IP différentes
IP_differentes() {
    echo "--------------------------------------------"
    echo "Adresses IP utilisées par $USERNAME le $DATE_PATTERN :"
    echo "--------------------------------------------"

    echo "$FILTERED_LOG" \
      | awk -F';' '{print $1}' \
      | sort \
      | uniq

    echo "Nombre total d'adresses IP : $(echo "$FILTERED_LOG" | awk -F';' '{print $1}' | sort | uniq | wc -l)"
}

############################################
# Menu interactif
############################################
while true; do
    echo "============================================"
    echo "=== Statistiques pour $USERNAME le $DATE_PATTERN ==="
    echo "============================================"
    echo "1. Connexions par heure"
    echo "2. Machines différentes utilisées"
    echo "3. Adresses IP différentes utilisées"
    echo "4. Quitter"
    echo "============================================"
    echo -n "Choisir une option (1-4) : "
    read CHOIX

    case $CHOIX in
        1) Connexions_par_heure ;;
        2) Machines_differentes ;;
        3) IP_differentes ;;
        4) echo "Fin du programme."; break ;;
        *) echo "Option invalide. Réessayez." ;;
    esac
done

