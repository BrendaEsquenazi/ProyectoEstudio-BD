CREATE TABLE direccion
(
  provincia VARCHAR(255) NOT NULL,
  id_direccion INT NOT NULL,
  calle VARCHAR(255) NOT NULL,
  nro INT NOT NULL,
  ciudad VARCHAR(255) NOT NULL,
  cod_postal INT NOT NULL,
  CONSTRAINT PK_id_direccion PRIMARY KEY (id_direccion)
);
GO

CREATE TABLE rol
(
  descripcion VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  CONSTRAINT PK_id_rol PRIMARY KEY (id_rol)
);
GO

CREATE TABLE usuario
(
  id_usuario INT NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  dni INT NOT NULL,
  email VARCHAR(255) NOT NULL,
  contrasena VARCHAR(255) NOT NULL,
  telefono VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  id_direccion INT NOT NULL,
  CONSTRAINT PK_id_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT FK_usuario_rol FOREIGN KEY (id_rol) 
      REFERENCES rol(id_rol)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,
  CONSTRAINT FK_usuario_direccion FOREIGN KEY (id_direccion) 
      REFERENCES direccion(id_direccion)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,
  CONSTRAINT UQ_usuario_dni UNIQUE (dni),
  CONSTRAINT UQ_usuario_email UNIQUE (email)
);
GO