USE EcommerceInd;
GO

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