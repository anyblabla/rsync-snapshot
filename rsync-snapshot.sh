#!/bin/bash

# ==============================================================================
# TITRE: Sauvegarde incrémentielle (snapshot) complète du système (Nextcloud)
# AUTEUR: Amaury Libert (Base) | Amélioré par l'IA
# LICENCE: GPLv3
# DESCRIPTION:
#   Effectue une sauvegarde incrémentielle complète d'un serveur Nextcloud
#   en utilisant rsync --link-dest pour créer des snapshots économes en espace.
# ==============================================================================

# --- Configuration du Mode Strict et du Path ---

# Mode strict: Quitte immédiatement en cas d'erreur (errexit),
# variable non définie (nounset), ou échec dans un pipe (pipefail).
set -o errexit
set -o nounset
set -o pipefail

# Définition standard du PATH (Bonne pratique)
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# MAILTO est souvent défini pour les tâches cron, mais laissé vide si non utilisé.
# MAILTO="root"

# --- Variables de Configuration ---

# Répertoire source à sauvegarder (la racine du système)
readonly SOURCE_DIR="/"

# Répertoire racine où les sauvegardes seront stockées (sur le disque de backup)
readonly BACKUP_ROOT="/media/any/backup-rsync/rsync/system"

# Dossier du snapshot en cours (avec horodatage)
readonly DATETIME="$(date '+%Y-%m-%d_%H%M%S')"
readonly BACKUP_PATH="${BACKUP_ROOT}/${DATETIME}"

# Lien symbolique pointant vers la dernière sauvegarde réussie
readonly LATEST_LINK="${BACKUP_ROOT}/latest"

# Fichier temporaire pour stocker les erreurs rsync
readonly RSYNC_LOG="/tmp/rsync_backup_${DATETIME}.log"


# --- Liste des Exclusions (Améliorée) ---

# Exclusions des répertoires systèmes non essentiels ou temporaires (Standard)
EXCLUSIONS_SYSTEM=(
    "/dev/*"
    "/proc/*"
    "/sys/*"
    "/tmp/*"
    "/run/*"
    "/mnt/*"
    "/media/*"
    "/lost+found"
    "/swap.img"
    "/swapfile"
    "/timeshift"
)

# Exclusions spécifiques aux serveurs (Nextcloud)
# NOTE : Les données utilisateur Nextcloud sont généralement sauvegardées séparément
# ou via une méthode spécifique pour garantir la cohérence (arrêt du serveur, mode maintenance, etc.)
EXCLUSIONS_NEXTCLOUD=(
    "/srv/nextcloud/data/appdata_*/preview/*" # Cache de prévisualisation Nextcloud (volumineux)
    "/srv/nextcloud/data/*/cache" # Répertoires de cache
    "/srv/nextcloud/data/Amaury/*" # Données utilisateur (exclure ici si géré séparément)
    "/srv/nextcloud/data/Natacha/*" # Données utilisateur (exclure ici si géré séparément)
    # Exclure le dossier 'files' si on ne veut pas les données brutes, mais uniquement la config
    # "/srv/nextcloud/data/*/files/*"
)

# Concaténer toutes les exclusions dans un format compatible avec rsync --exclude
EXCLUDE_LIST=$(printf --exclude='{%s}' "${EXCLUSIONS_SYSTEM[@]}" "${EXCLUSIONS_NEXTCLOUD[@]}")


# --- Fonctions ---

# Fonction pour gérer les erreurs et nettoyer
cleanup() {
    # Vérifier si la dernière commande rsync a échoué
    if [ $? -ne 0 ]; then
        echo -e "\n${ROUGE}ERREUR : La sauvegarde rsync a échoué. Le snapshot incomplet sera supprimé : ${BACKUP_PATH}${FIN}" >&2
        rm -rf "${BACKUP_PATH}" || echo "Impossible de supprimer le répertoire incomplet." >&2
        echo "Consultez le fichier de log : ${RSYNC_LOG}" >&2
        exit 1
    fi
    # Nettoyer le log temporaire si tout va bien
    rm -f "${RSYNC_LOG}"
}
# Assurer l'exécution de la fonction cleanup en cas de sortie anormale (via set -e)
trap cleanup EXIT


# --- Exécution Principale ---

echo -e "${JAUNE}*** Préparation de la sauvegarde incrémentielle... ***${FIN}"

# 1. Création du répertoire de destination
mkdir -p "${BACKUP_PATH}"

# 2. Exécution de rsync
echo "Démarrage de rsync vers ${BACKUP_PATH}..."
# Utilisation de find pour vérifier si le dernier lien existe et est un répertoire valide
if [ -d "${LATEST_LINK}" ]; then
    LINK_DEST_OPT="--link-dest=${LATEST_LINK}"
    echo "Utilisation de la sauvegarde précédente (${LATEST_LINK}) comme base."
else
    LINK_DEST_OPT=""
    echo "Première sauvegarde ou lien précédent introuvable. Effect
