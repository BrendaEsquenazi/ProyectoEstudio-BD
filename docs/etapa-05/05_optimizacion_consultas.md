# Etapa V: Temas Técnicos — 5. Optimización de Consultas a través de Índices

**Integrante:** Gonzalo Martín Fernández Gómez  
**Archivo SQL:** `sql/tecnico/05_optimizacion_indices.sql`  
**Base de datos:** `EcommerceInd`

---

## 1. Definición y objetivo

Los **índices** son estructuras de datos auxiliares (implementadas en SQL Server mediante árboles balanceados o **B-Trees**) asociadas a tablas o vistas que permiten al motor de base de datos localizar filas de manera rápida y eficiente sin necesidad de recorrer la totalidad de las páginas de almacenamiento. Su funcionamiento es análogo al índice temático de un libro: en lugar de examinar página por página (*Table Scan*), el optimizador de consultas navega por los niveles del árbol del índice hasta acceder directamente a los registros que cumplen con la condición de búsqueda (*Index Seek*).

### Objetivo
El objetivo principal de implementar índices en el sistema de ventas es **optimizar el rendimiento de las consultas de lectura y filtrado** sobre tablas transaccionales de gran volumen (como el historial de cabeceras de ventas), reduciendo drásticamente:
- La cantidad de **lecturas lógicas** (páginas de 8 KB leídas desde la memoria caché o disco).
- El **tiempo de procesador (CPU time)** y el **tiempo total de respuesta (Elapsed time)**.
- El costo del plan de ejecución, sustituyendo recorridos completos (*Table Scan* / *Clustered Index Scan*) por búsquedas dirigidas (*Index Seek*).

---

## 2. Ventajas, aplicaciones y consideraciones

### Ventajas
- **Aceleración de búsquedas y filtros:** Mejora exponencialmente el tiempo de respuesta en cláusulas `WHERE`, `JOIN`, `ORDER BY` y `GROUP BY`.
- **Drástica disminución de E/S (I/O):** Reduce la cantidad de páginas de datos leídas en memoria (*buffer pool*), liberando recursos para otras transacciones concurrentes del e-commerce.
- **Consultas cubiertas (*Covering Queries*):** Mediante el uso de índices no agrupados con columnas incluidas (`INCLUDE`), el motor puede responder consultas leyendo únicamente las páginas del índice sin tocar la tabla base.
- **Escalabilidad:** Permite que los reportes gerenciales, contables y de facturación mantengan tiempos de respuesta de pocos milisegundos incluso cuando la tabla supera el millón de operaciones registradas.

### Aplicaciones en el sistema de e-commerce
- Filtrado de órdenes de venta por rangos de fecha (`created_at`) para cierres contables mensuales o trimestrales.
- Búsqueda de historial de pedidos por cliente (`id_usuario`) y estado de orden (`estado`).
- Conciliación de pagos por fecha de acreditación (`fecha` en la tabla `Pago`).

### Consideraciones y costo de mantenimiento
- Los índices adicionales consumen **espacio de almacenamiento** en disco y en memoria.
- Pueden penalizar levemente el rendimiento de operaciones de escritura (`INSERT`, `UPDATE`, `DELETE`), dado que el motor debe actualizar tanto la tabla base como las estructuras B-Tree de cada índice asociado. Por ello, se deben indexar estratégicamente las columnas de alta frecuencia de consulta y selectividad.

---

## 3. Implementación en SQL Server Express

En SQL Server existen dos tipos fundamentales de índices para este escenario:

1. **Sin índice (Estructura *Heap*):**  
   Cuando una tabla se crea sin clave primaria agrupada ni índice *Clustered*, sus datos se almacenan sin un orden físico específico (*Heap*). Cualquier filtro por fechas obliga al motor a realizar un **`Table Scan`** (recorrer el 100% de las páginas de la tabla).

2. **Índice Agrupado (*Clustered Index*):**  
   Ordena y almacena físicamente las filas de datos de la tabla en las páginas hoja del árbol B-Tree de acuerdo con la clave definida (`created_at`). Solo puede existir **uno por tabla**.
   ```sql
   CREATE CLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha
   ON Venta_Cabecera_Historica(created_at);
   ```

3. **Índice No Agrupado con Cobertura (*Non-Clustered Covering Index*):**  
   Crea una estructura B-Tree independiente ordenada por la columna de búsqueda (`created_at`) e incorpora en su nivel hoja columnas adicionales no clave mediante la cláusula `INCLUDE` (`monto_total`, `estado`, `id_usuario`). De esta manera, el optimizador resuelve la consulta íntegramente desde el índice con un **`Index Seek`**, evitando costosas operaciones de búsqueda adicional (*RID Lookup* o *Key Lookup*) hacia la tabla principal.
   ```sql
   CREATE NONCLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha_Cobertura
   ON Venta_Cabecera_Historica(created_at)
   INCLUDE (monto_total, estado, id_usuario);
   ```

