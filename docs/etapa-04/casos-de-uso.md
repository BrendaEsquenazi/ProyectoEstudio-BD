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


## 3. Factura / Comprobante de Venta y Perfil del Cliente (Gonzalo)

**Archivo SQL:** `sql/consultas/01_facturacion.sql`

### Objetivo
Generar una vista detallada que simule la emisión de una factura para el cliente, calculando los subtotales por renglón y el total acumulado de la venta. Además, proveer consultas complementarias para el perfil del cliente (historial de compras), el detalle de pagos de la factura y la emisión de tickets de cambio sin precio.

### Estrategia SQL utilizada
- **INNER JOIN:** vincula múltiples tablas (`Venta_Cabecera`, `Usuario`, `Venta_Detalle`, `Variante_Producto`, `Producto`, `Talle`, `Color`) para construir el detalle completo y descriptivo del comprobante.
- **Operaciones aritméticas:** calcula el subtotal por renglón de forma directa (`cantidad * precio`).
- **Funciones de Ventana (Window Functions):** emplea `SUM() OVER(PARTITION BY)` para calcular el total acumulado exacto de la venta y los saldos en tiempo real sin tener que agrupar y perder el detalle de cada artículo.
- **Funciones de Agrupamiento y Fecha:** uso de `COUNT()`, `SUM()` y `GROUP BY` para los resúmenes del historial, y `DATEADD()` para calcular automáticamente la fecha de vencimiento en los tickets de cambio (30 días).
- **Concatenación:** unifica el nombre y apellido del cliente en un solo campo visual.

### 3.1 Caso de Uso 1: Emisión de Comprobante de Venta (Principal)
- **Identificador:** CU-FAC-01
- **Nombre:** Generación de factura detallada con cálculos de totales.
- **Actor:** Sistema / Cajero.
- **Objetivo:** Generar un documento formal al finalizar una compra detallando el cliente, artículos comprados (con variante de talle y color), subtotal por renglón y total de la orden.
- **Precondición:** Existe una venta registrada en cabecera con sus respectivos detalles.
- **Resultado esperado:** Una vista donde todas las filas comparten el número de factura y datos del cliente, desglosando un producto diferente por renglón con su respectivo subtotal y el total global calculado.

### 3.2 Caso de Uso 2: Visualización de "Mis Pedidos" (Historial)
- **Identificador:** CU-FAC-02
- **Nombre:** Consulta de historial de compras por usuario.
- **Actor:** Cliente / Usuario.
- **Objetivo:** Mostrar un resumen cronológico de todas las compras pasadas del usuario para que pueda llevar control de sus gastos o repetir pedidos.
- **Precondición:** El usuario debe existir y tener al menos una compra registrada.
- **Resultado esperado:** Una lista de ventas consolidada, ordenada desde la venta más reciente a la más antigua para un ID de cliente específico.

### 3.3 Caso de Uso 3: Detalle de Pagos Aplicados
- **Identificador:** CU-FAC-03
- **Nombre:** Desglose de métodos de cobro y cálculo de saldo.
- **Actor:** Administrador / Área Contable.
- **Objetivo:** Revisar una factura específica para verificar con qué medios de pago se abonó (ej. efectivo y tarjeta combinados) y calcular dinámicamente si existe un saldo pendiente.
- **Precondición:** La venta debe estar relacionada con al menos un registro en la tabla de pagos.
- **Resultado esperado:** Desglose de los montos parciales abonados con cada método, fechas de transacción y el cálculo del saldo restante.

### 3.4 Caso de Uso 4: Emisión de Ticket de Cambio (Sin precios)
- **Identificador:** CU-FAC-04
- **Nombre:** Generación de comprobante para logística inversa y devoluciones.
- **Actor:** Cliente / Vendedor.
- **Objetivo:** Generar un comprobante de cortesía válido únicamente para el cambio de mercadería, ocultando los valores económicos y fijando una vigencia para la devolución.
- **Precondición:** Existe una venta válida y concretada.
- **Resultado esperado:** Un comprobante limpio que lista los artículos exactos comprados (con talle y color) y la fecha límite (calculada 30 días a futuro) para realizar devoluciones.

