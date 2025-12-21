#!/bin/bash

mkdir netbox
mkdir netbox/media
mkdir -p netbox/redis/data
mkdir netbox/reports
mkdir netbox/scripts

export VAULT_ADDR=https://$1
export VAULT_TOKEN=$2

ENV_FILE="secrets.env"
REDIS_ENV_FILE="secrets-redis.env"

DB_PASSWORD=$(vault kv get -field=netbox_user kv/postgresql/users)
REDIS_PASSWORD=$(vault kv get -field=redis_password kv/netbox)
REDIS_CACHE_PASSWORD=${REDIS_PASSWORD}
SECRET_KEY=$(vault kv get -field=secret_key kv/netbox)

cat > "$ENV_FILE" <<EOF
DB_PASSWORD=${DB_PASSWORD}
REDIS_PASSWORD=${REDIS_PASSWORD}
REDIS_CACHE_PASSWORD=${REDIS_CACHE_PASSWORD}
SECRET_KEY='${SECRET_KEY}'
EOF

cat > "$REDNS_ENV_FILE" <<EOF
REDIS_PASSWORD=${REDIS_PASSWORD}
EOF

chmod 600 "$ENV_FILE"
chmod 600 "$REDIS_ENV_FILE"

cat secrets.env

