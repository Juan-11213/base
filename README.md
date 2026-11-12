# Bolsa de Mercados

Aplicación web en Flask que consulta una base de datos MySQL (`bolsa_mercados`) y muestra activos, precios históricos, noticias, carteras virtuales y alertas. Desplegada en Red Hat Developer Sandbox (OpenShift).

## Estructura

```
app.py                 Aplicación Flask (rutas y conexión a MySQL)
requirements.txt       Dependencias de Python
Dockerfile             Imagen opcional (gunicorn en el puerto 8080)
openshift/bolsa-mercados.yaml  Despliegue completo (MySQL + app) para Import YAML
schema.sql             Tablas y datos de ejemplo (se puede ejecutar varias veces)
consultas_practica.sql Consultas SQL de práctica
templates/             Plantillas HTML (herencia desde base.html)
static/css/style.css   Estilos
```

## Variables de entorno

La app lee primero las variables `DB_*`; si no existen, usa las `MYSQL_*` que crea la plantilla de MySQL de OpenShift.

| Variable      | Alternativa      | Descripción                | Valor por defecto |
|---------------|------------------|----------------------------|-------------------|
| `DB_HOST`     | `MYSQL_HOST`     | Servicio de MySQL          | `mysql`           |
| `DB_PORT`     | `MYSQL_PORT`     | Puerto de MySQL            | `3306`            |
| `DB_USER`     | `MYSQL_USER`     | Usuario de MySQL           | `root`            |
| `DB_PASSWORD` | `MYSQL_PASSWORD` | Contraseña                 | (vacía)           |
| `DB_NAME`     | `MYSQL_DATABASE` | Nombre de la base de datos | `bolsa_mercados`  |
| `PORT`        | —                | Puerto de la app (solo `python app.py`) | `8080` |

## Ejecutar en local

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
mysql -u root -p < schema.sql   # crea la BD y los datos
export DB_HOST=localhost DB_USER=root DB_PASSWORD=tu_clave
python app.py                   # http://localhost:8080
```

En local hay que definir `DB_HOST=localhost`, porque el valor por defecto (`mysql`) es el nombre del servicio dentro de OpenShift.

## Rutas

`/` resumen · `/activos` · `/precios` · `/noticias` · `/carteras` · `/alertas` · `/salud`

## Despliegue en OpenShift

1. Subir el repositorio a GitHub.
2. En la consola: **+Add → Import from Git** y pegar la URL del repo (builder Python).
3. Elegir el mismo grupo de aplicación donde está MySQL y marcar **Create a route**.
4. En el Deployment, pestaña **Environment**, definir `DB_HOST` (nombre del servicio de MySQL), `DB_USER`, `DB_PASSWORD` y `DB_NAME`. Si MySQL se creó con la plantilla de OpenShift, basta con agregar las variables desde su Secret.
5. Cargar `schema.sql` en MySQL, por ejemplo:
   ```bash
   oc rsh deployment/mysql
   mysql -u root -p < schema.sql
   ```
   o con `oc cp schema.sql <pod-mysql>:/tmp/` y luego ejecutarlo dentro del pod.
6. Abrir la ruta y comprobar `/salud`: debe responder `{"estado": "ok"}`.

## Despliegue con un solo YAML (aparece en Topología)

`openshift/bolsa-mercados.yaml` crea MySQL (con volumen), carga `schema.sql`, construye la imagen desde este repositorio y publica la app con su ruta.

1. En la consola: **+Add → Import YAML**, pegar el contenido y **Create** (o `oc apply -f openshift/bolsa-mercados.yaml`).
2. En **Topología** aparecen `mysql` y `bolsa-mercados` conectados. La primera construcción tarda unos minutos.
3. Abrir la ruta de `bolsa-mercados` y comprobar `/salud`.
