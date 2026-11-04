USE EcommerceInd;
GO

/* =============================================
   FUNCIONES ALMACENADAS
   ============================================= */

-- 1. Calcular el importe total de una venta
CREATE OR ALTER FUNCTION fn_CalcularTotalVenta
(
    @id_VentaCabecera INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(cantidad * precio)
    FROM Venta_Detalle
    WHERE id_VentaCabecera = @id_VentaCabecera;

    RETURN ISNULL(@total, 0);
END;
GO

-- 2. Consultar el stock disponible de una variante
CREATE OR ALTER FUNCTION fn_StockDisponible
(
    @id_variante_producto INT
)
RETURNS INT
AS
BEGIN
    DECLARE @stock INT;

    SELECT @stock = stock
    FROM variante_producto
    WHERE id_variante_producto = @id_variante_producto;

    RETURN ISNULL(@stock, 0);
END;
GO

-- 3. Contar las ventas realizadas por un usuario
CREATE OR ALTER FUNCTION fn_CantidadVentasUsuario
(
    @id_usuario INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(*)
    FROM Venta_Cabecera
    WHERE id_usuario = @id_usuario;

    RETURN @cantidad;
END;
GO