#!/bin/bash

# terminate on errors
set -e

chown -R nobody:nobody /var/www
exec "$@"