### 3.5 Caso de Uso 5: Generación de Presupuesto / Carrito Guardado
- **Identificador:** CU-FAC-05
- **Nombre:** Emisión de cotización para ventas pendientes.
- **Actor:** Cliente / Ventas.
- **Objetivo:** Brindar al cliente un resumen formal de los artículos que dejó en su carrito sin finalizar el pago, congelando el precio y calculando el subtotal y total presupuestado.
- **Precondición:** La cabecera de venta debe encontrarse en estado 'Pendiente'.
- **Resultado esperado:** Un comprobante tipo cotización que lista los artículos, cantidades y el costo total proyectado, junto con los datos de contacto del usuario para posibles seguimientos.

## 4. Validacion de Importes de Venta y Pagos Asociados
**Archivo SQL:** `sql/consultas/04_validacion_ventas_pagos.sql`

### Objetivo
Verificar la integridad contable y la consistencia de los datos del modulo de ventas, comparando el importe total declarado en la cabecera contra la sumatoria de sus detalles correspondientes, y conciliando el total facturado frente a los pagos efectivamente registrados para cada orden.

### Estrategia SQL utilizada
- **INNER JOIN:** vincula Venta_Cabecera con Venta_Detalle para relacionar cada orden con sus lineas de articulos adquiridos.
- **LEFT JOIN:** asocia Venta_Cabecera con Pago y metodo_pago, permitiendo incluir ventas que se encuentren en estado pendiente o que aun carezcan de transacciones de pago asentadas.
- **SUM:** calcula la sumatoria fisica del producto entre cantidad y precio unitario (cantidad * precio), asi como el monto total acumulado de los pagos recibidos.
- **ISNULL:** sustituye valores nulos por cero (0) en aquellas ventas sin registros en la tabla de pagos, permitiendo efectuar operaciones aritmeticas directas de resta de saldos.
- **CASE:** categoriza dinamicamente el estado de cobertura financiera de la venta comparando el monto abonado contra el importe total de la cabecera.
- **GROUP BY:** agrupa los registros por los identificadores y atributos clave de la cabecera de venta para consolidar los totales calculados.
- **HAVING:** filtra en la consulta de auditoria unicamente aquellos casos anomalos donde una venta figure como completada o pagada pero presente saldo pendiente mayor a cero.
- **ORDER BY:** ordena los resultados de forma secuencial por el identificador de la cabecera de venta para facilitar el cotejo y la auditoria.

### 4.1 Caso de Uso 1: Conciliación de Importe Declarado vs. Detalle de Ítems
- **Identificador:** CU-VAL-01
- **Nombre:** Verificación del importe total de venta contra sumatoria de detalles.
- **Actor:** Administrador del sistema / Auditor de datos.
- **Objetivo:** Comprobar que el atributo monto_total almacenado en Venta_Cabecera coincida de manera idéntica con el cálculo aritmético derivado de sus ítems asociados (Venta_Detalle.cantidad * Venta_Detalle.precio).
- **Precondición**: Existen registros cargados en las tablas Venta_Cabecera y Venta_Detalle.
- **Consulta SQL asociada:** Consulta 1
- **Criterio de Aceptación / Resultado Esperado:** La columna diferencia debe ser estrictamente 0.00 en todas las filas procesadas.

### 4.2 Caso de Uso 2: Conciliación de Pagos y Control de Saldos
- **Identificador:** CU-VAL-02
- **Nombre:** Validación del flujo de pagos por orden y detección de saldos.
- **Actor:** Responsable de Tesorería / Ventas.
- **Objetivo:** Determinar el importe acumulado abonado para cada pedido registrado, contrastarlo con el estado del pedido y constatar la existencia o ausencia de saldos impagos.
- **Precondición:** Existen ventas cargadas y, opcionalmente, comprobantes en la tabla Pago.
- **Consulta SQL asociada:** Consulta 2
- **Criterio de Aceptación / Resultado Esperado:** Toda orden con estado = 'Pagada' o 'Completada' debe mostrar saldo_pendiente = 0.00.
Toda orden con estado = 'Pendiente' o 'Cancelada' puede reflejar un saldo igual al monto total o sin comprobantes asociados (ISNULL evaluado en 0).