---

## 4. Caso concreto aplicado al sistema de ventas del equipo

### Problema de negocio
En nuestra plataforma de e-commerce de indumentaria (`EcommerceInd`), la tabla transaccional `Venta_Cabecera` registra cada orden de compra junto con su fecha de emisión (`created_at`), importe total (`monto_total`), estado (`estado`) y cliente (`id_usuario`). Con el crecimiento del negocio y la acumulación histórica de **1.000.000 de ventas**, el área de administración y finanzas necesita emitir reportes trimestrales (por ejemplo, todas las ventas del **primer trimestre de 2023**: desde el `2023-01-01` hasta el `2023-03-31`) sin degradar el rendimiento de la plataforma.

### Adaptación al modelo
Para realizar el banco de pruebas con **1.000.000 de registros** respetando la estructura del proyecto sin alterar los lotes de prueba reducidos del resto de los módulos, se implementó la tabla `Venta_Cabecera_Historica` con los atributos reales del modelo de ventas:
- `id_VentaCabecera BIGINT IDENTITY(1,1)`
- `created_at DATE NOT NULL`
- `monto_total DECIMAL(12,2) NOT NULL`
- `estado VARCHAR(30) NOT NULL` (`'Completada'`, `'Pagada'`, `'Enviada'`, `'Pendiente'`, `'Cancelada'`)
- `id_usuario INT NOT NULL` (clientes del 1 al 10 registrados en `Usuario`)

---

## 5. Script de demostración y resultados obtenidos

### Parte 1 y 2 — Creación de la tabla y carga masiva de 1.000.000 de registros

```sql
CREATE TABLE Venta_Cabecera_Historica
(
    id_VentaCabecera BIGINT IDENTITY(1,1),
    created_at DATE NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    id_usuario INT NOT NULL
);
GO

SET NOCOUNT ON;
GO

WITH Numeros AS
(
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO Venta_Cabecera_Historica (created_at, monto_total, estado, id_usuario)
SELECT
    DATEADD(DAY, ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % 1825, '2020-01-01') AS created_at,
    CAST(RAND(CHECKSUM(NEWID())) * 150000 + 12500 AS DECIMAL(12,2)) AS monto_total,
    CASE (n % 5)
        WHEN 0 THEN 'Completada'
        WHEN 1 THEN 'Pagada'
        WHEN 2 THEN 'Enviada'
        WHEN 3 THEN 'Pendiente'
        ELSE 'Cancelada'
    END AS estado,
    CAST((n % 10) + 1 AS INT) AS id_usuario
FROM Numeros;
GO

SELECT COUNT(*) AS CantidadRegistros
FROM Venta_Cabecera_Historica;
```

**Verificación de carga:**
- `CantidadRegistros`: **1.000.000** filas insertadas.
- Registros que cumplen el filtro del 1er trimestre de 2023 (`2023-01-01` al `2023-03-31`): **49.435 filas**.

---

### Parte 3 — Escenario 1: Consulta sin índices (Heap)

```sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT
    id_VentaCabecera,
    created_at,
    monto_total,
    estado,
    id_usuario
FROM Venta_Cabecera_Historica
WHERE created_at BETWEEN '2023-01-01' AND '2023-03-31';
GO
```

**Salida real de SQL Server (`STATISTICS IO` y `STATISTICS TIME`):**
```text
(49435 rows affected)
Table 'Venta_Cabecera_Historica'. Scan count 9, logical reads 5587, physical reads 0, read-ahead reads 0.

SQL Server Execution Times:
   CPU time = 251 ms,  elapsed time = 436 ms.
```

| Medición | Valor obtenido |
| :--- | :--- |
| **Tiempo CPU** | `251 ms` |
| **Tiempo total (Elapsed)** | `436 ms` |
| **Lecturas lógicas (Logical Reads)** | `5.587 páginas` (aprox. 44,7 MB leídos) |
| **Operación principal (Plan de ejecución)** | `Table Scan` (paralelizado en `Scan count 9`) |
| **Costo relativo en el plan** | `100%` en el operador `Table Scan` |

**Observación:** Al no existir ningún índice sobre `created_at`, el motor se ve obligado a leer las **5.587 páginas** completas que conforman la tabla para evaluar fila por fila cuáles pertenecen al primer trimestre de 2023.

---

### Parte 4 — Escenario 2: Crear índice agrupado (*Clustered Index*) sobre la fecha

```sql
CREATE CLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha
ON Venta_Cabecera_Historica(created_at);
GO

SELECT
    id_VentaCabecera,
    created_at,
    monto_total,
    estado,
    id_usuario
FROM Venta_Cabecera_Historica
WHERE created_at BETWEEN '2023-01-01' AND '2023-03-31';
GO
```

