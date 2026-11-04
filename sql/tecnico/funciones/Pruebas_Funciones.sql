USE EcommerceInd;
GO

/* =============================================
   PRUEBAS DE FUNCIONES ALMACENADAS
   ============================================= */

-- 1. Comparar cálculo directo del importe
--    con la función fn_CalcularTotalVenta

SELECT
    SUM(cantidad * precio) AS Total_Directo
FROM Venta_Detalle
WHERE id_VentaCabecera = 1;

SELECT
    dbo.fn_CalcularTotalVenta(1) AS Total_Funcion;
GO

-- 2. Comparar consulta directa del stock
--    con la función fn_StockDisponible

SELECT stock AS Stock_Directo
FROM variante_producto
WHERE id_variante_producto = 1;

SELECT
    dbo.fn_StockDisponible(1) AS Stock_Funcion;
GO

-- 3. Comparar conteo directo de ventas
--    con la función fn_CantidadVentasUsuario

SELECT
    COUNT(*) AS Cantidad_Directa
FROM Venta_Cabecera
WHERE id_usuario = 1;

SELECT
    dbo.fn_CantidadVentasUsuario(1) AS Cantidad_Funcion;
GO