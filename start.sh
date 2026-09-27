#!/bin/sh
set -e

cat > /tmp/basic_auth.ini <<EOF
[mlflow]
database_uri = ${DATABASE_URL}
EOF

export MLFLOW_AUTH_CONFIG_PATH=/tmp/basic_auth.ini

exec mlflow server \
  --host 0.0.0.0 \
  --port "${PORT:-5000}" \
  --backend-store-uri "${DATABASE_URL}" \
  --artifacts-destination "${ARTIFACT_URI}" \
  --app-name basic-auth
