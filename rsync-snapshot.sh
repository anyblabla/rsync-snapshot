#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=""

# A script to perform full incremental backups of a server using rsync - Here for a Nextcloud Dedicated Server
# Un script pour effectuer des sauvegardes incrémentielles complètes d un serveur à l aide de rsync - Ici pour un serveur dédié Nextcloud

set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_DIR="/"
readonly BACKUP_DIR="/media/any/backup-rsync/rsync/system"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

rsync -av --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  --exclude={"/swap.img","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/home/*","/lost+found","/srv/nextcloud/data/appdata_ocpg7fho3f71/preview/*",>
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"
