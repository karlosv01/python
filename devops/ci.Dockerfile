# Usamos una imagen base ligera de Python
FROM python:3.10-slim

# Instalamos 'make' y el linter (puedes añadir pytest aquí si lo usas)
RUN apt-get update && \
    apt-get install -y make && \
    rm -rf /var/lib/apt/lists/*

# Definimos el directorio de trabajo
WORKDIR /app

# 1. Copiamos solo los archivos de dependencias primero
# Esto permite que Docker cachee la instalación de librerías
COPY requirements.txt .

# 2. Instalamos las librerías de Python (Flask, Flake8, etc.)
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos TODO el contenido del repositorio al contenedor
COPY . .

# Ejecutamos las reglas del Makefile
# Si 'make lint' o 'make test' fallan (exit code != 0), 
# la construcción del Dockerfile se detendrá y GitHub Actions marcará error.
RUN make lint
RUN make test

# Comando por defecto para cuando arranques el contenedor
CMD ["python", "app.py"]
