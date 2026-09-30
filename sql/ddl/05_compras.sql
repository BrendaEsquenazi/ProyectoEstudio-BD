CREATE TABLE Compra
(
  id_compra INT NOT NULL,
  fecha_compra DATETIME NOT NULL,
  estado VARCHAR(255) NOT NULL,
  id_proveedor INT NOT NULL,
  PRIMARY KEY (id_compra),
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Detalle_Compra
(
  id_DetalleCompra INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario NUMERIC(10,2) NOT NULL,
  id_variante_producto INT NOT NULL,
  id_compra INT NOT NULL,
  PRIMARY KEY (id_DetalleCompra),
  FOREIGN KEY (id_variante_producto) REFERENCES Variante_Producto(id_variante_producto),
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra)
);
