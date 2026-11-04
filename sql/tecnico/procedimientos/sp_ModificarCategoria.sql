USE EcommerceInd;
GO

CREATE OR ALTER PROCEDURE sp_ModificarCategoria
    @id_categoria INT,
    @descripcion VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Categoria
    SET descripcion = @descripcion
    WHERE id_categoria = @id_categoria;
END;
GO