### 4.3 Caso de Uso 3: Trazabilidad Operativa de la Transacción
- **Identificador:** CU-VAL-04
- **Nombre:** Consulta integral de detalle de orden y medio de pago.
- **Actor:** Atención al Cliente / Soporte.
**Objetivo:** Exponer la trazabilidad completa de una venta visualizando los artículos puntuales adquiridos, sus importes unitarios, el medio de cobro seleccionado y el código de referencia de la pasarela.
- **Precondición:** Existencia de registros correlacionados en las 4 tablas del módulo.
- **Consulta SQL asociada:** Consulta 3
- **Criterio de Aceptación / Resultado Esperado:** Despliegue correcto de cada fila de producto sin registros duplicados erróneamente por el cruce relacional.

### 4.4 Caso de Uso 4: Auditoría Automática de Inconsistencias
- **Identificador:** CU-VAL-03
- **Nombre:** Detección de órdenes cerradas con inconsistencia de cobro.
- **Actor:** Auditor de Calidad de Datos.
- **Objetivo:** Filtrar y alertar anomalías en el sistema donde un pedido figure formalmente como completado o pagado pero carezca del respaldo total en dinero dentro de la tabla Pago.
- **Precondición:** Tablas del módulo de ventas y pagos pobladas.
- **Consulta SQL asociada:** Consulta 4
- **Criterio de Aceptación / Resultado Esperado:** La consulta debe retornar exactamente 0 filas (empty set), comprobando que no existen discrepancias contables en la base.

## 5. Análisis de Clientes y Logística (Consultas Adicionales)

**Archivo SQL:** `sql/consultas/05_analisis_clientes.sql`

### Objetivo
Proveer métricas analíticas sobre el comportamiento de compra de los usuarios y la distribución geográfica de los ingresos, con el fin de asistir en la toma de decisiones para campañas de marketing y optimización de envíos.

### Estrategia SQL utilizada
- **INNER JOIN:** vincula las tablas de ventas (`Venta_Cabecera`) con los datos personales (`Usuario`) y de ubicación (`Direccion`).
- **Funciones de Agrupamiento (GROUP BY, SUM, COUNT, AVG):** consolida la información para obtener totales, promedios y conteos por cliente o por zona geográfica.
- **HAVING:** filtra los resultados agrupados (ej. clientes que superen un umbral mínimo de gasto).
- **TOP / ORDER BY:** ordena de mayor a menor para generar rankings automáticos.

### 5.1 Caso de Uso 1: Ranking de Mejores Clientes (Fidelización)
- **Identificador:** CU-MKT-01
- **Nombre:** Identificación de clientes VIP por volumen de compras.
- **Actor:** Equipo de Marketing / Ventas.
- **Objetivo:** Identificar a los usuarios que más dinero han gastado en la tienda y su volumen de compra histórico, filtrando solo a aquellos que superen un monto mínimo de inversión, para incluirlos en campañas de fidelización o descuentos exclusivos.
- **Precondición:** Existen ventas completadas asociadas a usuarios registrados.
- **Resultado esperado:** Un listado (ranking) con los clientes ordenados de mayor a menor según el dinero total gastado, mostrando también su ticket promedio.

### 5.2 Caso de Uso 2: Distribución Geográfica de Ingresos
- **Identificador:** CU-LOG-01
- **Nombre:** Análisis de ventas por provincia y ciudad.
- **Actor:** Equipo de Logística / Gerencia.
- **Objetivo:** Identificar desde qué provincias y ciudades provienen la mayor cantidad de ventas e ingresos del e-commerce. Esta información permite negociar mejores tarifas de envío con correos para las zonas más calientes o dirigir publicidad a las regiones con menos ventas.
- **Precondición:** Los usuarios tienen domicilios registrados y ventas asociadas.
- **Resultado esperado:** Un listado agrupado por provincia y ciudad, mostrando la cantidad de pedidos entregados en cada zona y el total de dinero recaudado, ordenado de mayor a menor ingreso.
