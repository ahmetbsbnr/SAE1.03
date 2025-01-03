####################################################################################################
## Script 4 : Statistiques sur le fichier connexion.log sur le mois et pour tous les utilisateurs ##
####################################################################################################
## Auteur   : Ahmet BASBUNAR                                                                      ##
####################################################################################################
## SAE 1.03 - 2024-2025                                                                           ##
####################################################################################################
## Usage   : ./script4.sh <mois/année> <0 (écran) | 1 (fichier)>                                  ##
## Exemple : ./script4.sh novembre/2024 0                                                         ##
##           ./script4.sh 11/2024 1                                                               ##
####################################################################################################

#!/bin/bash

# 1) Vérification du nombre de paramètres saisi par l'utilisateur
if [ $# -ne 2 ]; then
    echo "Usage: $0 <mois/année> <0|1>"
    echo " - <mois/année> doit être sous la forme 'novembre/2024', '11/2024', etc."
    echo " - <0|1> : 0 pour afficher à l'écran, 1 pour enregistrer dans un fichier"
    echo "Exemples:"
    echo "  $0 11/2024 0"
    echo "  $0 novembre/2024 1"
    exit 1
fi

MOIS_ANNEE="$1"    # Soit "11/2024", soit "novembre/2024", etc.
OUTPUT_MODE="$2"   # 0 => écran, 1 => fichier
LOG_FILE="connexion.log"

# 2) Parser le Mois et l’Année depuis le premier argument
IFS='/' read -r MOIS_INPUT ANNEE_INPUT <<< "$MOIS_ANNEE"

# Vérifier que les deux parties ont été correctement séparées
if [ -z "$MOIS_INPUT" ] || [ -z "$ANNEE_INPUT" ]; then
    echo "Erreur: Le format du mois/année doit être 'mois/année' (ex. novembre/2024 ou 11/2024)."
    exit 1
fi

# 3) Grande mappage : 
#   mois numérique (01, 11, etc.) 
# OU mois en lettres (novembre…) 
# OU mois abrégé (nov, dec, etc.) 
# OU mois abrégé avec point (nov., dec., etc.)

# En sortie, on aura la variable $MOIS_LETTRE, ex. "novembre"
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
  "janvier") MOIS_LETTRE="janvier" ;;
  "fevrier") MOIS_LETTRE="fevrier" ;;
  "mars") MOIS_LETTRE="mars" ;;
  "avril") MOIS_LETTRE="avril" ;;
  "mai") MOIS_LETTRE="mai" ;;
  "juin") MOIS_LETTRE="juin" ;;
  "juillet") MOIS_LETTRE="juillet" ;;
  "aout") MOIS_LETTRE="aout" ;;
  "septembre") MOIS_LETTRE="septembre" ;;
  "octobre") MOIS_LETTRE="octobre" ;;
  "novembre") MOIS_LETTRE="novembre" ;;
  "decembre") MOIS_LETTRE="decembre" ;;

  #si le mois est abrégé
  "janv") MOIS_LETTRE="janvier" ;;
  "fevr") MOIS_LETTRE="fevrier" ;;
  "mars") MOIS_LETTRE="mars" ;;
  "avr") MOIS_LETTRE="avril" ;;
  "mai") MOIS_LETTRE="mai" ;;
  "juin") MOIS_LETTRE="juin" ;;
  "juil") MOIS_LETTRE="juillet" ;;
  "aout") MOIS_LETTRE="aout" ;;
  "sept") MOIS_LETTRE="septembre" ;;
  "oct") MOIS_LETTRE="octobre" ;;
  "nov") MOIS_LETTRE="novembre" ;;
  "dec") MOIS_LETTRE="decembre" ;;

  #si le mois est abrégé
  "janv.") MOIS_LETTRE="janvier" ;;
  "fevr.") MOIS_LETTRE="fevrier" ;;
  "mars.") MOIS_LETTRE="mars" ;;
  "avr.") MOIS_LETTRE="avril" ;;
  "mai.") MOIS_LETTRE="mai" ;;
  "juin.") MOIS_LETTRE="juin" ;;
  "juil.") MOIS_LETTRE="juillet" ;;
  "aout.") MOIS_LETTRE="aout" ;;
  "sept.") MOIS_LETTRE="septembre" ;;
  "oct.") MOIS_LETTRE="octobre" ;;
  "nov.") MOIS_LETTRE="novembre" ;;
  "dec.") MOIS_LETTRE="decembre" ;;
        *) 
            echo "Mois invalide : $MOIS_INPUT"
            exit 1
            ;;
    esac
    ;;
  # Sinon, invalide
  *)
    echo "Mois invalide : $MOIS_INPUT"
    exit 1
    ;;
esac

# 4) Filtrage des logs
# Filtrer les lignes correspondant au mois et à l'année spécifiés
FILTERED_LOG=$(grep -i "$MOIS_LETTRE" "$LOG_FILE" | grep "$ANNEE_INPUT")

# 5) Vérifier si des logs ont été trouvés
if [ -z "$FILTERED_LOG" ]; then
    echo "Aucun log détecté pour le mois '$MOIS_LETTRE' en $ANNEE_INPUT."
    exit 0
fi

