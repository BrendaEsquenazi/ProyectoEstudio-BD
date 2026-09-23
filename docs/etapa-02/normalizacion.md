


1. Primera Forma Normal (1FN): establece que cada columna debe contener valores atomicos (indivisibles), no deben existir grupos de datos repetidos o listas dentro de un mismo campo, y cada tabla debe contar con una clave primaria (Primary Key) bien definida

  Justificacion en el modelo:
  -Atomicidad de los Atributos:Ningun atributo contiene listas o valores compuestos. Atributos como nombre, apellido, email, created_at o monto almacenan un solo valor escalar por registro. 

  -Eliminacion de Grupos Repetitivos en Ventas y Compras:En lugar de incluir columnas repetidas en la tabla de cabecera (por ejemplo, producto_1, cantidad_1, producto_2, cantidad_2), las linneas de detalle se descompusieron en entidades independientes: Venta_Detalle y Detalle_Compra.  

  - Eliminacion de Grupos Repetitivos en Productos:Un producto no almacena listas de talles o colores dentro de una misma fila (ej. "S, M, L" o "Rojo, Azul"). Cada variante fisica se representa mediante un registro unico en la tabla Variante_Producto.  

  - Definicion de Claves Primarias:Todas las tablas del esquema poseen una clave primaria explicita (PRIMARY KEY) que identifica de manera univoca a cada registro (ej. id_usuario, id_producto, id_VentaCabecera).   
  
  
  2. Segunda Forma Normal (2FN): requiere que el esquema este en 1FN y  que ningun atributo debe depender solo de una parte de la clave primaria en tablas donde esta sea compuesta o asociativa. 

   Justificacion en el modelo:
   -Entidades con Clave Primaria Simple:Tablas como Usuario, Producto, Proveedor, Venta_Cabecera, Compra, Rol, Categoria, Talle, Color y metodo_pago utilizan claves primarias simples de una sola columna (id_usuario, id_producto, etc.). Cumplen 2FN al no poseer claves compuestas que permitan dependencias parciales.  

   - Dependencia Completa en Tablas Asociativas / Intermedias:
    -Variante_Producto: El atributo stock depende de la variante especifica (id_variante_producto), que sintetiza la combinacion unica entre un producto, un talle y un color. No depende parcialmente de solo el producto o solo el talle.  
    - Venta_Detalle: Los campos cantidad y precio dependen funcionalmente del registro unico de la linea de detalle (id_VentaDetalle), asociada a su respectiva cabecera de venta (id_VentaCabecera) y variante (id_variante_producto).   
    - Detalle_Compra: La cantidad y el precio_unitario dependen de la linea especifica de la compra (id_DetalleCompra), no de la compra de forma global ni unicamente de la variante. 
    
  3. Tercera Forma Normal (3FN): exige que el esquema este en 2FN y que ningun atributo que no sea parte de la clave primaria debe depender de otro atributo que tampoco sea clave 
  
  Justificacion en el modelo:
  -Abstraccion de Direcciones (Direccion_):En lugar de incluir campos como calle, nro, ciudad, provincia y cod_postal directamente dentro de Usuario o Proveedor, estos se abstraen en la tabla Direccion. Tanto Usuario como Proveedor hacen referencia a id_direccion como clave foranea. Esto evita que los datos del domicilio dependan transitivamente del ID del usuario o del proveedor. 

 -Normalizacion de Roles y Categorias:La descripcion del rol de un usuario no reside en     la tabla Usuario (lo que generaria una dependencia transitiva id_usuario->id_rol->descripcion), sino en la tabla Rol.   
 De forma analoga, la descripcion de una categoria se desacopla de la tabla Producto a la tabla Categoria mediante id_categoria.  

 - Independencia de Talle y Color:Las descripciones de talles y colores no se almacenan en Producto ni en Venta_Detalle, evitando la redundancia y dependencias transitivas. Residen en sus tablas correspondientes (Talle y Color), vinculadas a traves de Variante_Producto. 

  -Preservacion del Historial de Precios (No Transitividad):El campo precio en Venta_Detalle y precio_unitario en Detalle_Compra no constituyen dependencias transitivas con respecto a Producto.precio_unitario. Corresponden a datos historicos inmutables del momento en que se efectuo la transaccion comercial, asegurando la integridad del registro contable frente a futuros cambios de precios en la tabla catalogo

