CREATE TABLE Compra
(
  id_compra INT NOT NULL,
  fecha_compra DATETIME NOT NULL DEFAULT GETDATE(),
  estado VARCHAR(255) NOT NULL,
  id_proveedor INT NOT NULL,
  CONSTRAINT PK_id_compra PRIMARY KEY (id_compra),
  CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (id_proveedor) 
      REFERENCES Proveedor(id_proveedor)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,
  CONSTRAINT CHK_Compra_estado CHECK (estado IN ('Pendiente', 'Completada', 'Cancelada'))
);
GO

CREATE TABLE Detalle_Compra
(
  id_DetalleCompra INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  id_variante_producto INT NOT NULL,
  id_compra INT NOT NULL,
  CONSTRAINT PK_id_DetalleCompra PRIMARY KEY (id_DetalleCompra),
  CONSTRAINT FK_DetalleCompra_VarianteProducto FOREIGN KEY (id_variante_producto) 
      REFERENCES Variante_Producto(id_variante_producto)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,
  CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (id_compra) 
      REFERENCES Compra(id_compra)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  CONSTRAINT CHK_DetalleCompra_cantidad CHECK (cantidad > 0),
  CONSTRAINT CHK_DetalleCompra_precio CHECK (precio_unitario >= 0)
);
GO
