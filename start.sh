#!/bin/sh
set -e

: "${DATABASE_URL:?DATABASE_URL is required}"
: "${ARTIFACT_URI:?ARTIFACT_URI is required}"
: "${MLFLOW_AUTH_ADMIN_PASSWORD:?MLFLOW_AUTH_ADMIN_PASSWORD is required}"
: "${MLFLOW_FLASK_SERVER_SECRET_KEY:?MLFLOW_FLASK_SERVER_SECRET_KEY is required}"

cat > /tmp/basic_auth.ini <<EOF
[mlflow]
default_permission = READ
database_uri = ${DATABASE_URL}
admin_username = ${MLFLOW_AUTH_ADMIN_USERNAME:-admin}
admin_password = ${MLFLOW_AUTH_ADMIN_PASSWORD}
EOF

export MLFLOW_AUTH_CONFIG_PATH=/tmp/basic_auth.ini

exec mlflow server \
  --host 0.0.0.0 \
  --port "${PORT:-5000}" \
  --workers 1 \
  --backend-store-uri "${DATABASE_URL}" \
  --registry-store-uri "${DATABASE_URL}" \
  --artifacts-destination "${ARTIFACT_URI}" \
  --app-name basic-auth
