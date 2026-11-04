USE EcommerceInd;
GO

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