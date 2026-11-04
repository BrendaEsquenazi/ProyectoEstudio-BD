USE EcommerceInd;
GO

CREATE OR ALTER PROCEDURE sp_EliminarCategoria
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Categoria
    WHERE id_categoria = @id_categoria;
END;
GO