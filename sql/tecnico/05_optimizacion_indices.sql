USE EcommerceInd;
GO

-- =========================================================================
-- ETAPA V - TEMA TÉCNICO 5: OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES
-- Integrante: Gonzalo Martín Fernández Gómez
-- Caso aplicado: Análisis histórico de ventas por períodos de fechas sobre
--                el modelo de Venta_Cabecera del e-commerce de indumentaria.
-- =========================================================================

-- Limpieza previa en caso de re-ejecución del script
IF OBJECT_ID('dbo.Venta_Cabecera_Historica', 'U') IS NOT NULL
    DROP TABLE dbo.Venta_Cabecera_Historica;
GO

-- =========================================================================
-- PARTE 1 - Creación de la tabla de pruebas
-- Se adapta la estructura de Venta_Cabecera del modelo del e-commerce
-- sin definir clave primaria inicial (estructura Heap) para evaluar el
-- comportamiento base del motor mediante Table Scan.
-- =========================================================================

CREATE TABLE Venta_Cabecera_Historica
(
    id_VentaCabecera BIGINT IDENTITY(1,1),
    created_at DATE NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    id_usuario INT NOT NULL
);
GO

-- =========================================================================
-- PARTE 2 - Carga masiva de datos (1.000.000 de registros)
-- Se genera información simulada de órdenes de venta distribuidas en un
-- período de 5 años (1825 días a partir de 2020-01-01), con importes,
-- estados válidos del e-commerce y clientes existentes (IDs 1 a 10).
-- =========================================================================

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

SET NOCOUNT OFF;
GO

-- Verificar la cantidad total de registros insertados
SELECT COUNT(*) AS CantidadRegistros
FROM Venta_Cabecera_Historica;
GO

-- =========================================================================
-- PARTE 3 - Escenario 1: Consulta sin índices (Heap / Table Scan)
-- Se activan las estadísticas de tiempo y de entrada/salida (lecturas)
-- para medir el costo de filtrar las ventas del 1er trimestre de 2023.
-- =========================================================================

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

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- =========================================================================
-- PARTE 4 - Escenario 2: Crear índice agrupado (Clustered Index) sobre fecha
-- Ordena físicamente las páginas de datos de la tabla según created_at.
-- =========================================================================

CREATE CLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha
ON Venta_Cabecera_Historica(created_at);
GO

-- Repetir la consulta para medir el impacto del Clustered Index Seek
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

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- =========================================================================
-- PARTE 5 - Eliminar el índice agrupado
-- Se vuelve la tabla a estructura Heap para evaluar el índice cubriente.
-- =========================================================================

DROP INDEX IX_VentaCabeceraHistorica_Fecha
ON Venta_Cabecera_Historica;
GO

-- =========================================================================
-- PARTE 6 - Escenario 3: Crear un índice no agrupado que cubra la consulta
-- Se indexa por created_at y se incluyen en el nivel hoja (INCLUDE) las
-- columnas proyectadas frecuentemente en los reportes comerciales.
-- =========================================================================

CREATE NONCLUSTERED INDEX IX_VentaCabeceraHistorica_Fecha_Cobertura
ON Venta_Cabecera_Historica(created_at)
INCLUDE (monto_total, estado, id_usuario);
GO

-- Repetir la consulta cubierta exclusivamente por el índice no agrupado
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT
    created_at,
    monto_total,
    estado,
    id_usuario
FROM Venta_Cabecera_Historica
WHERE created_at BETWEEN '2023-01-01' AND '2023-03-31';
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
