USE EcommerceInd;
GO

-- ==========================================
-- REGISTROS PARA LA TABLA: Compra
-- ==========================================
INSERT INTO Compra (id_compra, fecha_compra, estado, id_proveedor) VALUES 
(1, '2023-10-01 08:30:00', 'Completada', 1),
(2, '2023-10-02 10:15:00', 'Pendiente', 2),
(3, '2023-10-03 14:45:00', 'Completada', 3),
(4, '2023-10-04 09:20:00', 'Cancelada', 1),
(5, '2023-10-05 16:10:00', 'Completada', 4),
(6, '2023-10-06 11:05:00', 'Pendiente', 5),
(7, '2023-10-07 13:30:00', 'Completada', 2),
(8, '2023-10-08 15:50:00', 'Completada', 3),
(9, '2023-10-09 08:00:00', 'Pendiente', 4),
(10, '2023-10-10 17:25:00', 'Completada', 1);

-- ==========================================
-- REGISTROS PARA LA TABLA: Detalle_Compra
-- ==========================================

INSERT INTO Detalle_Compra (id_DetalleCompra, cantidad, precio_unitario, id_variante_producto, id_compra) VALUES 
(1, 50, 1250.50, 1, 1),
(2, 100, 850.00, 3, 2),
(3, 25, 3400.75, 2, 3),
(4, 200, 450.25, 5, 4),
(5, 10, 5500.00, 8, 5),
(6, 75, 1100.00, 4, 6),
(7, 150, 920.50, 10, 7),
(8, 20, 3150.00, 7, 8),
(9, 60, 1800.25, 6, 9),
(10, 40, 2100.00, 9, 10);