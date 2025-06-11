# SAE103 – Introduction au Système d’Exploitation

## Objectif
Développer quatre scripts Bash pour enregistrer les connexions des utilisateurs et produire des statistiques journalières et mensuelles.

## Scripts inclus

1. **log_connexion.sh**  
   - Description : ajoute une ligne dans `connexion.log` à chaque exécution.  
   - Format : `IP;utilisateur;machine;YYYY-MM-DD_HH:MM:SS`  
   - Usage :
     ```bash
     ./log_connexion.sh
     ```

2. **stats_journalieres.sh**  
   - Description : affiche pour un utilisateur et un jour donné :
     - Total de connexions et détail par heure
     - Nombre et liste des machines utilisées
     - Nombre et liste des adresses IP utilisées
   - Usage :
     ```bash
     ./stats_journalieres.sh <utilisateur> <YYYY-MM-DD> [fichier_sortie]
     ```

3. **stats_mensuelles_user.sh**  
   - Description : affiche pour un utilisateur et un mois donné :
     1. Total des connexions
     2. Connexions par jour
     3. Machines différentes (liste + total)
     4. IP différentes (liste + total)
   - Mode : écran (`0`) ou fichier (`1`).  
   - Usage :
     ```bash
     ./stats_mensuelles_user.sh <utilisateur> <MM> <0|1>
     ```

4. **stats_mensuelles_all.sh**  
   - Description : mêmes statistiques que ci‑dessus pour **tous** les utilisateurs.  
   - Mode : écran (`0`) ou fichier (`1`).  
   - Usage :
     ```bash
     ./stats_mensuelles_all.sh <MM> <0|1>
     ```

## Prérequis
- Système GNU/Linux avec Bash
- Commandes : `date`, `grep`, `awk`, `cut`, `mkdir`, `test`

## Installation
1. Cloner le dépôt :
   ```bash
   git clone https://.../sae103.git
   cd sae103
   
2. Rendre exécutables les scripts :

   ```bash
   chmod +x *.sh
   ```

## Auteurs

* BASBUNAR Ahmet
* IUT de Metz – Année 2024-2025

---
