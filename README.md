# Description
A script to perform full incremental backups of a server using rsync - Here for a Nextcloud Dedicated Server

Un script pour effectuer des sauvegardes incrémentielles complètes d'un serveur à l'aide de rsync - Ici pour un serveur dédié Nextcloud

# Explications modifications/Explanations changes
This script is to be adapted according to your needs.


The two main lines to change are...

* readonly BACKUP_DIR=

* --exclude=

The example of this "rsync-snapshot" script is used to backup a complete server dedicated to Nextcloud.

----------------------------------------------------------------------
Ce script est à adapter selon vos besoins.

Les deux lignes principales à modifier sont...

* readonly BACKUP_DIR=

* --exclude=

L'exemple de ce script "rsync-snapshot" est utilisé pour sauvegarder un serveur complet dédié à Nextcloud.

# Installation
- chmod +x rsync-snapshot.sh

- sudo ./rsync-snapshot.sh

# Demonstration/Démonstration

- https://youtu.be/xMMLwsEq8lI
