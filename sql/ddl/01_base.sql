CREATE TABLE direccion
(
  provincia VARCHAR(255) NOT NULL,
  id_direccion INT NOT NULL,
  calle VARCHAR(255) NOT NULL,
  nro INT NOT NULL,
  ciudad VARCHAR(255) NOT NULL,
  cod_postal INT NOT NULL,
  PRIMARY KEY (id_direccion)
);

CREATE TABLE rol
(
  descripcion VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  PRIMARY KEY (id_rol)
);

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
  PRIMARY KEY (id_usuario),
  FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
  FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion),
  UNIQUE (dni),
  UNIQUE (email)
);