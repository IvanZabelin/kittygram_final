#!/bin/bash

# Настройки суперпользователя
ADMIN_USERNAME=${ADMIN_USERNAME:-admin}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@example.com}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-adminpassword}

echo "Starting migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

# Проверяем и создаем директорию для статических файлов, если требуется
if [ -d "/app/collected_static/" ]; then
    echo "Copying collected static files to /app/web/backend_static/static..."
    mkdir -p /app/web/backend_static/static
    cp -r /app/collected_static/. /app/web/backend_static/static
fi

# Создаем суперпользователя, если он еще не существует
echo "Creating superuser if it doesn't exist..."
echo "from django.contrib.auth import get_user_model; \
User = get_user_model(); \
User.objects.filter(username='$ADMIN_USERNAME').exists() or \
User.objects.create_superuser('$ADMIN_USERNAME', '$ADMIN_EMAIL', '$ADMIN_PASSWORD')" | python manage.py shell

echo "Starting Gunicorn server..."
exec gunicorn --bind 0.0.0.0:8000 kittygram_backend.wsgi:application \
    --access-logfile - --error-logfile -
