# Modelo Relacional

El modelo relacional se obtuvo a partir del modelo entidad-relación, transformando las entidades en tablas y estableciendo sus claves primarias (PK) y claves foráneas (FK).

## USUARIO

- **PK:** id_usuario
- nombre
- apellido
- dni
- email
- contraseña
- telefono
- **FK:** id_rol → ROL(id_rol)
- **FK:** id_direccion → DIRECCION(id_direccion)

## ROL

- **PK:** id_rol
- descripcion

## DIRECCION

- **PK:** id_direccion
- provincia
- calle
- nro
- ciudad
- cod_postal

## PRODUCTO

- **PK:** id_producto
- nombre
- descripcion
- imagen
- precio_unitario
- precio_mayorista
- **FK:** id_categoria → CATEGORIA(id_categoria)

## CATEGORIA

- **PK:** id_categoria
- descripcion

## TALLE

- **PK:** id_talle
- descripcion

## COLOR

- **PK:** id_color
- descripcion

## VARIANTE_PRODUCTO

- **PK:** id_variante_producto
- stock
- **FK:** id_producto → PRODUCTO(id_producto)
- **FK:** id_talle → TALLE(id_talle)
- **FK:** id_color → COLOR(id_color)

## VENTA_CABECERA

- **PK:** id_venta_cabecera
- created_at
- updated_at
- estado
- monto_total
- **FK:** id_usuario → USUARIO(id_usuario)

## VENTA_DETALLE

- **PK:** id_venta_detalle
- cantidad
- precio
- **FK:** id_venta_cabecera → VENTA_CABECERA(id_venta_cabecera)
- **FK:** id_variante_producto → VARIANTE_PRODUCTO(id_variante_producto)

## METODO_PAGO

- **PK:** id_metodo
- descripcion

## PAGO

- **PK:** id_pago
- monto
- fecha
- referencia
- **FK:** id_metodo → METODO_PAGO(id_metodo)
- **FK:** id_venta_cabecera → VENTA_CABECERA(id_venta_cabecera)

## PROVEEDOR

- **PK:** id_proveedor
- nombre
- CUIT
- email
- telefono
- **FK:** id_direccion → DIRECCION(id_direccion)

## COMPRA

- **PK:** id_compra
- fecha_compra
- estado
- **FK:** id_proveedor → PROVEEDOR(id_proveedor)

## DETALLE_COMPRA

- **PK:** id_detalle_compra
- cantidad
- precio_unitario
- **FK:** id_variante_producto → VARIANTE_PRODUCTO(id_variante_producto)
- **FK:** id_compra → COMPRA(id_compra)