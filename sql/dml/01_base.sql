USE EcommerceInd;
GO

-- ========================================================
-- Carga de datos iniciales: direccion, rol, usuario
-- ========================================================
-- 1. Inserción en DIRECCION 
INSERT INTO direccion (id_direccion, calle, nro, ciudad, provincia, cod_postal) VALUES
(1, 'Junín', 1050, 'Corrientes', 'Corrientes', 3400),
(2, 'Av. 3 de Abril', 1245, 'Corrientes', 'Corrientes', 3400),
(3, 'Carlos Pellegrini', 780, 'Corrientes', 'Corrientes', 3400),
(4, 'Av. Costanera Gral. San Martín', 850, 'Corrientes', 'Corrientes', 3400),
(5, 'Av. Pedro Ferré', 2130, 'Corrientes', 'Corrientes', 3400),
(6, 'San Martín', 1420, 'Corrientes', 'Corrientes', 3400),
(7, '9 de Julio', 860, 'Corrientes', 'Corrientes', 3400),
(8, 'Av. Independencia', 3650, 'Corrientes', 'Corrientes', 3400),
(9, 'Hipólito Yrigoyen', 1530, 'Corrientes', 'Corrientes', 3400),
(10, 'Av. Armenia', 2890, 'Corrientes', 'Corrientes', 3400);

-- 2. Inserción en ROL 
INSERT INTO rol (id_rol, descripcion) VALUES
(1, 'Administrador'),
(2, 'Cliente'),
(3, 'Vendedor'),
(4, 'Gerente'),
(5, 'Soporte'),
(6, 'Encargado de depósito'),
(7, 'Encargado de compras'),
(8, 'Atención al cliente');

-- 3. Inserción en USUARIO 
INSERT INTO usuario (id_usuario, nombre, apellido, dni, email, contrasena, telefono, id_rol, id_direccion) VALUES
(1, 'Juan', 'Pérez', 35123456, 'juan.perez@example.com', 'hash_admin123', '3794123456', 1, 1),
(2, 'María', 'González', 38234567, 'maria.gonzalez@example.com', 'hash_pass456', '3794234567', 2, 2),
(3, 'Carlos', 'Rodríguez', 32345678, 'carlos.rodriguez@example.com', 'hash_vend789', '3794345678', 3, 3),
(4, 'Laura', 'Fernández', 40456789, 'laura.fernandez@example.com', 'hash_gerente321', '3794456789', 4, 4),
(5, 'Esteban', 'Martínez', 37567890, 'esteban.martinez@example.com', 'hash_pass654', '3794567890', 2, 5),
(6, 'Lucía', 'Gómez', 39678901, 'lucia.gomez@example.com', 'hash_pass789', '3794678901', 2, 6),
(7, 'Martín', 'Romero', 36789012, 'martin.romero@example.com', 'hash_soporte101', '3794789012', 5, 7),
(8, 'Sofía', 'Díaz', 41890123, 'sofia.diaz@example.com', 'hash_pass890', '3794890123', 2, 8),
(9, 'Lucas', 'Benítez', 34901234, 'lucas.benitez@example.com', 'hash_vend321', '3794901234', 3, 9),
(10, 'Florencia', 'Acosta', 42012345, 'florencia.acosta@example.com', 'hash_pass112', '3794012345', 2, 10);
