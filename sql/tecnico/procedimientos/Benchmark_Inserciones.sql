USE EcommerceInd;
GO

/* =============================================
   COMPARACIÓN DE TIEMPOS: INSERCIÓN DIRECTA
   VS. PROCEDIMIENTO ALMACENADO
   ============================================= */

SET STATISTICS TIME ON;
GO

-- 1. Verificar que el ID de prueba esté disponible
IF EXISTS (
    SELECT 1
    FROM Categoria
    WHERE id_categoria = 90001
)
BEGIN
    THROW 50001, 'El ID de prueba 90001 ya existe.', 1;
END;
GO

-- 2. Inserción directa
BEGIN TRANSACTION;

INSERT INTO Categoria (id_categoria, descripcion)
VALUES (90001, 'Benchmark Directo');

ROLLBACK TRANSACTION;
GO

-- 3. Inserción mediante procedimiento almacenado
BEGIN TRANSACTION;

EXEC sp_InsertarCategoria
    @id_categoria = 90001,
    @descripcion = 'Benchmark Procedimiento';

ROLLBACK TRANSACTION;
GO

SET STATISTICS TIME OFF;
GO