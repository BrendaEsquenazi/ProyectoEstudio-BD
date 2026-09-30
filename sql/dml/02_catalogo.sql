USE EcommerceInd;
GO

-- Tabla CATEGORIA (10 registros)
INSERT INTO Categoria (id_categoria, descripcion) VALUES
(1, 'Remeras y Chombas'),
(2, 'Pantalones y Jeans'),
(3, 'Buzos y Camperas'),
(4, 'Calzado Urbano'),
(5, 'Calzado Deportivo'),
(6, 'Vestidos y Faldas'),
(7, 'Camisas y Blusas'),
(8, 'Ropa Interior y Lencería'),
(9, 'Trajes de Baño'),
(10, 'Accesorios y Gorras');
GO

-- Tabla TALLE (10 registros)
INSERT INTO Talle (id_talle, nombre, descripcion) VALUES
(1, 'XS', 'Talle Extra Small - Indumentaria'),
(2, 'S', 'Talle Small - Indumentaria'),
(3, 'M', 'Talle Medium - Indumentaria'),
(4, 'L', 'Talle Large - Indumentaria'),
(5, 'XL', 'Talle Extra Large - Indumentaria'),
(6, 'XXL', 'Talle Double Extra Large - Indumentaria'),
(7, '38', 'Medida de Calzado / Pantalón 38'),
(8, '40', 'Medida de Calzado / Pantalón 40'),
(9, '42', 'Medida de Calzado / Pantalón 42'),
(10, '44', 'Medida de Calzado / Pantalón 44');
GO

-- Tabla PRODUCTO (10 registros)
INSERT INTO Producto (id_producto, nombre, descripcion, imagen, precio_unitario, precio_mayorista, id_categoria) VALUES
(1, 'Remera Algodón Premium', 'Remera lisa 100% algodón peinado', '/img/remera_algodon.jpg', 18500.00, 14000.00, 1),
(2, 'Jean Slim Fit Denim', 'Pantalón de jean azul elastizado', '/img/jean_slim.jpg', 42000.00, 32000.00, 2),
(3, 'Buzo Canguro Frizado', 'Buzo con capucha y bolsillo frontal', '/img/buzo_canguro.jpg', 38000.00, 29000.00, 3),
(4, 'Zapatillas Canvas Urbanas', 'Zapatillas de lona suela de goma', '/img/zapa_canvas.jpg', 55000.00, 42000.00, 4),
(5, 'Zapatillas Running Pro', 'Calzado deportivo con amortiguación aire', '/img/zapa_running.jpg', 78000.00, 60000.00, 5),
(6, 'Vestido Estampado Floral', 'Vestido corto tela viscosa de verano', '/img/vestido_floral.jpg', 32000.00, 24000.00, 6),
(7, 'Camisa Manga Larga Oxford', 'Camisa formal entallada', '/img/camisa_oxford.jpg', 36000.00, 27000.00, 7),
(8, 'Pack Boxers Algodón x3', 'Ropa interior masculina talle anatómico', '/img/boxers_pack.jpg', 21000.00, 16000.00, 8),
(9, 'Short Malla Deportivo', 'Traje de baño secado rápido con red', '/img/malla_short.jpg', 22000.00, 16500.00, 9),
(10, 'Gorra Gabardina Ajustable', 'Gorra urbana con visera curva', '/img/gorra_urbana.jpg', 12500.00, 9000.00, 10);
GO