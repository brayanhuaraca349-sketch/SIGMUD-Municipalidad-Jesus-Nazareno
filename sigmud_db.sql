DROP DATABASE IF EXISTS sigmud_db;
CREATE DATABASE sigmud_db
    CHARACTER SET  utf8mb4
    COLLATE        utf8mb4_unicode_ci;

USE sigmud_db;

-- ----------------------------------------------------------------
-- TABLA: usuarios
-- ----------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario        INT          PRIMARY KEY AUTO_INCREMENT,
    nombre            VARCHAR(150) NOT NULL,
    correo            VARCHAR(100) NOT NULL UNIQUE,
    contrasena        VARCHAR(64)  NOT NULL COMMENT 'SHA-256 hex',
    rol               ENUM('Administrador','MesaDePartes','JefeMercado','Almacenero','Reclamos') NOT NULL,
    activo            TINYINT(1)   NOT NULL DEFAULT 1,
    intentos_fallidos INT          NOT NULL DEFAULT 0,
    fecha_creacion    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: ciudadanos
-- ----------------------------------------------------------------
CREATE TABLE ciudadanos (
    id_ciudadano  INT          PRIMARY KEY AUTO_INCREMENT,
    dni           VARCHAR(8)   NOT NULL UNIQUE,
    nombre        VARCHAR(80)  NOT NULL,
    apellidos     VARCHAR(100) NOT NULL,
    direccion     VARCHAR(250),
    telefono      VARCHAR(9),
    correo        VARCHAR(100),
    fecha_registro DATE         NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: tramites
-- ----------------------------------------------------------------
CREATE TABLE tramites (
    id_tramite      INT          PRIMARY KEY AUTO_INCREMENT,
    num_expediente  VARCHAR(20)  NOT NULL UNIQUE,
    id_ciudadano    INT          NOT NULL,
    tipo_tramite    VARCHAR(100) NOT NULL,
    descripcion     TEXT,
    fecha_ingreso   DATE         NOT NULL DEFAULT (CURRENT_DATE),
    fecha_respuesta DATE,
    estado          ENUM('Recibido','En proceso','Resuelto','Archivado','Vencido') NOT NULL DEFAULT 'Recibido',
    id_usuario      INT          NOT NULL,
    CONSTRAINT fk_tram_ciudadano FOREIGN KEY (id_ciudadano) REFERENCES ciudadanos(id_ciudadano),
    CONSTRAINT fk_tram_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: puestos
-- ----------------------------------------------------------------
CREATE TABLE puestos (
    id_puesto     INT            PRIMARY KEY AUTO_INCREMENT,
    num_puesto    VARCHAR(10)    NOT NULL UNIQUE,
    titular       VARCHAR(200),
    dni_titular   VARCHAR(8),
    seccion       VARCHAR(60),
    monto_mensual DECIMAL(8,2)   NOT NULL DEFAULT 0.00,
    estado        ENUM('Activo','Suspendido','Libre') NOT NULL DEFAULT 'Libre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: pagos_puesto
-- ----------------------------------------------------------------
CREATE TABLE pagos_puesto (
    id_pago    INT          PRIMARY KEY AUTO_INCREMENT,
    id_puesto  INT          NOT NULL,
    periodo    VARCHAR(7)   NOT NULL COMMENT 'YYYY-MM',
    monto      DECIMAL(8,2) NOT NULL,
    fecha_pago DATE,
    estado     ENUM('Pagado','Pendiente','Vencido') NOT NULL DEFAULT 'Pagado',
    id_usuario INT          NOT NULL,
    UNIQUE KEY uq_puesto_periodo (id_puesto, periodo),
    CONSTRAINT fk_pago_puesto  FOREIGN KEY (id_puesto)  REFERENCES puestos(id_puesto),
    CONSTRAINT fk_pago_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: productos
-- ----------------------------------------------------------------
CREATE TABLE productos (
    id_producto  INT          PRIMARY KEY AUTO_INCREMENT,
    nombre       VARCHAR(150) NOT NULL,
    unidad       VARCHAR(30),
    stock_actual INT          NOT NULL DEFAULT 0,
    stock_minimo INT          NOT NULL DEFAULT 0,
    categoria    VARCHAR(60)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: movimientos_almacen
-- ----------------------------------------------------------------
CREATE TABLE movimientos_almacen (
    id_movimiento    INT      PRIMARY KEY AUTO_INCREMENT,
    id_producto      INT      NOT NULL,
    tipo             ENUM('E','S') NOT NULL COMMENT 'E=Entrada S=Salida',
    cantidad         INT      NOT NULL,
    fecha_movimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario       INT      NOT NULL,
    observacion      VARCHAR(300),
    CONSTRAINT fk_mov_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_mov_usuario  FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- TABLA: reclamos  (id_responsable nullable)
-- ----------------------------------------------------------------
CREATE TABLE reclamos (
    id_reclamo     INT      PRIMARY KEY AUTO_INCREMENT,
    id_ciudadano   INT      NOT NULL,
    tipo           VARCHAR(100) NOT NULL,
    descripcion    TEXT,
    fecha_ingreso  DATE     NOT NULL DEFAULT (CURRENT_DATE),
    estado         ENUM('Recibido','En proceso','Resuelto','Cerrado') NOT NULL DEFAULT 'Recibido',
    id_responsable INT      NULL,
    CONSTRAINT fk_recl_ciudadano   FOREIGN KEY (id_ciudadano)   REFERENCES ciudadanos(id_ciudadano),
    CONSTRAINT fk_recl_responsable FOREIGN KEY (id_responsable) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------
-- ÍNDICES de apoyo
-- ----------------------------------------------------------------
CREATE INDEX idx_tramites_estado ON tramites(estado);
CREATE INDEX idx_tramites_fecha  ON tramites(fecha_ingreso);
CREATE INDEX idx_reclamos_estado ON reclamos(estado);
CREATE INDEX idx_mov_fecha       ON movimientos_almacen(fecha_movimiento);
CREATE INDEX idx_pagos_periodo   ON pagos_puesto(periodo);

-- ================================================================
-- DATOS INICIALES
-- Contraseñas: SHA2(texto, 256) en MySQL = SHA-256 en Java
-- ================================================================

INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES
('Administrador Sistema', 'admin@mdjn.gob.pe',    SHA2('admin2026',    256), 'Administrador'),
('María Quispe Torres',   'mesa@mdjn.gob.pe',     SHA2('mesa2026',     256), 'MesaDePartes'),
('Carlos Flores Huamán',  'mercado@mdjn.gob.pe',  SHA2('mercado2026',  256), 'JefeMercado'),
('Luis Sulca Ccente',     'almacen@mdjn.gob.pe',  SHA2('almacen2026',  256), 'Almacenero'),
('Rosa Ayala Mejía',      'reclamos@mdjn.gob.pe', SHA2('reclamos2026', 256), 'Reclamos');

INSERT INTO ciudadanos (dni, nombre, apellidos, direccion, telefono, correo) VALUES
('12345678','Juan',   'Pérez López',   'Jr. Los Incas 123',   '987654321','jperez@gmail.com'),
('87654321','Ana',    'García Medina', 'Av. Ayacucho 456',    '912345678','agarcia@gmail.com'),
('11223344','Pedro',  'Sulca Quispe',  'Psj. Las Flores 789', '945678901', NULL),
('44332211','Elena',  'Huamán Ccente', 'Jr. Bolívar 100',     '934567890','ehuaman@gmail.com'),
('55667788','Carlos', 'Medina Torres', 'Av. Libertadores 5',  '923456789', NULL);

INSERT INTO puestos (num_puesto, titular, dni_titular, seccion, monto_mensual, estado) VALUES
('A-01','Juan Pérez López',   '12345678','Frutas',    50.00,'Activo'),
('A-02','Ana García Medina',  '87654321','Verduras',  50.00,'Activo'),
('B-01', NULL, NULL,                     'Carnes',     0.00,'Libre'),
('B-02','Pedro Sulca Quispe', '11223344','Abarrotes', 45.00,'Suspendido'),
('C-01','Elena Huamán',       '44332211','Ropa',      40.00,'Activo');

INSERT INTO pagos_puesto (id_puesto, periodo, monto, fecha_pago, estado, id_usuario) VALUES
(1,'2026-10',50.00,'2026-10-05','Pagado', 3),
(1,'2026-11',50.00,'2026-11-03','Pagado', 3),
(2,'2026-10',50.00,'2026-10-04','Pagado', 3),
(5,'2026-10',40.00,'2026-10-06','Pagado', 3),
(2,'2026-11',50.00, NULL,       'Vencido',3);

INSERT INTO productos (nombre, unidad, stock_actual, stock_minimo, categoria) VALUES
('Escobas',          'unid', 20, 5,  'Limpieza'),
('Bolsas de basura', 'pack', 50,10,  'Limpieza'),
('Cloro (galón)',    'gal',  10, 3,  'Limpieza'),
('Aceite de motor',  'lt',    5, 2,  'Combustible'),
('Cemento',          'sacos', 2, 5,  'Materiales'),
('Pintura blanca',   'gal',   8, 3,  'Materiales'),
('Guantes trabajo',  'par',  15, 5,  'Herramientas');

INSERT INTO tramites (num_expediente, id_ciudadano, tipo_tramite, descripcion, fecha_ingreso, estado, id_usuario) VALUES
('LICF-2026-001',1,'Licencia de Funcionamiento','Bodega Los Incas',       '2026-10-01','Resuelto',   2),
('CONS-2026-001',2,'Constancia de Residencia',  'Constancia para banco',  '2026-10-15','En proceso', 2),
('LICO-2026-001',3,'Licencia de Obra',           'Ampliación de vivienda','2026-11-01','Recibido',   2),
('CONS-2026-002',4,'Constancia de Residencia',  'Para matrícula escolar', '2026-11-10','Recibido',   2);

INSERT INTO reclamos (id_ciudadano, tipo, descripcion, fecha_ingreso, estado, id_responsable) VALUES
(1,'Alumbrado público',       'Poste sin luz en Jr. Los Incas cuadra 3','2026-11-01','En proceso',5),
(2,'Acumulación de basura',   'Basura acumulada frente al mercado',      '2026-11-05','Recibido',  5),
(3,'Vía pública en mal estado','Bache profundo en Av. Ayacucho km 2',   '2026-11-10','Recibido',  5);

-- ================================================================
-- VERIFICACIÓN (opcional - descomentar para comprobar)
-- ================================================================
-- SELECT 'usuarios' AS tabla, COUNT(*) AS total FROM usuarios
-- UNION ALL SELECT 'ciudadanos', COUNT(*) FROM ciudadanos
-- UNION ALL SELECT 'tramites',   COUNT(*) FROM tramites
-- UNION ALL SELECT 'puestos',    COUNT(*) FROM puestos
-- UNION ALL SELECT 'pagos_puesto',COUNT(*) FROM pagos_puesto
-- UNION ALL SELECT 'productos',  COUNT(*) FROM productos
-- UNION ALL SELECT 'reclamos',   COUNT(*) FROM reclamos;
