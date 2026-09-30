

-- 1. Tabla CATEGORIA
CREATE TABLE Categoria
(
    id_categoria INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT PK_id_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_Categoria_descripcion UNIQUE (descripcion)
);
GO

-- 2. Tabla TALLE
CREATE TABLE Talle
(
    id_talle INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT PK_id_talle PRIMARY KEY (id_talle),
    CONSTRAINT UQ_Talle_nombre UNIQUE (nombre)
);
GO

-- 3. Tabla PRODUCTO
CREATE TABLE Producto
(
    id_producto INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    imagen VARCHAR(255) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    precio_mayorista DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_categoria INT NOT NULL,
    CONSTRAINT PK_id_producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria) 
        REFERENCES Categoria(id_categoria)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
    CONSTRAINT CHK_Producto_precio_unitario CHECK (precio_unitario >= 0),
    CONSTRAINT CHK_Producto_precio_mayorista CHECK (precio_mayorista >= 0)
);
GO