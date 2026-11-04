USE EcommerceInd;
GO

CREATE OR ALTER PROCEDURE sp_InsertarCategoria
    @id_categoria INT,
    @descripcion VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Categoria (id_categoria, descripcion)
    VALUES (@id_categoria, @descripcion);
END;
GO