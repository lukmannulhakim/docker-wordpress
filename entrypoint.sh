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

mysql=( mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} --skip-column-names )

# Stolen from XWP's wp-docker.
function is_db_up() {
  result=$( echo "SHOW DATABASES LIKE '${DB_NAME}'" | "${mysql[@]}" 2>/dev/null )

  if [ "$result" == "${DB_NAME}" ]; then
    return 0
  else
    return 1
  fi
}

# Stolen from https://hub.docker.com/u/binhex/
echo "[info] System information $(uname -a)"

mkdir -p /var/www/wp-content/{uploads,upgrade,languages}

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
    chown -R nginx:nginx /var/www/wp-content/{uploads,upgrade,languages}
    echo "Permission set." > /var/www/wp-content/perms.txt
fi

until is_db_up; do
   echo "Waiting for database to become available..."
   sleep 3
done

echo "Database is available. Starting services..."

exec "$@"
