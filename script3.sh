##############################################################################################
## Script 3 : Statistiques sur le fichier connexion.log sur le mois et par utilisateur      ##
##############################################################################################
## Auteur   : Ahmet BASBUNAR                                                                ##
##############################################################################################
## SAE 1.03 - 2024-2025                                                                     ##
##############################################################################################
## Usage   : ./script3.sh <utilisateur> <mois/année> <0 (écran) | 1 (fichier)>              ##
## Exemple : ./script3.sh e26350u septembre/2024 0                                          ##
##           ./script3.sh e26350u 09/2024 1                                                 ##
##############################################################################################

#!/bin/bash

# 1) Vérification du nombre de paramètres
if [ $# -ne 3 ]; then
    echo "Usage: $0 <utilisateur> <mois/année> <0|1>"
    echo " - <mois/année> doit être sous la forme 'septembre/2024', '09/2024', etc."
    echo " - <0|1> : 0 pour afficher à l'écran, 1 pour enregistrer dans un fichier"
    echo "Exemples:"
    echo "  $0 e26350u 09/2024 0"
    echo "  $0 e26350u septembre/2024 1"
    exit 1
fi

USERNAME="$1"
MOIS_ANNEE="$2"    # Soit "09/2024", soit "septembre/2024", etc.
OUTPUT_MODE="$3"   # 0 => écran, 1 => fichier
LOG_FILE="connexion.log"
ANNEE="$ANNEE_INPUT"


# Séparer le mois et l’année en utilisant le séparateur '/'
IFS='/' read -r MOIS_INPUT ANNEE_INPUT <<< "$MOIS_ANNEE"

# Vérifier que les deux parties ont été correctement séparées
if [ -z "$MOIS_INPUT" ] || [ -z "$ANNEE_INPUT" ]; then
    echo "Erreur: Le format du mois/année doit être 'mois/année' (ex. septembre/2024 ou 09/2024)."
    exit 1
fi

####################################################################################
# 3) Double mappage : mois numérique (01, 09, etc.) OU mois en lettres (janvier…) ##
####################################################################################
# En sortie, on aura la variable $MOIS_LETTRE, ex. "septembre"
case "$MOIS_INPUT" in
  #si le mois est numérique
  "01") MOIS_LETTRE="janvier" ;;
  "02") MOIS_LETTRE="fevrier" ;;
  "03") MOIS_LETTRE="mars" ;;
  "04") MOIS_LETTRE="avril" ;;
  "05") MOIS_LETTRE="mai" ;;
  "06") MOIS_LETTRE="juin" ;;
  "07") MOIS_LETTRE="juillet" ;;
  "08") MOIS_LETTRE="aout" ;;
  "09") MOIS_LETTRE="septembre" ;;
  "10") MOIS_LETTRE="octobre" ;;
  "11") MOIS_LETTRE="novembre" ;;
  "12") MOIS_LETTRE="decembre" ;;
  # si le mois est en lettre
  "janvier"|"fevrier"|"mars"|"avril"|"mai"|"juin"|"juillet"|"aout"|"septembre"|"octobre"|"novembre"|"decembre")
    MOIS_LETTRE="$MOIS_INPUT"
    ;;
  #si le mois est abrégé
  "janv"|"fevr"|"mars"|"avr"|"mai"|"juin"|"juil"|"aout"|"sept"|"oct"|"nov"|"dec")
    MOIS_LETTRE="$MOIS_INPUT"
    ;;
  #si le mois est abrégé
  "janv."|"fevr."|"mars."|"avr."|"mai."|"juin."|"juil."|"aout."|"sept."|"oct."|"nov."|"dec.")
    MOIS_LETTRE="$MOIS_INPUT"
    ;;
  # Sinon, invalide
  *)
    echo "Mois invalide : $MOIS_INPUT"
    exit 1
    ;;
esac

###############################################################################
# 4) Filtrage des logs
###############################################################################
# Filtrer sur l’utilisateur (champ 2) : grep ";$USERNAME;"
# et sur le mot du mois en français (insensible à la casse) : grep -i "$MOIS_LETTRE"
# et sur l'année spécifiée : grep "$ANNEE_INPUT"
FILTERED_LOG=$(grep ";${USERNAME};" "$LOG_FILE" | grep -i "$MOIS_LETTRE" | grep "$ANNEE_INPUT")

