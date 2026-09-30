CREATE TABLE metodo_pago (
    id_metodo INT NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_metodo_pago PRIMARY KEY (id_metodo),
    CONSTRAINT UQ_metodo_pago_descripcion UNIQUE (descripcion)
);
GO

CREATE TABLE Venta_Cabecera (
    id_VentaCabecera INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    monto_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    estado VARCHAR(30) NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT PK_Venta_Cabecera PRIMARY KEY (id_VentaCabecera),
    CONSTRAINT FK_VentaCabecera_Usuario FOREIGN KEY (id_usuario) 
        REFERENCES Usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CHK_VentaCabecera_monto CHECK (monto_total >= 0),
    CONSTRAINT CHK_VentaCabecera_estado CHECK (estado IN ('Pendiente', 'Pagada', 'Cancelada', 'Enviada', 'Completada'))
);
GO

CREATE TABLE Venta_Detalle (
    id_VentaDetalle INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_VentaCabecera INT NOT NULL,
    id_variante_producto INT NOT NULL,
    CONSTRAINT PK_Venta_Detalle PRIMARY KEY (id_VentaDetalle),
    CONSTRAINT FK_VentaDetalle_VentaCabecera FOREIGN KEY (id_VentaCabecera) 
        REFERENCES Venta_Cabecera(id_VentaCabecera)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT FK_VentaDetalle_VarianteProducto FOREIGN KEY (id_variante_producto) 
        REFERENCES Variante_Producto(id_variante_producto)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CHK_VentaDetalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT CHK_VentaDetalle_precio CHECK (precio >= 0)
);
GO

CREATE TABLE Pago (
    id_pago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    referencia VARCHAR(150) NOT NULL,
    id_metodo INT NOT NULL,
    id_VentaCabecera INT NOT NULL,
    CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
    CONSTRAINT FK_Pago_MetodoPago FOREIGN KEY (id_metodo) 
        REFERENCES metodo_pago(id_metodo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT FK_Pago_VentaCabecera FOREIGN KEY (id_VentaCabecera) 
        REFERENCES Venta_Cabecera(id_VentaCabecera)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CHK_Pago_monto CHECK (monto > 0)
);
GO