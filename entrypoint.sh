#!/bin/bash

# terminate on errors
set -e

cat << "EOF"

Brought to you by...

      ___           ___           ___           ___           ___
     /|  |         /\  \         /\__\         /\  \         /\  \
    |:|  |         \:\  \       /:/  /        /::\  \        \:\  \         ___
    |:|  |          \:\  \     /:/  /        /:/\:\__\        \:\  \       /\__\
  __|:|  |      ___  \:\  \   /:/  /  ___   /:/ /:/  /    ___  \:\  \     /:/  /
 /\ |:|__|____ /\  \  \:\__\ /:/__/  /\__\ /:/_/:/__/___ /\  \  \:\__\   /:/__/
 \:\/:::::/__/ \:\  \ /:/  / \:\  \ /:/  / \:\/:::::/  / \:\  \ /:/  /  /::\  \
  \::/~~/~      \:\  /:/  /   \:\  /:/  /   \::/~~/~~~~   \:\  /:/  /  /:/\:\  \
   \:\~~\        \:\/:/  /     \:\/:/  /     \:\~~\        \:\/:/  /   \/__\:\  \
    \:\__\        \::/  /       \::/  /       \:\__\        \::/  /         \:\__\
     \/__/         \/__/         \/__/         \/__/         \/__/           \/__/

https://kucrut.org

EOF

# Stolen from https://hub.docker.com/u/binhex/
echo "[info] System information $(uname -a)"

mkdir -p /var/www/wp-content/{uploads,upgrade}

# Set nginx's user ID.
if [ ! -z "${PUID}" ]; then
    echo "[info] PUID defined as '${PUID}'"
    # set user nginx to specified user id (non unique)
    usermod -o -u "${PUID}" nginx &>/dev/null
fi

# Set nginx's group ID.
if [ ! -z "${PGID}" ]; then
    echo "[info] PGID defined as '${PGID}'"
    # set group nginx to specified group id (non unique)
    groupmod -o -g "${PGID}" nginx &>/dev/null
fi

if [ ! -f "/var/www/wp-content/perms.txt" ]; then
    chown -R nginx:nginx /var/www/wp-content/{uploads,upgrade}
    echo "Permission set." > /var/www/wp-content/perms.txt
fi

exec "$@"
