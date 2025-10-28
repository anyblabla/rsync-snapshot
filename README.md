# 💾 `rsync-snapshot`

## Sauvegardes Incrémentielles Complètes de Serveur avec Rsync

-----

### 🇫🇷 Description du Projet

Ce script est conçu pour effectuer des **sauvegardes incrémentielles complètes (snapshots)** d'un serveur Linux en utilisant l'outil `rsync`.

L'approche snapshot, basée sur la fonctionnalité de lien en dur (`--link-dest`) de `rsync`, permet d'avoir une **copie complète** du serveur à chaque exécution, tout en ne consommant de l'espace disque que pour les fichiers qui ont réellement été modifiés depuis la sauvegarde précédente.

L'exemple fourni est spécifiquement préconfiguré pour la sauvegarde d'un **serveur dédié Nextcloud**, mais il est facilement adaptable à tout autre environnement Linux.

### 🇬🇧 Project Description

This script is designed to perform **full incremental backups (snapshots)** of a Linux server using the powerful `rsync` tool.

The snapshot approach, based on `rsync`'s hard-link feature (`--link-dest`), allows you to have a **complete copy** of the server with each execution, while only consuming disk space for the files that have actually been modified since the previous backup.

The provided example is specifically pre-configured for backing up a **dedicated Nextcloud server**, but it is easily adaptable to any other Linux environment.

-----

### ⚙️ Personnalisation et Adaptation

Ce script doit être adapté aux spécificités de votre serveur. Les deux lignes principales à modifier dans le fichier `rsync-snapshot.sh` sont :

1.  **Le répertoire de destination des sauvegardes (`BACKUP_DIR`)**
    Définissez l'emplacement où toutes les sauvegardes seront stockées (idéalement sur un disque externe ou un partage réseau monté) :

    ```bash
    readonly BACKUP_DIR=/chemin/vers/votre/disque/sauvegardes/
    ```

2.  **Les répertoires à exclure (`--exclude=`)**
    C'est la partie la plus critique. Pour un serveur Nextcloud, vous devez exclure les répertoires contenant des données temporaires ou des montages externes, comme le répertoire `/proc`, `/sys`, ou le cache.

    ```bash
    # Exemple pour Nextcloud :
    --exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* ...
    ```

-----

### 🛠️ Installation et Utilisation

Pour utiliser le script, copiez-le sur votre serveur et suivez les étapes :

1.  **Rendre le script exécutable :**

    ```bash
    chmod +x rsync-snapshot.sh
    ```

2.  **Lancer la sauvegarde :**

    ```bash
    sudo ./rsync-snapshot.sh
    ```

**Note :** Il est fortement recommandé d'utiliser ce script via une tâche planifiée **`cron`** pour automatiser vos sauvegardes quotidiennes ou hebdomadaires.

-----

### 📺 Démonstration

Pour visualiser l'utilisation du script et comprendre en détail le mécanisme de sauvegarde snapshot avec `rsync` :

| Vidéo | Chaîne | Lien |
| :--- | :--- | :--- |
| **Rsync SNAPSHOT - Sauvegarder un serveur Linux complètement** | Blabla Linux | [Regarder la Démonstration](http://www.youtube.com/watch?v=xMMLwsEq8lI) |

-----

### 📝 Licence

Ce projet est sous licence **[À compléter - Ex: MIT, GPL, etc.]**.
http://googleusercontent.com/youtube_content/6
