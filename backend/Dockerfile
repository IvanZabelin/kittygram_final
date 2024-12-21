FROM python:3.9-slim-buster

WORKDIR /app

# Устанавливаем переменные окружения
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /app/
RUN pip install --upgrade pip \
    && pip install -r requirements.txt --no-cache-dir

# Копируем код в контейнер
COPY . /app/

# Делаем run.sh исполняемым
RUN chmod +x /app/run.sh

# Запускаем скрипт run.sh
CMD ["./run.sh"]

