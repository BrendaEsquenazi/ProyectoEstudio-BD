USE EcommerceInd;
GO

/* =============================================
   PRUEBAS DE PROCEDIMIENTOS ALMACENADOS
   ============================================= */

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Verificar que los identificadores estén disponibles
    IF EXISTS (
        SELECT 1
        FROM Categoria
        WHERE id_categoria BETWEEN 90101 AND 90110
    )
    BEGIN
        THROW 50001, 'Los IDs de prueba ya existen.', 1;
    END;

    -- 1. Inserción directa de un lote
    INSERT INTO Categoria (id_categoria, descripcion)
    VALUES
    (90101, 'Prueba Directa 1'),
    (90102, 'Prueba Directa 2'),
    (90103, 'Prueba Directa 3'),
    (90104, 'Prueba Directa 4'),
    (90105, 'Prueba Directa 5');

    -- 2. Inserción mediante procedimientos
    EXEC sp_InsertarCategoria 90106, 'Prueba SP 1';
    EXEC sp_InsertarCategoria 90107, 'Prueba SP 2';
    EXEC sp_InsertarCategoria 90108, 'Prueba SP 3';
    EXEC sp_InsertarCategoria 90109, 'Prueba SP 4';
    EXEC sp_InsertarCategoria 90110, 'Prueba SP 5';

    -- 3. Modificación mediante procedimientos
    EXEC sp_ModificarCategoria 90101, 'Prueba Modificada 1';
    EXEC sp_ModificarCategoria 90106, 'Prueba Modificada 2';

    -- 4. Eliminación mediante procedimientos
    EXEC sp_EliminarCategoria 90102;
    EXEC sp_EliminarCategoria 90107;

    -- 5. Verificación de resultados
    SELECT *
    FROM Categoria
    WHERE id_categoria BETWEEN 90101 AND 90110
    ORDER BY id_categoria;

    -- Deshacer todas las operaciones de prueba
    ROLLBACK TRANSACTION;

    PRINT 'Pruebas finalizadas. Los cambios fueron revertidos.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO