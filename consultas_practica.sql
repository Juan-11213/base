-- Consultas de práctica para la base de datos bolsa_mercados.
-- Ejecutar primero schema.sql. Las sentencias UPDATE y DELETE de la parte
-- final MODIFICAN los datos; si quieres restaurarlos, vuelve a ejecutar schema.sql.
USE bolsa_mercados;

SHOW TABLES;

SELECT * FROM usuarios;
SELECT * FROM mercados;
SELECT * FROM empresas;
SELECT * FROM monedas;
SELECT * FROM activos;
SELECT * FROM precios_historicos;
SELECT * FROM tasas_cambio;
SELECT * FROM favoritos;
SELECT * FROM carteras_virtuales;
SELECT * FROM detalle_cartera;
SELECT * FROM noticias;
SELECT * FROM alertas;

SELECT * FROM empresas
WHERE nombre = 'Apple';

SELECT * FROM empresas
WHERE pais = 'Estados Unidos';

SELECT * FROM activos
WHERE tipo = 'Accion';

SELECT * FROM precios_historicos
WHERE precio > 200;

SELECT * FROM precios_historicos
WHERE precio < 100;

SELECT * FROM usuarios
WHERE correo = 'juan@gmail.com';

SELECT * FROM alertas
WHERE estado = 'Activa';

SELECT * FROM empresas
WHERE nombre LIKE 'A%';

SELECT * FROM empresas
WHERE nombre LIKE '%o%';

SELECT * FROM usuarios
WHERE nombre LIKE 'J%';

SELECT * FROM empresas
WHERE nombre LIKE '%a';

SELECT * FROM empresas
ORDER BY nombre ASC;

SELECT * FROM empresas
ORDER BY nombre DESC;

SELECT * FROM precios_historicos
ORDER BY precio ASC;

SELECT * FROM precios_historicos
ORDER BY precio DESC;

SELECT * FROM empresas
LIMIT 3;

SELECT * FROM precios_historicos
ORDER BY precio DESC
LIMIT 5;

SELECT * FROM usuarios
LIMIT 2;

SELECT COUNT(*) AS total_usuarios
FROM usuarios;

SELECT COUNT(*) AS total_empresas
FROM empresas;

SELECT AVG(precio) AS precio_promedio
FROM precios_historicos;

SELECT MAX(precio) AS precio_maximo
FROM precios_historicos;

SELECT MIN(precio) AS precio_minimo
FROM precios_historicos;

SELECT SUM(precio) AS suma_precios
FROM precios_historicos;

SELECT pais, COUNT(*) AS total_empresas
FROM empresas
GROUP BY pais;

SELECT sector, COUNT(*) AS total_empresas
FROM empresas
GROUP BY sector;

SELECT tipo, COUNT(*) AS total_activos
FROM activos
GROUP BY tipo;

SELECT id_activo, AVG(precio) AS precio_promedio
FROM precios_historicos
GROUP BY id_activo;

SELECT pais, COUNT(*) AS total_empresas
FROM empresas
GROUP BY pais
HAVING COUNT(*) > 1;

SELECT id_activo, AVG(precio) AS promedio
FROM precios_historicos
GROUP BY id_activo
HAVING AVG(precio) > 100;

SELECT
    activos.nombre AS activo,
    activos.simbolo,
    empresas.nombre AS empresa
FROM activos
INNER JOIN empresas
ON activos.id_empresa = empresas.id_empresa;

SELECT
    activos.nombre AS activo,
    mercados.nombre AS mercado,
    mercados.pais
FROM activos
INNER JOIN mercados
ON activos.id_mercado = mercados.id_mercado;

SELECT
    activos.nombre AS activo,
    precios_historicos.precio,
    precios_historicos.fecha
FROM precios_historicos
INNER JOIN activos
ON precios_historicos.id_activo = activos.id_activo;

SELECT
    usuarios.nombre AS usuario,
    carteras_virtuales.nombre AS cartera,
    carteras_virtuales.saldo_virtual
FROM usuarios
INNER JOIN carteras_virtuales
ON usuarios.id_usuario = carteras_virtuales.id_usuario;

SELECT
    empresas.nombre AS empresa,
    activos.nombre AS activo
FROM empresas
LEFT JOIN activos
ON empresas.id_empresa = activos.id_empresa;

SELECT
    usuarios.nombre AS usuario,
    activos.nombre AS favorito
FROM usuarios
LEFT JOIN favoritos
ON usuarios.id_usuario = favoritos.id_usuario
LEFT JOIN activos
ON favoritos.id_activo = activos.id_activo;

SELECT
    usuarios.nombre,
    carteras_virtuales.nombre AS cartera
FROM usuarios
LEFT JOIN carteras_virtuales
ON usuarios.id_usuario = carteras_virtuales.id_usuario;

SELECT
    activos.nombre AS activo,
    activos.simbolo,
    empresas.nombre AS empresa,
    empresas.sector,
    mercados.nombre AS mercado,
    mercados.pais
FROM activos
INNER JOIN empresas
ON activos.id_empresa = empresas.id_empresa
INNER JOIN mercados
ON activos.id_mercado = mercados.id_mercado;

SELECT
    usuarios.nombre AS usuario,
    activos.nombre AS activo_favorito,
    activos.simbolo
FROM favoritos
INNER JOIN usuarios
ON favoritos.id_usuario = usuarios.id_usuario
INNER JOIN activos
ON favoritos.id_activo = activos.id_activo;

SELECT
    usuarios.nombre AS usuario,
    carteras_virtuales.nombre AS cartera,
    activos.nombre AS activo,
    detalle_cartera.cantidad,
    detalle_cartera.precio_compra
