-- ========================================================
-- Carga de datos iniciales: direccion, rol, usuario
-- ========================================================

-- 1. Inserción en DIRECCION 
INSERT INTO direccion (id_direccion, calle, nro, ciudad, provincia, cod_postal) VALUES
(1, 'Junín', 1050, 'Corrientes', 'Corrientes', 3400),
(2, 'Av. 3 de Abril', 1245, 'Corrientes', 'Corrientes', 3400),
(3, 'Carlos Pellegrini', 780, 'Corrientes', 'Corrientes', 3400),
(4, 'Av. Costanera Gral. San Martín', 850, 'Corrientes', 'Corrientes', 3400),
(5, 'Av. Pedro Ferré', 2130, 'Corrientes', 'Corrientes', 3400);

-- 2. Inserción en ROL 
INSERT INTO rol (id_rol, descripcion) VALUES
(1, 'Administrador'),
(2, 'Cliente'),
(3, 'Vendedor'),
(4, 'Gerente'),
(5, 'Soporte');

-- 3. Inserción en USUARIO 
INSERT INTO usuario (id_usuario, nombre, apellido, dni, email, contrasena, telefono, id_rol, id_direccion) VALUES
(1, 'Juan', 'Pérez', 35123456, 'juan.perez@example.com', 'hash_admin123', '3794123456', 1, 1),
(2, 'María', 'González', 38234567, 'maria.gonzalez@example.com', 'hash_pass456', '3794234567', 2, 2),
(3, 'Carlos', 'Rodríguez', 32345678, 'carlos.rodriguez@example.com', 'hash_vend789', '3794345678', 3, 3),
(4, 'Laura', 'Fernández', 40456789, 'laura.fernandez@example.com', 'hash_gerente321', '3794456789', 4, 4),
(5, 'Esteban', 'Martínez', 37567890, 'esteban.martinez@example.com', 'hash_pass654', '3794567890', 2, 5);
