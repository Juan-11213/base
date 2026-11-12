CREATE DATABASE IF NOT EXISTS bolsa_mercados
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bolsa_mercados;

-- Permite ejecutar este script varias veces sin errores:
-- borra las tablas (hijas primero) y las vuelve a crear con los datos de ejemplo.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS alertas, noticias, detalle_cartera, carteras_virtuales,
    favoritos, tasas_cambio, precios_historicos, activos, monedas,
    empresas, mercados, usuarios;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE mercados (
    id_mercado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100)
);

CREATE TABLE empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sector VARCHAR(100),
    pais VARCHAR(100),
    simbolo VARCHAR(20) UNIQUE
);

CREATE TABLE monedas (
    id_moneda INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    simbolo VARCHAR(10)
);

CREATE TABLE activos (
    id_activo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    simbolo VARCHAR(20),
    id_empresa INT,
    id_mercado INT,
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),
    FOREIGN KEY (id_mercado) REFERENCES mercados(id_mercado)
);

CREATE TABLE precios_historicos (
    id_precio INT AUTO_INCREMENT PRIMARY KEY,
    id_activo INT NOT NULL,
    precio DECIMAL(15,2) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_activo) REFERENCES activos(id_activo)
);

CREATE TABLE tasas_cambio (
    id_tasa INT AUTO_INCREMENT PRIMARY KEY,
    id_moneda_origen INT NOT NULL,
    id_moneda_destino INT NOT NULL,
    tasa DECIMAL(15,6) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_moneda_origen) REFERENCES monedas(id_moneda),
    FOREIGN KEY (id_moneda_destino) REFERENCES monedas(id_moneda)
);

CREATE TABLE favoritos (
    id_favorito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_activo INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_activo) REFERENCES activos(id_activo)
);

CREATE TABLE carteras_virtuales (
    id_cartera INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    saldo_virtual DECIMAL(15,2) DEFAULT 100000.00,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE detalle_cartera (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_cartera INT NOT NULL,
    id_activo INT NOT NULL,
    cantidad DECIMAL(15,4) NOT NULL,
    precio_compra DECIMAL(15,2) NOT NULL,
    fecha_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cartera) REFERENCES carteras_virtuales(id_cartera),
    FOREIGN KEY (id_activo) REFERENCES activos(id_activo)
);

CREATE TABLE noticias (
    id_noticia INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fuente VARCHAR(100),
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_empresa INT,
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

CREATE TABLE alertas (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_activo INT NOT NULL,
    precio_objetivo DECIMAL(15,2) NOT NULL,
    tipo_alerta VARCHAR(30),
    estado VARCHAR(30) DEFAULT 'Activa',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_activo) REFERENCES activos(id_activo)
);

INSERT INTO usuarios (nombre, correo, contrasena) VALUES
('Juan Cuervo', 'juan@gmail.com', '123456'),
('Maria Lopez', 'maria@gmail.com', '123456'),
('Carlos Perez', 'carlos@gmail.com', '123456'),
('Laura Gomez', 'laura@gmail.com', '123456');

INSERT INTO mercados (nombre, pais, ciudad) VALUES
('NYSE', 'Estados Unidos', 'Nueva York'),
('NASDAQ', 'Estados Unidos', 'Nueva York'),
('Bolsa de Valores de Colombia', 'Colombia', 'Bogota'),
('Bolsa de Tokio', 'Japon', 'Tokio'),
('Bolsa de Londres', 'Reino Unido', 'Londres');

INSERT INTO empresas (nombre, sector, pais, simbolo) VALUES
('Apple', 'Tecnologia', 'Estados Unidos', 'AAPL'),
('Microsoft', 'Tecnologia', 'Estados Unidos', 'MSFT'),
('Amazon', 'Comercio', 'Estados Unidos', 'AMZN'),
('Google', 'Tecnologia', 'Estados Unidos', 'GOOGL'),
('Ecopetrol', 'Energia', 'Colombia', 'ECOPETROL'),
('Toyota', 'Automotriz', 'Japon', 'TM'),
('Samsung', 'Tecnologia', 'Corea del Sur', 'SMSN'),
('Coca Cola', 'Alimentos', 'Estados Unidos', 'KO');

INSERT INTO monedas (nombre, codigo, simbolo) VALUES
('Dolar estadounidense', 'USD', '$'),
('Peso colombiano', 'COP', '$'),
('Euro', 'EUR', '€'),
('Libra esterlina', 'GBP', '£'),
('Yen japones', 'JPY', '¥');

