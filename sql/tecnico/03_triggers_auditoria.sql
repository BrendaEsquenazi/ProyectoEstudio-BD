
-------------------------------------------------------------------------------
-- 1. TABLA AUXILIAR DE AUDITORÍA
-------------------------------------------------------------------------------
IF OBJECT_ID('Auditoria_Producto', 'U') IS NOT NULL 
    DROP TABLE Auditoria_Producto;
GO

CREATE TABLE Auditoria_Producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    descripcion_anterior VARCHAR(200),
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    operacion VARCHAR(10) NOT NULL, -- 'UPDATE' o 'DELETE'
    fecha_operacion DATETIME NOT NULL DEFAULT GETDATE(),
    usuario_db VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER
);
GO

-------------------------------------------------------------------------------
-- 2. TRIGGER 1: AUDITORÍA DE UPDATE Y DELETE SOBRE PRODUCTO
-------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_Auditoria_Producto
ON Producto
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Auditoría de Modificaciones (UPDATE)
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Producto (
            id_producto, 
            descripcion_anterior, 
            precio_anterior, 
            precio_nuevo, 
            operacion, 
            fecha_operacion, 
            usuario_db
        )
        SELECT 
            d.id_producto, 
            d.descripcion, 
            d.precio AS precio_anterior, 
            i.precio AS precio_nuevo, 
            'UPDATE', 
            GETDATE(), 
            SYSTEM_USER
        FROM deleted d
        INNER JOIN inserted i ON d.id_producto = i.id_producto;
    END

    -- Auditoría de Eliminaciones (DELETE)
    IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Producto (
            id_producto, 
            descripcion_anterior, 
            precio_anterior, 
            precio_nuevo, 
            operacion, 
            fecha_operacion, 
            usuario_db
        )
        SELECT 
            d.id_producto, 
            d.descripcion, 
            d.precio, 
            NULL, 
            'DELETE', 
            GETDATE(), 
            SYSTEM_USER
        FROM deleted d;
    END
END;
GO

-------------------------------------------------------------------------------
-- 3. TRIGGER 2: CONTROL / DENEGACIÓN DE ELIMINACIÓN SOBRE VENTA_CABECERA
-------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_PreventDelete_VentaCabecera
ON Venta_Cabecera
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR ('[SEGURIDAD / CONTROL]: No está permitido eliminar comprobantes o ventas registradas en el sistema.', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

-------------------------------------------------------------------------------
-- 4. CASOS DE PRUEBA Y DEMOSTRACIÓN DE RESULTADOS
-------------------------------------------------------------------------------

-- PRUEBA 1: Modificación de un precio (UPDATE)
SELECT id_producto, descripcion, precio FROM Producto WHERE id_producto = 1;

UPDATE Producto 
SET precio = precio + 1000.00 
WHERE id_producto = 1;

-- Verificación en la tabla de auditoría
SELECT * FROM Auditoria_Producto WHERE id_producto = 1;
GO

-- PRUEBA 2: Control e Inviolabilidad de Ventas (Intento de DELETE)
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM Venta_Cabecera 
    WHERE id_VentaCabecera = 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'PRUEBA EXITOSA - ERROR CAPTURADO POR TRIGGER: ' + ERROR_MESSAGE();
END CATCH;
GO