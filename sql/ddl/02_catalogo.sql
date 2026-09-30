

-- 1. Tabla CATEGORIA
CREATE TABLE Categoria
(
    id_categoria INT NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL UNIQUE
);
GO

-- 2. Tabla TALLE
CREATE TABLE Talle
(
    id_talle INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NOT NULL
);
GO

-- 3. Tabla PRODUCTO
CREATE TABLE Producto
(
    id_producto INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    imagen VARCHAR(255) NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (precio_unitario >= 0),
    precio_mayorista NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (precio_mayorista >= 0),
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION
);
GO