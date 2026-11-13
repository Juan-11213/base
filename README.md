# Bolsa de Valores y Mercados Internacionales

Aplicación web en Flask que consulta una base de datos MySQL (`bolsa_mercados`) y muestra activos, precios históricos, noticias, carteras virtuales y alertas. Se despliega en Red Hat OpenShift Developer Sandbox.

## Archivos

```
app.py                  Aplicación Flask (rutas y conexión a MySQL)
requirements.txt        Dependencias de Python
Dockerfile              Imagen (UBI 9 + Python 3.11 + gunicorn, puerto 8080)
.dockerignore           Archivos que no entran a la imagen
bolsa-mercados.yaml     Despliegue completo (MySQL + app + Route) para Import YAML
schema.sql              Base de datos y datos iniciales (copia idéntica dentro del YAML)
consultas_practica.sql  Consultas SQL de práctica
*.html, style.css       Plantillas y estilos (el Dockerfile los ordena en templates/ y static/css/)
```

El Dockerfile funciona con los archivos sueltos en la raíz o con las carpetas `templates/` y `static/css/`.

## Variables de entorno

| Variable      | Valor en OpenShift | Origen    |
|---------------|--------------------|-----------|
| `DB_HOST`     | `mysql`            | ConfigMap `bolsa-mercados-config` |
| `DB_PORT`     | `3306`             | ConfigMap `bolsa-mercados-config` |
| `DB_USER`     | `bolsa`            | Secret `mysql-credenciales` |
| `DB_PASSWORD` | (en el Secret)     | Secret `mysql-credenciales` |
| `DB_NAME`     | `bolsa_mercados`   | Secret `mysql-credenciales` |

## Inicialización de la base de datos

Un initContainer del Deployment `bolsa-mercados` espera a MySQL y ejecuta `schema.sql` **solo si la base de datos no tiene ninguna tabla**. Si el volumen ya tiene datos, no toca nada, así que reiniciar o volver a desplegar no duplica ni borra registros. `schema.sql` ya no contiene `DROP TABLE`.

Para empezar de cero a propósito: `oc delete pvc mysql-datos` junto con el pod de MySQL, o `DROP DATABASE bolsa_mercados; CREATE DATABASE bolsa_mercados;` desde `oc rsh deployment/mysql`, y reiniciar la app.

## Ejecutar en local

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
mysql -u root -p < schema.sql
export DB_HOST=localhost DB_USER=root DB_PASSWORD=tu_clave
python app.py                   # http://localhost:8080
```

Para que Flask encuentre las plantillas en local, los `.html` deben estar en `templates/` y `style.css` en `static/css/`.

## Despliegue en OpenShift

1. En la consola: **+Add → Import YAML**, pegar `bolsa-mercados.yaml` y **Create**.
2. Esperar a que termine el build (`oc get builds`) y a que los pods estén en `Running`.
3. Abrir la ruta de `bolsa-mercados` y comprobar `/salud`: debe responder `{"estado": "ok"}`.
4. Para reconstruir tras cambiar el código en GitHub: `oc start-build bolsa-mercados`.

Rutas de la app: `/` · `/activos` · `/precios` · `/noticias` · `/carteras` · `/alertas` · `/salud`