INSERT INTO activos (nombre, tipo, simbolo, id_empresa, id_mercado) VALUES
('Apple Inc.', 'Accion', 'AAPL', 1, 2),
('Microsoft Corporation', 'Accion', 'MSFT', 2, 2),
('Amazon.com Inc.', 'Accion', 'AMZN', 3, 2),
('Alphabet Inc.', 'Accion', 'GOOGL', 4, 2),
('Ecopetrol S.A.', 'Accion', 'ECOPETROL', 5, 3),
('Toyota Motor', 'Accion', 'TM', 6, 1),
('Samsung Electronics', 'Accion', 'SMSN', 7, 4),
('Coca Cola Company', 'Accion', 'KO', 8, 1);

INSERT INTO precios_historicos (id_activo, precio, fecha) VALUES
(1, 225.50, '2026-10-01 10:00:00'),
(1, 230.75, '2026-10-02 10:00:00'),
(2, 410.20, '2026-10-01 10:00:00'),
(2, 415.80, '2026-10-02 10:00:00'),
(3, 195.30, '2026-10-01 10:00:00'),
(3, 198.50, '2026-10-02 10:00:00'),
(4, 175.40, '2026-10-01 10:00:00'),
(4, 180.20, '2026-10-02 10:00:00'),
(5, 1850.00, '2026-10-01 10:00:00'),
(5, 1900.00, '2026-10-02 10:00:00'),
(6, 195.00, '2026-10-01 10:00:00'),
(6, 200.00, '2026-10-02 10:00:00'),
(7, 65.50, '2026-10-01 10:00:00'),
(7, 68.00, '2026-10-02 10:00:00'),
(8, 70.20, '2026-10-01 10:00:00'),
(8, 72.50, '2026-10-02 10:00:00');

INSERT INTO tasas_cambio
(id_moneda_origen, id_moneda_destino, tasa) VALUES
(1, 2, 4000.000000),
(1, 3, 0.920000),
(1, 4, 0.790000),
(1, 5, 150.000000),
(2, 1, 0.000250),
(3, 1, 1.087000),
(4, 1, 1.265000),
(5, 1, 0.006670);

INSERT INTO favoritos (id_usuario, id_activo) VALUES
(1, 1),
(1, 2),
(1, 5),
(2, 3),
(2, 4),
(3, 6),
(4, 7);

INSERT INTO carteras_virtuales
(id_usuario, nombre, saldo_virtual) VALUES
(1, 'Mi cartera principal', 100000.00),
(2, 'Cartera tecnologica', 80000.00),
(3, 'Cartera internacional', 120000.00),
(4, 'Mi primera cartera', 50000.00);

INSERT INTO detalle_cartera
(id_cartera, id_activo, cantidad, precio_compra) VALUES
(1, 1, 10, 225.50),
(1, 2, 5, 410.20),
(2, 3, 8, 195.30),
(2, 4, 6, 175.40),
(3, 5, 20, 1850.00),
(3, 6, 4, 195.00),
(4, 7, 10, 65.50);

INSERT INTO noticias
(titulo, descripcion, fuente, id_empresa) VALUES
('Apple presenta nuevos avances tecnologicos',
 'La empresa anuncia mejoras en sus productos.',
 'Noticias Financieras', 1),

('Microsoft fortalece sus servicios digitales',
 'La compania presenta nuevas herramientas.',
 'Economia Global', 2),

('Amazon amplia sus operaciones internacionales',
 'La empresa busca fortalecer su comercio.',
 'Mercados Internacionales', 3),

('Google anuncia nuevos proyectos de inteligencia artificial',
 'La empresa presenta avances tecnologicos.',
 'Tecnologia Hoy', 4),

('Ecopetrol informa resultados empresariales',
 'La compania presenta sus resultados financieros.',
 'Noticias Colombia', 5),

('Toyota presenta nuevos modelos de vehiculos',
 'La empresa anuncia novedades en el sector automotriz.',
 'Economia Mundial', 6);

INSERT INTO alertas
(id_usuario, id_activo, precio_objetivo, tipo_alerta) VALUES
(1, 1, 240.00, 'Mayor que'),
(1, 2, 400.00, 'Menor que'),
(2, 3, 200.00, 'Mayor que'),
(3, 5, 2000.00, 'Mayor que'),
(4, 7, 70.00, 'Mayor que');
