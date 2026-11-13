# ---------- Etapa 1: ordena los archivos de la app ----------
# Funciona tanto si el repositorio tiene carpetas (templates/, static/css/)
# como si todos los archivos estan sueltos en la raiz.
FROM registry.access.redhat.com/ubi9/python-311:latest AS fuente

WORKDIR /tmp/repo
COPY . /tmp/repo

RUN set -e; \
    mkdir -p /tmp/app/templates /tmp/app/static/css; \
    cp app.py /tmp/app/app.py; \
    if [ -d templates ]; then cp -r templates/. /tmp/app/templates/; fi; \
    for f in *.html; do \
        if [ -f "$f" ]; then cp "$f" /tmp/app/templates/; fi; \
    done; \
    if [ -f static/css/style.css ]; then \
        cp static/css/style.css /tmp/app/static/css/style.css; \
    elif [ -f style.css ]; then \
        cp style.css /tmp/app/static/css/style.css; \
    fi; \
    test -f /tmp/app/templates/base.html  || { echo "ERROR: falta base.html"; exit 1; }; \
    test -f /tmp/app/templates/index.html || { echo "ERROR: falta index.html"; exit 1; }; \
    test -f /tmp/app/static/css/style.css || { echo "ERROR: falta style.css"; exit 1; }

# ---------- Etapa 2: imagen final ----------
FROM registry.access.redhat.com/ubi9/python-311:latest

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /opt/app-root/src

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=fuente --chown=1001:0 /tmp/app/ /opt/app-root/src/

# OpenShift ejecuta el contenedor con un usuario aleatorio sin root: puerto > 1024
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "60", "--access-logfile", "-", "app:app"]
