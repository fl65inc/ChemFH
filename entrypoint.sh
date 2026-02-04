#!/bin/bash
set -e

if [ -n "$DATABASE_PATH" ] && [ ! -f "$DATABASE_PATH" ]; then
    echo "Initializing database at $DATABASE_PATH"
    if [ -f /app/db.sqlite3 ]; then
        cp /app/db.sqlite3 "$DATABASE_PATH"
    fi
fi

python manage.py migrate --noinput

exec gunicorn ChemFH.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 2 \
    --threads 4 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile -
