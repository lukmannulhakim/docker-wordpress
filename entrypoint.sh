#!/bin/bash

# terminate on errors
set -e

cat << "EOF"
Created by...
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

export PUID=$(echo "${PUID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PUID}" ]]; then
    echo "[info] PUID defined as '${PUID}'"
else
    echo "[warn] PUID not defined (via -e PUID), defaulting to '99'"
    export PUID="99"
fi

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" nobody &>/dev/null

export PGID=$(echo "${PGID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PGID}" ]]; then
    echo "[info] PGID defined as '${PGID}'"
else
    echo "[warn] PGID not defined (via -e PGID), defaulting to '100'"
    export PGID="100"
fi

# set group nobody to specified group id (non unique)
groupmod -o -g "${PGID}" nobody &>/dev/null

mkdir -p /var/www/content/{uploads,upgrade}

if [[ ! -f "/var/www/content/perms.txt" ]]; then
    echo "Setting uploads & upgrade directories permissions..."
    chown -R nobody:nobody /var/www/content/{uploads,upgrade}
    echo "Permission set to ${PUID}:${PGID}" > /var/www/content/perms.txt
fi

exec "$@"
