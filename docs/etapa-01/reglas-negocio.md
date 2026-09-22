# Reglas de Negocio

## Descripción

El sistema corresponde a una plataforma e-commerce destinada a la venta y gestión de indumentaria. Permite administrar productos, variantes, clientes, ventas, compras a proveedores, stock y pagos.

Las siguientes reglas de negocio definen las condiciones que deben cumplirse para el funcionamiento del sistema.

## Reglas de Negocio

### RN01 - Registro de clientes
Cada cliente debe registrarse con nombre, apellido, DNI, correo electrónico, contraseña y teléfono. El DNI y el correo electrónico deben ser únicos dentro del sistema.

### RN02 - Roles de usuario
Cada usuario debe tener un único rol asignado, mientras que un mismo rol puede estar asociado a múltiples usuarios.

### RN03 - Productos y variantes
Cada producto debe pertenecer a una categoría y puede tener una o más variantes. Cada variante se define por un talle y un color determinados y mantiene su propio stock disponible.

### RN04 - Registro de ventas
Cada venta debe estar asociada a un usuario(cliente) y puede incluir una o más variantes de productos. Para cada variante vendida se debe registrar la cantidad y el precio correspondiente al momento de la venta.

### RN05 - Historial de precios de venta
El precio registrado en el detalle de la venta corresponde al precio aplicado al momento de realizar la operación y debe conservarse aunque posteriormente se modifique el precio del producto.

### RN06 - Compras a proveedores
El sistema debe registrar las compras realizadas a los proveedores. Cada compra debe estar asociada a un único proveedor y puede contener múltiples variantes de productos.

### RN07 - Historial de precios de compra
Cada detalle de compra debe registrar la cantidad adquirida y el precio unitario correspondiente a esa operación. El precio registrado debe conservarse aunque posteriormente cambie el precio de compra del producto.

### RN08 - Métodos de pago
Cada pago debe estar asociado a una venta y a un método de pago, registrando el monto, la fecha y, cuando corresponda, una referencia de la operación.

### RN09 - Gestión de stock
El stock de cada variante de producto debe actualizarse de acuerdo con las operaciones de compra y venta realizadas: las compras a proveedores incrementan las unidades disponibles y las ventas disminuyen las unidades disponibles.