**Salida real de SQL Server (`STATISTICS IO` y `STATISTICS TIME`):**
```text
(49435 rows affected)
Table 'Venta_Cabecera_Historica'. Scan count 1, logical reads 319, physical reads 0, read-ahead reads 0.

SQL Server Execution Times:
   CPU time = 16 ms,  elapsed time = 378 ms.
```

| Medición | Valor obtenido |
| :--- | :--- |
| **Tiempo CPU** | `16 ms` |
| **Tiempo total (Elapsed)** | `378 ms` |
| **Lecturas lógicas (Logical Reads)** | `319 páginas` (aprox. 2,5 MB leídos) |
| **Operación principal (Plan de ejecución)** | `Clustered Index Seek` (`Scan count 1`) |

**Observación:** Al ordenar físicamente la tabla por `created_at`, el optimizador cambia inmediatamente su estrategia a **`Clustered Index Seek`**. Se posiciona directamente en el `2023-01-01` y lee secuencialmente solo hasta el `2023-03-31`. Las lecturas lógicas caen de **5.587 a 319 páginas** (**94,29% menos de lecturas**) y el tiempo de CPU baja de **251 ms a 16 ms** (**93,63% menos de uso de CPU**).

---

### Parte 5 y 6 — Escenario 3: Eliminar índice agrupado y crear índice no agrupado con cobertura (`INCLUDE`)

```sql
DROP INDEX IX_VentaCabeceraHistorica_Fecha
ON Venta_Cabecera_Historica;
GO

CREATE NONCLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha_Cobertura
ON Venta_Cabecera_Historica(created_at)
INCLUDE (monto_total, estado, id_usuario);
GO

SELECT
    created_at,
    monto_total,
    estado,
    id_usuario
FROM Venta_Cabecera_Historica
WHERE created_at BETWEEN '2023-01-01' AND '2023-03-31';
GO
```

**Salida real de SQL Server (`STATISTICS IO` y `STATISTICS TIME`):**
```text
(49435 rows affected)
Table 'Venta_Cabecera_Historica'. Scan count 1, logical reads 263, physical reads 0, read-ahead reads 0.

SQL Server Execution Times:
   CPU time = 31 ms,  elapsed time = 322 ms.
```

| Medición | Valor obtenido |
| :--- | :--- |
| **Tiempo CPU** | `31 ms` |
| **Tiempo total (Elapsed)** | `322 ms` |
| **Lecturas lógicas (Logical Reads)** | `263 páginas` (aprox. 2,1 MB leídos) |
| **Operación principal (Plan de ejecución)** | `Index Seek (NonClustered)` |

**Observación:** El motor resuelve la totalidad de la consulta leyendo exclusivamente el índice no agrupado `IX_VentaCabeceraHistorica_Fecha_Cobertura` mediante un **`Index Seek`**, sin necesidad de acceder a la tabla base. Como las páginas hoja de este índice contienen únicamente las columnas requeridas por el reporte (omitiendo los 8 bytes de `id_VentaCabecera BIGINT`), entran más registros por cada página de 8 KB, reduciendo aún más las lecturas lógicas de **319 a 263 páginas** y logrando el menor tiempo total de ejecución (**322 ms**).

---

## 6. Comparación final y conclusiones

### Tabla comparativa de resultados

| Escenario | Tiempo CPU (ms) | Tiempo Total (ms) | Lecturas Lógicas (páginas) | Reducción de Lecturas | Operación Principal |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **1. Sin índice (Heap)** | 251 ms | 436 ms | 5.587 | — (Base 100%) | `Table Scan` |
| **2. Índice agrupado sobre fecha** | 16 ms | 378 ms | 319 | **-94,29%** | `Clustered Index Seek` |
| **3. Índice no agrupado con cobertura** | 31 ms | 322 ms | 263 | **-95,29%** | `Index Seek (NonClustered)` |

### Conclusiones
1. **Impacto crítico del `Table Scan`:** Sin índices, consultar un trimestre sobre un millón de ventas exige leer las **5.587 páginas** completas de la tabla y emplear múltiples hilos de CPU (`251 ms`), lo cual en un entorno productivo de e-commerce generaría cuellos de botella ante consultas simultáneas.
2. **Eficiencia del índice sobre fechas:** Al incorporar el índice agrupado por `created_at`, el motor pasa de recorrer toda la tabla a realizar una búsqueda directa (`Clustered Index Seek`), reduciendo las páginas leídas en un **94,29%** (de 5.587 a 319) y el consumo de CPU en más de un **93%**.
3. **Ventaja del índice con cobertura (`INCLUDE`):** Cuando en una tabla real el índice agrupado ya está ocupado por la clave primaria (`id_VentaCabecera`), el **índice no agrupado con cobertura (`INCLUDE`)** constituye la solución óptima: permite conservar la `PRIMARY KEY` original y al mismo tiempo responder reportes por fechas mediante un `Index Seek` puro con apenas **263 lecturas lógicas** (-95,29%) y sin lecturas adicionales (*Key Lookups*).

