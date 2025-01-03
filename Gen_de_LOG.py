#!/usr/bin/env python3
import datetime
import random

##############################################################################
# Configuration
##############################################################################

USER = "e26350u"  # Utilisateur "fixe"

# Salles et nombre de machines dans chacune
rooms = {
    "E37": 30,
    "F13": 15,
    "F23": 30,
    "F33": 30,
    "F36": 30,
    "F39": 16
}

# Intervalle de dates : du 1er septembre 2024 au 31 janvier 2025
start_date = datetime.date(2024, 9, 1)   # 2024-09-01
end_date   = datetime.date(2025, 1, 31)  # 2025-01-31

##############################################################################
# Construction de la liste complète des machines
##############################################################################
all_machines = []
for room, count in rooms.items():
    for i in range(1, count + 1):
        # Exemple : "iutm-inf-E37-1"
        machine_name = f"iutm-inf-{room}-{i}"
        all_machines.append(machine_name)

##############################################################################
# Fonctions auxiliaires
##############################################################################

def generate_random_ip():
    """Génère une IP aléatoire dans la plage 100.64.x.x."""
    octet3 = random.randint(0, 255)
    octet4 = random.randint(0, 255)
    return f"100.64.{octet3}.{octet4}"

def format_date_in_french(dt):
    """
    Transforme un datetime Python en chaîne du style 
    "mercredi 01 janvier 2025 14:31:58 CET" (format français).
    """
    days_fr = ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"]
    months_fr = [
        "janvier", "février", "mars", "avril", "mai", "juin",
        "juillet", "août", "septembre", "octobre", "novembre", "décembre"
    ]
    day_of_week_fr = days_fr[dt.weekday()]       # 0 = lundi, 6 = dimanche
    month_fr = months_fr[dt.month - 1]           # 1 => index 0, etc.
    date_str = (f"{day_of_week_fr} "
                f"{dt.day:02d} "
                f"{month_fr} "
                f"{dt.year} "
                f"{dt.hour:02d}:{dt.minute:02d}:{dt.second:02d} "
                f"CET")
    return date_str

##############################################################################
# Génération d'un log par jour, par machine
##############################################################################

def main():
    # Ouverture du fichier connexion.log en écriture
    with open("connexion.log", "w", encoding="utf-8") as f:

        # Boucle sur chaque jour entre start_date et end_date
        current_date = start_date
        total_lines = 0

        while current_date <= end_date:
            # Pour chaque machine
            for machine in all_machines:
                # Générer l'IP
                ip = generate_random_ip()
                # Générer une heure/minute/seconde aléatoire
                hour = random.randint(0, 23)
                minute = random.randint(0, 59)
                second = random.randint(0, 59)
                
                # Construire le datetime complet
                dt = datetime.datetime(
                    current_date.year,
                    current_date.month,
                    current_date.day,
                    hour, minute, second
                )

                # Formater la date en français
                date_str = format_date_in_french(dt)

                # Ligne : IP;USER;MACHINE;date_str
                line = f"{ip};{USER};{machine};{date_str}\n"
                f.write(line)
                total_lines += 1

            # Jour suivant
            current_date += datetime.timedelta(days=1)

    print(f"Fichier connexion.log généré avec {total_lines} lignes.")


if __name__ == "__main__":
    main()
