-- ========================================================
-- Tablas correspondientes a Iara:
-- COLOR, VARIANTE_PRODUCTO y PROVEEDOR
-- ========================================================

-- 1. Tabla COLOR
CREATE TABLE color
(
    id_color INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,

    CONSTRAINT PK_color PRIMARY KEY (id_color),
    CONSTRAINT UQ_color_nombre UNIQUE (nombre)
);
GO

-- 2. Tabla VARIANTE_PRODUCTO
CREATE TABLE variante_producto
(
    id_variante_producto INT NOT NULL,
    stock INT NOT NULL,
    id_producto INT NOT NULL,
    id_talle INT NOT NULL,
    id_color INT NOT NULL,

    CONSTRAINT PK_variante_producto PRIMARY KEY (id_variante_producto),

    CONSTRAINT FK_VarianteProducto_Producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_VarianteProducto_Talle
        FOREIGN KEY (id_talle)
        REFERENCES talle(id_talle)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_VarianteProducto_Color
        FOREIGN KEY (id_color)
        REFERENCES color(id_color)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT CHK_VarianteProducto_stock
        CHECK (stock >= 0)
);
GO

-- 3. Tabla PROVEEDOR
CREATE TABLE proveedor
(
    id_proveedor INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    CUIT VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    id_direccion INT NOT NULL,

    CONSTRAINT PK_proveedor PRIMARY KEY (id_proveedor),

    CONSTRAINT FK_Proveedor_Direccion
        FOREIGN KEY (id_direccion)
        REFERENCES direccion(id_direccion)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT UQ_Proveedor_CUIT UNIQUE (CUIT),
    CONSTRAINT UQ_Proveedor_email UNIQUE (email)
);
GO