# Etapa V – Procedimientos y funciones almacenadas

## 1. Objetivo

Implementar procedimientos y funciones almacenadas en la base de datos `EcommerceInd`, con el propósito de centralizar operaciones frecuentes, reutilizar lógica SQL y facilitar la consulta y manipulación de los datos.

Además, se realizaron pruebas para verificar el funcionamiento de los objetos implementados y comparar sus resultados y tiempos de ejecución con consultas SQL directas.

## 2. Procedimientos almacenados

Se desarrollaron tres procedimientos almacenados para administrar las categorías de productos.

### 2.1. sp_InsertarCategoria

Permite insertar una nueva categoría en la tabla `Categoria`.

**Parámetros:**
- `@id_categoria`: identificador de la categoría.
- `@descripcion`: descripción de la categoría.

### 2.2. sp_ModificarCategoria

Permite modificar la descripción de una categoría existente.

**Parámetros:**
- `@id_categoria`: identificador de la categoría que se desea modificar.
- `@descripcion`: nueva descripción.

### 2.3. sp_EliminarCategoria

Permite eliminar una categoría mediante su identificador.

**Parámetros:**
- `@id_categoria`: identificador de la categoría que se desea eliminar.

## 3. Funciones almacenadas

Se implementaron tres funciones para realizar consultas y cálculos sobre la información de la base de datos.

### 3.1. fn_CalcularTotalVenta

Calcula el importe total de una venta a partir de sus detalles, multiplicando la cantidad por el precio de cada producto y sumando los resultados.

Recibe como parámetro el identificador de la venta (`@id_VentaCabecera`) y devuelve un valor `DECIMAL(10,2)`.

### 3.2. fn_StockDisponible

Devuelve el stock disponible de una variante de producto.

Recibe como parámetro `@id_variante_producto` y devuelve un valor entero (`INT`).

### 3.3. fn_CantidadVentasUsuario

Calcula la cantidad de ventas registradas para un usuario.

Recibe como parámetro `@id_usuario` y devuelve un valor entero (`INT`).

## 4. Pruebas realizadas

### 4.1. Pruebas de procedimientos almacenados

Se realizaron pruebas de inserción, modificación y eliminación de categorías.

Las pruebas incluyeron:
- Inserción directa de un lote de cinco categorías.
- Inserción de otras cinco categorías mediante el procedimiento `sp_InsertarCategoria`.
- Modificación de dos categorías mediante `sp_ModificarCategoria`.
- Eliminación de dos categorías mediante `sp_EliminarCategoria`.
- Verificación de los registros resultantes.

Las operaciones se ejecutaron dentro de una transacción y finalizaron con `ROLLBACK`, evitando que los datos de prueba quedaran almacenados permanentemente.

**Resultado:** se verificaron ocho registros luego de las operaciones y se confirmó que los cambios fueron revertidos correctamente.

### 4.2. Pruebas de funciones almacenadas

Se compararon los resultados de las funciones con consultas SQL directas.

| Operación | Consulta directa | Función almacenada |
|---|---:|---:|
| Importe total de venta 1 | 45000.00 | 45000.00 |
| Stock de variante 1 | 25 | 25 |
| Cantidad de ventas del usuario 1 | 2 | 2 |

**Resultado:** las tres funciones devolvieron los mismos valores que las consultas directas.

## 5. Comparación de tiempos de ejecución

Se utilizaron las instrucciones `SET STATISTICS TIME ON` y `SET STATISTICS TIME OFF` de SQL Server para obtener información sobre los tiempos de ejecución.

Se realizaron dos comparaciones:

- Inserción directa frente a inserción mediante procedimiento almacenado.
- Cálculo directo del importe de una venta frente al cálculo mediante la función `fn_CalcularTotalVenta`.

Los tiempos registrados fueron muy pequeños y variaron entre las ejecuciones. Por este motivo, no se puede establecer una ventaja de rendimiento concluyente para alguno de los métodos.

## 6. Organización de archivos

Los scripts SQL desarrollados se organizaron de la siguiente manera:

**Procedimientos:**
- `sp_InsertarCategoria.sql`
- `sp_ModificarCategoria.sql`
- `sp_EliminarCategoria.sql`
- `Pruebas_Procedimientos.sql`
- `Benchmark_Inserciones.sql`

**Funciones:**
- `CalcularImporteVenta.sql`
- `CalcularStockDisponible.sql`
- `CantidadVentasUsuario.sql`
- `Pruebas_Funciones.sql`
- `Benchmark_Funcion_Importe.sql`
- `scripts.sql`

Las evidencias de implementación y ejecución se almacenaron en las respectivas carpetas `evidencias`.

## 7. Conclusión

La implementación permitió centralizar operaciones de inserción, modificación y eliminación mediante procedimientos almacenados, además de reutilizar cálculos y consultas mediante funciones almacenadas.

Las pruebas realizadas permitieron verificar que los objetos implementados funcionan correctamente y devuelven resultados equivalentes a las consultas SQL directas.

Finalmente, las comparaciones de tiempos permitieron observar el comportamiento de las operaciones en SQL Server, aunque las mediciones obtenidas fueron demasiado pequeñas para establecer diferencias significativas de rendimiento.