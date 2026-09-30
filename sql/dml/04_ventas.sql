USE EcommerceInd;
GO

INSERT INTO metodo_pago (id_metodo, descripcion) VALUES 
(1, 'Tarjeta de Crédito Visa'),
(2, 'Tarjeta de Débito Mastercard'),
(3, 'Transferencia Bancaria'),
(4, 'Mercado Pago'),
(5, 'Efectivo'),
(6, 'Billetera Virtual BNA+'),
(7, 'Modo'),
(8, 'Criptomoneda USDT');
GO

INSERT INTO Venta_Cabecera (id_VentaCabecera, created_at, updated_at, monto_total, estado, id_usuario) VALUES 
(1, '2026-09-01 10:30:00', '2026-09-01 10:35:00', 45000.00, 'Pagada', 1),
(2, '2026-09-02 11:15:00', '2026-09-02 11:15:00', 12500.50, 'Pendiente', 2),
(3, '2026-09-03 15:40:00', '2026-09-03 16:00:00', 89900.00, 'Completada', 3),
(4, '2026-09-05 09:20:00', '2026-09-05 09:50:00', 23400.00, 'Pagada', 4),
(5, '2026-09-08 18:05:00', '2026-09-08 18:30:00', 15000.00, 'Cancelada', 5),
(6, '2026-09-10 14:10:00', '2026-09-10 14:15:00', 67800.00, 'Enviada', 1),
(7, '2026-09-12 16:45:00', '2026-09-12 17:00:00', 31200.00, 'Pagada', 2),
(8, '2026-09-15 12:00:00', '2026-09-15 12:00:00', 5400.00,  'Pendiente', 3),
(9, '2026-09-18 20:10:00', '2026-09-18 20:25:00', 112000.00,'Completada', 4),
(10,'2026-09-20 17:30:00', '2026-09-20 18:00:00', 41000.00, 'Pagada', 5);
GO

INSERT INTO Venta_Detalle (id_VentaDetalle, cantidad, precio, id_VentaCabecera, id_variante_producto) VALUES 
(1,  2, 22500.00, 1, 1),
(2,  1, 12500.50, 2, 2),
(3,  1, 89900.00, 3, 3),
(4,  2, 11700.00, 4, 1),
(5,  1, 15000.00, 5, 4),
(6,  3, 22600.00, 6, 2),
(7,  2, 15600.00, 7, 3),
(8,  1, 5400.00,  8, 5),
(9,  4, 28000.00, 9, 1),
(10, 2, 20500.00, 10, 2);
GO

INSERT INTO Pago (id_pago, monto, fecha, referencia, id_metodo, id_VentaCabecera) VALUES 
(1, 45000.00, '2026-09-01 10:35:00', 'OP-VISA-884920', 1, 1),
(2, 89900.00, '2026-09-03 16:00:00', 'MP-TRF-449102', 4, 3),
(3, 23400.00, '2026-09-05 09:50:00', 'TRF-BANCO-77182', 3, 4),
(4, 67800.00, '2026-09-10 14:15:00', 'OP-MC-110293', 2, 6),
(5, 31200.00, '2026-09-12 17:00:00', 'MP-QR-990182', 4, 7),
(6, 112000.00,'2026-09-18 20:25:00', 'TRF-BANCO-33019', 3, 9),
(7, 41000.00, '2026-09-20 18:00:00', 'EFECTIVO-REC-01', 5, 10),
(8, 20000.00, '2026-09-21 11:00:00', 'MODO-TX-440182', 7, 1);
GO