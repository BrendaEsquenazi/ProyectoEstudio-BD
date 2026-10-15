# Etapa IV: Consultas y Casos de Uso

## 1. Consulta de Negocio Avanzada

**Archivo SQL:** `sql/consultas/03_consulta_avanzada.sql`

### Objetivo

Identificar variantes de productos que tengan un stock menor o igual a 15 unidades y cuyo precio unitario sea superior al precio promedio del catálogo. Esta información permite detectar productos de precio relativamente alto con pocas unidades disponibles.

### Estrategia SQL utilizada

- **INNER JOIN:** combina las tablas `Producto`, `Variante_Producto`, `Talle` y `Color` mediante sus claves relacionadas.
- **Subconsulta:** obtiene el precio promedio del catálogo mediante `AVG(precio_unitario)`.
- **WHERE:** filtra las variantes con stock menor o igual a 15 y los productos cuyo precio supera el promedio.
- **ORDER BY:** ordena los resultados por stock ascendente y precio unitario descendente.

### Resultado esperado

La consulta muestra el identificador y nombre del producto, talle, color, stock, precio unitario y precio promedio del catálogo. Solo aparecen las variantes que cumplen ambas condiciones.

En la prueba realizada en SQL Server obtuvimos dos resultados:

- Zapatillas Canvas Urbanas: talle 40, color Negro, stock 12 y precio unitario de $55.000.
- Zapatillas Running Pro: talle 42, color Rojo, stock 15 y precio unitario de $78.000.

El precio promedio del catálogo obtenido en la prueba fue de $35.500.

## 2. Reporte Agregado por Categoría de Producto

**Archivo SQL:** `sql/consultas/02_reporte_agregado.sql`

### Objetivo

Obtener un resumen de las ventas por categoría de producto dentro de un período determinado, mostrando la cantidad de ventas, las unidades vendidas y el importe total vendido.

### Estrategia SQL utilizada

- **INNER JOIN:** relaciona las tablas `Categoria`, `Producto`, `Variante_Producto`, `Venta_Detalle` y `Venta_Cabecera`.
- **COUNT(DISTINCT):** cuenta las ventas diferentes de cada categoría.
- **SUM:** calcula las unidades vendidas y el importe total vendido.
- **WHERE:** filtra las ventas según el período y el estado.
- **GROUP BY:** agrupa los resultados por categoría.
- **ORDER BY:** ordena las categorías por importe total vendido, de mayor a menor.

### Resultado esperado

La consulta devuelve una fila por cada categoría que tenga ventas coincidentes con los filtros establecidos, mostrando la cantidad de ventas, las unidades vendidas y el importe total vendido.

El resultado permite comparar el desempeño comercial de las categorías durante el período consultado.
