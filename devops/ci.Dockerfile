# Usamos una imagen base ligera de Python
FROM python:3.10-slim

# Instalamos 'make' y el linter (puedes añadir pytest aquí si lo usas)
RUN apt-get update && \
    apt-get install -y make && \
    pip install --no-cache-dir flake8 && \
    rm -rf /var/lib/apt/lists/*

# Definimos el directorio de trabajo
WORKDIR /app

# Copiamos TODO el contenido del repositorio al contenedor
COPY . .

# Ejecutamos las reglas del Makefile
# Si 'make lint' o 'make test' fallan (exit code != 0), 
# la construcción del Dockerfile se detendrá y GitHub Actions marcará error.
RUN make lint
RUN make test

# Comando por defecto para cuando arranques el contenedor
CMD ["python", "app.py"]
