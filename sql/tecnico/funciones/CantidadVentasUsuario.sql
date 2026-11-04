USE EcommerceInd;
GO

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