FROM detalle_cartera
INNER JOIN carteras_virtuales
ON detalle_cartera.id_cartera = carteras_virtuales.id_cartera
INNER JOIN usuarios
ON carteras_virtuales.id_usuario = usuarios.id_usuario
INNER JOIN activos
ON detalle_cartera.id_activo = activos.id_activo;

SELECT
    origen.nombre AS moneda_origen,
    destino.nombre AS moneda_destino,
    tasas_cambio.tasa
FROM tasas_cambio
INNER JOIN monedas AS origen
ON tasas_cambio.id_moneda_origen = origen.id_moneda
INNER JOIN monedas AS destino
ON tasas_cambio.id_moneda_destino = destino.id_moneda;

SELECT
    origen.codigo AS moneda_origen,
    destino.codigo AS moneda_destino,
    tasas_cambio.tasa
FROM tasas_cambio
INNER JOIN monedas AS origen
ON tasas_cambio.id_moneda_origen = origen.id_moneda
INNER JOIN monedas AS destino
ON tasas_cambio.id_moneda_destino = destino.id_moneda
WHERE origen.codigo = 'USD'
AND destino.codigo = 'COP';

SELECT
    noticias.titulo,
    noticias.descripcion,
    noticias.fuente,
    empresas.nombre AS empresa
FROM noticias
LEFT JOIN empresas
ON noticias.id_empresa = empresas.id_empresa;

SELECT *
FROM noticias
WHERE id_empresa = 1;

SELECT *
FROM noticias
ORDER BY fecha_publicacion DESC;

SELECT
    usuarios.nombre AS usuario,
    activos.nombre AS activo,
    alertas.precio_objetivo,
    alertas.tipo_alerta,
    alertas.estado
FROM alertas
INNER JOIN usuarios
ON alertas.id_usuario = usuarios.id_usuario
INNER JOIN activos
ON alertas.id_activo = activos.id_activo;

SELECT *
FROM alertas
WHERE id_usuario = 1;

SELECT *
FROM alertas
WHERE tipo_alerta = 'Mayor que';

SELECT
    id_cartera,
    SUM(cantidad * precio_compra) AS valor_invertido
FROM detalle_cartera
GROUP BY id_cartera;

SELECT
    id_cartera,
    COUNT(*) AS total_activos
FROM detalle_cartera
GROUP BY id_cartera;

SELECT
    usuarios.nombre,
    carteras_virtuales.nombre AS cartera,
    carteras_virtuales.saldo_virtual
FROM carteras_virtuales
INNER JOIN usuarios
ON carteras_virtuales.id_usuario = usuarios.id_usuario;

SELECT *
FROM precios_historicos
WHERE precio > (
    SELECT AVG(precio)
    FROM precios_historicos
);

SELECT *
FROM empresas
WHERE id_empresa IN (
    SELECT id_empresa
    FROM activos
);

SELECT *
FROM usuarios
WHERE id_usuario IN (
    SELECT id_usuario
    FROM favoritos
);

SELECT *
FROM precios_historicos
WHERE precio = (
    SELECT MAX(precio)
    FROM precios_historicos
);

SELECT
    id_activo,
    precio,
    CASE
        WHEN precio >= 1000 THEN 'Precio alto'
        WHEN precio >= 100 THEN 'Precio medio'
        ELSE 'Precio bajo'
    END AS clasificacion
FROM precios_historicos;

SELECT
    id_alerta,
    precio_objetivo,
    CASE
        WHEN estado = 'Activa' THEN 'Alerta pendiente'
        ELSE 'Alerta inactiva'
    END AS descripcion_estado
FROM alertas;

SELECT DISTINCT pais
FROM empresas;

SELECT DISTINCT sector
FROM empresas;

SELECT DISTINCT tipo
FROM activos;

SELECT *
FROM precios_historicos
WHERE precio BETWEEN 100 AND 300;

SELECT *
FROM alertas
WHERE precio_objetivo BETWEEN 100 AND 500;

SELECT *
FROM empresas
WHERE pais IN ('Colombia', 'Japon', 'Estados Unidos');

SELECT *
FROM activos
WHERE simbolo IN ('AAPL', 'MSFT', 'AMZN');

SELECT *
FROM empresas
WHERE sector IS NULL;

SELECT *
FROM noticias
WHERE id_empresa IS NULL;

UPDATE usuarios
SET nombre = 'Juan David Cuervo'
WHERE id_usuario = 1;

UPDATE empresas
SET sector = 'Tecnologia y servicios'
WHERE id_empresa = 2;

UPDATE alertas
SET estado = 'Inactiva'
WHERE id_alerta = 5;

UPDATE alertas
SET precio_objetivo = 250.00
WHERE id_alerta = 1;

DELETE FROM alertas
WHERE id_alerta = 5;

DELETE FROM favoritos
WHERE id_favorito = 7;

SELECT CURDATE() AS fecha_actual;

SELECT NOW() AS fecha_hora_actual;

SELECT
    precio,
    YEAR(fecha) AS anio
FROM precios_historicos;

SELECT
    precio,
    MONTH(fecha) AS mes
FROM precios_historicos;

SELECT *
FROM precios_historicos
WHERE MONTH(fecha) = 10
AND YEAR(fecha) = 2026;

SELECT
    empresas.nombre AS empresa,
    empresas.simbolo,
    empresas.sector,
    empresas.pais,
    activos.nombre AS activo,
    mercados.nombre AS mercado,
    mercados.ciudad
FROM empresas
INNER JOIN activos
ON empresas.id_empresa = activos.id_empresa
INNER JOIN mercados
ON activos.id_mercado = mercados.id_mercado;