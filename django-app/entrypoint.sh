#!/bin/bash

postgres_ready() {
    python << END
import sys
from psycopg2 import connect
from psycopg2.errors import OperationalError
try:
    connect(
        dbname="${RDS_DB_NAME}",
        user="${RDS_USERNAME}",
        password="${RDS_PASSWORD}",
        host="${RDS_HOSTNAME}",
        port="${RDS_PORT}",
    )
except OperationalError:
    sys.exit(-1)
END
}

if [ "$RDS_DB_NAME" != "" ]; then
    until postgres_ready; do
        >&2 echo "Waiting for PostgreSQL to become available..."
        sleep 5
    done
    >&2 echo "PostgreSQL is available"
fi

python manage.py makemigrations
python manage.py migrate
if [ "$DJANGO_SUPERUSER_USERNAME" != "" ]; then
    python manage.py createsuperuser --noinput;\
fi

exec "$@"