# 6) Gestion du Mode de Sortie
if [ "$OUTPUT_MODE" -eq 1 ]; then
    # Créer un répertoire portant le nom de l'année s'il n'existe pas
    mkdir -p "$ANNEE_INPUT"
    
    # Déterminer le format du fichier de sortie
    # Utiliser le numéro du mois si MOIS_INPUT est numérique, sinon convertir le nom en numéro
    if [[ "$MOIS_INPUT" =~ ^[0-9]{1,2}$ ]]; then
        OUTPUT_FILE="${ANNEE_INPUT}/${MOIS_NUM}.log"
    else
        # Convertir le nom du mois en numéro
        case "$MOIS_LETTRE" in
            "janvier") MOIS_NUM="01" ;;
            "fevrier") MOIS_NUM="02" ;;
            "mars") MOIS_NUM="03" ;;
            "avril") MOIS_NUM="04" ;;
            "mai") MOIS_NUM="05" ;;
            "juin") MOIS_NUM="06" ;;
            "juillet") MOIS_NUM="07" ;;
            "aout") MOIS_NUM="08" ;;
            "septembre") MOIS_NUM="09" ;;
            "octobre") MOIS_NUM="10" ;;
            "novembre") MOIS_NUM="11" ;;
            "decembre") MOIS_NUM="12" ;;

            "janv") MOIS_NUM="01" ;;
            "fevr") MOIS_NUM="02" ;;
            "mars") MOIS_NUM="03" ;;
            "avr") MOIS_NUM="04" ;;
            "mai") MOIS_NUM="05" ;;
            "juin") MOIS_NUM="06" ;;
            "juil") MOIS_NUM="07" ;;
            "aout") MOIS_NUM="08" ;;
            "sept") MOIS_NUM="09" ;;
            "oct") MOIS_NUM="10" ;;
            "nov") MOIS_NUM="11" ;;
            "dec") MOIS_NUM="12" ;;

            "janv.") MOIS_NUM="01" ;;
            "fevr.") MOIS_NUM="02" ;;
            "mars.") MOIS_NUM="03" ;;
            "avr.") MOIS_NUM="04" ;;
            "mai.") MOIS_NUM="05" ;;
            "juin.") MOIS_NUM="06" ;;
            "juil.") MOIS_NUM="07" ;;
            "aout.") MOIS_NUM="08" ;;
            "sept.") MOIS_NUM="09" ;;
            "oct.") MOIS_NUM="10" ;;
            "nov.") MOIS_NUM="11" ;;
            "dec.") MOIS_NUM="12" ;;
            *) 
                echo "Erreur: Impossible de déterminer le numéro du mois pour '$MOIS_LETTRE'."
                exit 1
                ;;
        esac
        OUTPUT_FILE="${ANNEE_INPUT}/${MOIS_NUM}.log"
    fi
else
    # Affichage direct à l'écran
    OUTPUT_FILE="/dev/stdout"
fi

# Fonction 1 : Nombre total de connexions au cours du mois
nombre_total_connexions() {
    local TOTAL
    TOTAL=$(wc -l <<< "$FILTERED_LOG")
    
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Nombre total de connexions au cours du mois $MOIS_LETTRE $ANNEE_INPUT : $TOTAL" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 2 : Nombre de connexions par utilisateur au cours du mois
connexions_par_utilisateur() {
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Nombre de connexions par utilisateur au cours du mois $MOIS_LETTRE $ANNEE_INPUT :" >> "$OUTPUT_FILE"
    
    # Extraire le champ utilisateur et compter les occurrences
    echo "$FILTERED_LOG" | awk -F';' '{print $2}' | sort | uniq -c | sort -nr >> "$OUTPUT_FILE"
    
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 3 : Nombre de connexions par jour pour le mois
connexions_par_jour() {
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Nombre de connexions par jour pour le mois $MOIS_LETTRE $ANNEE_INPUT :" >> "$OUTPUT_FILE"
    
    # Extraire la date complète, puis le jour spécifique (champ 2)
    echo "$FILTERED_LOG" | awk -F';' '{print $4}' | awk '{print $2}' | sort | uniq -c | sort -nr >> "$OUTPUT_FILE"
    
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

# Fonction 4 : Nombre de machines différentes utilisées au cours du mois
machines_differentes() {
    local MACHINES COUNT
    MACHINES=$(echo "$FILTERED_LOG" | awk -F';' '{print $3}' | sort | uniq)
    COUNT=$(echo "$MACHINES" | wc -l)

    echo "--------------------------------------------" >> "$OUTPUT_FILE"
    echo "Machines différentes utilisées au cours du mois $MOIS_LETTRE $ANNEE_INPUT :" >> "$OUTPUT_FILE"
    echo "$MACHINES" >> "$OUTPUT_FILE"
    echo "Nombre total de machines différentes utilisées : $COUNT" >> "$OUTPUT_FILE"
    echo "--------------------------------------------" >> "$OUTPUT_FILE"
}

###############################################################################
# 8) Menu interactif pour l'utilisateur                                      ##
###############################################################################
while true; do
    echo "===================================================================="
    echo "=== Statistiques pour le Mois : $MOIS_LETTRE / $ANNEE_INPUT ==="
    echo "=== (Mode=$( [ "$OUTPUT_MODE" -eq 0 ] && echo "Écran" || echo "Fichier")) ==="
    echo "===================================================================="
    echo "1. Nombre total de connexions au cours du mois"
    echo "2. Nombre de connexions par utilisateur au cours du mois"
    echo "3. Nombre de connexions par jour pour le mois"
    echo "4. Nombre de machines différentes utilisées au cours du mois"
    echo "5. Quitter"
    echo "===================================================================="

    read -p "Choisir une option (1-5) : " choice
    case $choice in
        1) nombre_total_connexions ;;
        2) connexions_par_utilisateur ;;
        3) connexions_par_jour ;;
        4) machines_differentes ;;
        5)
            echo "Fin du programme."
            break
            ;;
        *)
            echo "Option invalide. Réessayez."
            ;;
    esac
    echo "===================================================================="
done