###############################################################################
# 5) Vérifier si des logs ont été trouvés
###############################################################################
if [ -z "$FILTERED_LOG" ]; then
    echo "Aucun log détecté pour l'utilisateur '$USERNAME' en $MOIS_LETTRE $ANNEE_INPUT."
    exit 0
fi


###############################################################################
# 6) Mode d'affichage : écran ou fichier
###############################################################################
if [ "$OUTPUT_MODE" -eq 1 ]; then
    # On crée un répertoire portant le nom de l'année extraite
    mkdir -p "$ANNEE"
    # On écrit dans un fichier user_month.log (ex: e26350u_09.log ou e26350u_septembre.log)
    OUTPUT_FILE="${ANNEE}/${USERNAME}_${MOIS_INPUT}.log"
else
    # Affichage direct à l'écran
    OUTPUT_FILE="/dev/stdout"
fi

###############################################################################
# 7) Fonctions statistiques
# On utilise '>> "$OUTPUT_FILE"' partout pour accumuler un unique rapport global
###############################################################################

# Fonction 1 : Nombre total de connexions
total_connexions() {
    local TOTAL
    TOTAL=$(echo "$FILTERED_LOG" | wc -l)

    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Nombre total de connexions pour $USERNAME durant le mois $MOIS_LETTRE $ANNEE : $TOTAL" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 2 : Connexions par jour
connexions_par_jour() {
    local TOTAL
    TOTAL=$(echo "$FILTERED_LOG" | wc -l)

    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Connexions par jour pour $USERNAME durant $MOIS_LETTRE $ANNEE :" >> "$OUTPUT_FILE"

    # Dans le champ date, ex: "dimanche 01 septembre 2024 19:26:58 CET"
    # On découpe par espace et on prend le 2ème champ (le jour)
    echo "$FILTERED_LOG" \
      | awk -F';' '{print $4}' \
      | awk '{print $2}' \
      | sort \
      | uniq -c \
      >> "$OUTPUT_FILE"

    echo "Nombre total de connexions (tous jours confondus) : $TOTAL" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 3 : Machines différentes
Machines_differentes() {
    local MACHINES COUNT
    MACHINES=$(echo "$FILTERED_LOG" \
      | awk -F';' '{print $3}' \
      | sort \
      | uniq)
    COUNT=$(echo "$MACHINES" | wc -l)

    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Machines utilisées par $USERNAME durant le mois $MOIS_LETTRE $ANNEE :" >> "$OUTPUT_FILE"
    echo "$MACHINES" >> "$OUTPUT_FILE"
    echo "Nombre total de machines : $COUNT" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 4 : Adresses IP différentes
AdresseIP() {
    local IPS COUNT
    IPS=$(echo "$FILTERED_LOG" \
      | awk -F';' '{print $1}' \
      | sort \
      | uniq)
    COUNT=$(echo "$IPS" | wc -l)

    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Adresses IP utilisées par $USERNAME durant le mois $MOIS_LETTRE $ANNEE :" >> "$OUTPUT_FILE"
    echo "$IPS" >> "$OUTPUT_FILE"
    echo "Nombre total d'adresses IP : $COUNT" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

###############################################################################
# 8) Menu interactif
###############################################################################
while true; do
    echo "============================================"
    echo "=== Statistiques pour $USERNAME - Mois : $MOIS_LETTRE / $ANNEE ==="
    echo "=== (Mode=$( [ "$OUTPUT_MODE" -eq 0 ] && echo "Écran" || echo "Fichier")) ==="
    echo "============================================"
    echo "1. Nombre total de connexions"
    echo "2. Connexions par jour"
    echo "3. Machines différentes utilisées"
    echo "4. Adresses IP différentes utilisées"
    echo "5. Quitter"
    echo "============================================"

    read -p "Choisir une option (1-5) : " choice
    case $choice in
        1) total_connexions ;;
        2) connexions_par_jour ;;
        3) Machines_differentes ;;
        4) AdresseIP ;;
        5)
            echo "Fin du programme."
            break
            ;;
        *)
            echo "Option invalide. Réessayez."
            ;;
    esac
    echo "============================================"
done
