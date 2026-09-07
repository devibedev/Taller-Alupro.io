-- backend/schema.sql
CREATE TABLE talleres (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    taller_id INTEGER REFERENCES talleres(id),
    nombre VARCHAR(100),
    direccion TEXT,
    proveedor_conalum VARCHAR(100) DEFAULT 'Conalum Tlaquepaque',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE series (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(30), -- corrediza, fija, europea
    espesor_perfil_mm DECIMAL(5,2) DEFAULT 76.2,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE perfiles (
    id SERIAL PRIMARY KEY,
    serie_id INTEGER REFERENCES series(id),
    clave_conalum VARCHAR(20) NOT NULL,
    nombre VARCHAR(50),
    costo_ml DECIMAL(10,2),
    peso_kg_ml DECIMAL(8,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE formulas_descuento (
    id SERIAL PRIMARY KEY,
    serie_id INTEGER REFERENCES series(id),
    perfil_id INTEGER REFERENCES perfiles(id),
    formula VARCHAR(100) NOT NULL, -- W, H-20, (W+25)/2-45
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accesorios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    clave_conalum VARCHAR(20),
    costo_unitario DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accesorios_por_serie (
    id SERIAL PRIMARY KEY,
    serie_id INTEGER REFERENCES series(id),
    accesorio_id INTEGER REFERENCES accesorios(id),
    cantidad_por_ventana INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cotizaciones (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id),
    taller_id INTEGER REFERENCES talleres(id),
    sucursal_id INTEGER REFERENCES sucursales(id),
    ancho_mm INTEGER NOT NULL,
    alto_mm INTEGER NOT NULL,
    serie_id INTEGER REFERENCES series(id),
    cantidad INTEGER DEFAULT 1,
    precio_total DECIMAL(12,2),
    margen DECIMAL(4,3) DEFAULT 0.35,
    estado VARCHAR(20) DEFAULT 'borrador',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cotizacion_detalle (
    id SERIAL PRIMARY KEY,
    cotizacion_id INTEGER REFERENCES cotizaciones(id),
    perfil_id INTEGER REFERENCES perfiles(id),
    medida_mm INTEGER,
    cantidad INTEGER,
    costo_parcial DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE despiece_calculado (
    id SERIAL PRIMARY KEY,
    cotizacion_id INTEGER REFERENCES cotizaciones(id),
    perfil_id INTEGER REFERENCES perfiles(id),
    clave_conalum VARCHAR(20),
    medida_mm INTEGER,
    cantidad INTEGER,
    ml_totales DECIMAL(10,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE despiece_vidrio (
    id SERIAL PRIMARY KEY,
    cotizacion_id INTEGER REFERENCES cotizaciones(id),
    ancho_mm INTEGER,
    alto_mm INTEGER,
    cantidad INTEGER DEFAULT 2,
    m2 DECIMAL(10,3),
    costo_m2 DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    sucursal_id INTEGER REFERENCES sucursales(id),
    perfil_id INTEGER REFERENCES perfiles(id),
    stock_ml DECIMAL(10,2) DEFAULT 0,
    stock_tramos INTEGER DEFAULT 0,
    ubicacion VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lista_compras (
    id SERIAL PRIMARY KEY,
    cotizacion_id INTEGER REFERENCES cotizaciones(id),
    sucursal_id INTEGER REFERENCES sucursales(id),
    perfil_id INTEGER REFERENCES perfiles(id),
    necesario_ml DECIMAL(10,2),
    stock_ml DECIMAL(10,2),
    faltante_ml DECIMAL(10,2),
    tramos_a_comprar INTEGER,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ordenes_trabajo (
    id SERIAL PRIMARY KEY,
    cotizacion_id INTEGER REFERENCES cotizaciones(id),
    estado VARCHAR(20) DEFAULT 'pendiente',
    fecha_inicio DATE,
    fecha_fin DATE,
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE instalaciones (
    id SERIAL PRIMARY KEY,
    orden_trabajo_id INTEGER REFERENCES ordenes_trabajo(id),
    direccion TEXT,
    fecha_programada DATE,
    tecnico_asignado VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'programada',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
