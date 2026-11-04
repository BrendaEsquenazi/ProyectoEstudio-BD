USE EcommerceInd;
GO

/* =============================================
   COMPARACIÓN DE TIEMPOS:
   CONSULTA DIRECTA VS. FUNCIÓN
   ============================================= */

SET STATISTICS TIME ON;
GO

-- 1. Cálculo directo del importe de la venta

SELECT SUM(cantidad * precio) AS Total_Directo
FROM Venta_Detalle
WHERE id_VentaCabecera = 1;
GO

-- 2. Cálculo mediante función almacenada

SELECT dbo.fn_CalcularTotalVenta(1) AS Total_Funcion;
GO

SET STATISTICS TIME OFF;
GO