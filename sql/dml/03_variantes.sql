USE EcommerceInd;
GO

-- Carga de datos iniciales:
-- COLOR, VARIANTE_PRODUCTO y PROVEEDOR

-- 1. Inserción en COLOR
INSERT INTO color (id_color, nombre, descripcion) VALUES
(1, 'Negro', 'Color negro'),
(2, 'Blanco', 'Color blanco'),
(3, 'Rojo', 'Color rojo'),
(4, 'Azul', 'Color azul'),
(5, 'Verde', 'Color verde'),
(6, 'Rosa', 'Color rosa'),
(7, 'Beige', 'Color beige'),
(8, 'Gris', 'Color gris');
GO


-- 2. Inserción en VARIANTE_PRODUCTO
INSERT INTO variante_producto
    (id_variante_producto, stock, id_producto, id_talle, id_color)
VALUES
(1, 25, 1, 3, 1),
(2, 18, 2, 4, 4),
(3, 20, 3, 3, 2),
(4, 12, 4, 8, 1),
(5, 15, 5, 9, 3),
(6, 10, 6, 4, 6),
(7, 22, 7, 3, 7),
(8, 30, 9, 5, 5),
(9, 16, 8, 2, 8),
(10, 14, 10, 3, 2);
GO


-- 3. Inserción en PROVEEDOR
INSERT INTO proveedor
    (id_proveedor, nombre, CUIT, email, telefono, id_direccion)
VALUES
(1, 'Indumentaria Norte', '30-71234567-8', 'contacto@indumentarianorte.com', '3794123001', 1),
(2, 'Moda Urbana', '30-72345678-9', 'ventas@modaurbana.com', '3794123002', 2),
(3, 'Textil Corrientes', '30-73456789-0', 'info@textilcorrientes.com', '3794123003', 3),
(4, 'Distribuidora Elegance', '30-74567890-1', 'contacto@elegance.com', '3794123004', 4),
(5, 'Mayorista del Litoral', '30-75678901-2', 'ventas@mayoristalitoral.com', '3794123005', 5),
(6, 'Fashion Center', '30-76789012-3', 'info@fashioncenter.com', '3794123006', 6),
(7, 'Textiles del Paraná', '30-77890123-4', 'contacto@textilesparana.com', '3794123007', 7),
(8, 'Moda Actual', '30-78901234-5', 'ventas@modaactual.com', '3794123008', 8);
GO