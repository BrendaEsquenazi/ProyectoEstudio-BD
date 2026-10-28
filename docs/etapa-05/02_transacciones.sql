
-- PRUEBA 1: EJECUCION EXITOSA (COMMIT)
-- Escenario: Se registra una venta de 2 unidades de una variante con stock.
-- Se inserta en Venta_Cabecera, en Venta_Detalle y se descuenta stock.

-- Verificamos el estado previo del stock
SELECT id_variante_producto, stock 
FROM Variante_Producto 
WHERE id_variante_producto = 1;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar Cabecera de Venta
    INSERT INTO Venta_Cabecera (id_VentaCabecera, created_at, updated_at, monto_total, estado, id_usuario)
    VALUES (101, GETDATE(), GETDATE(), 45000.00, 'Pagada', 1);

    -- 2. Insertar Detalle de Venta (2 unidades a $22.500)
    INSERT INTO Venta_Detalle (id_VentaDetalle, cantidad, precio, id_VentaCabecera, id_variante_producto)
    VALUES (201, 2, 22500.00, 101, 1);

    -- 3. Actualizar Stock descontando las unidades vendidas
    UPDATE Variante_Producto
    SET stock = stock - 2
    WHERE id_variante_producto = 1;

    -- Si no hubo errores, se confirman los cambios
    COMMIT TRANSACTION;
    PRINT 'TRANSACCION EXITOSA: Venta registrada y stock actualizado correctamente.';

END TRY
BEGIN CATCH
    -- Si ocurre cualquier error, se deshacen todos los cambios
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERROR DETECTADO: Se ejecuto ROLLBACK. Mensaje: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Verificacion posterior a la Prueba 1:
SELECT * FROM Venta_Cabecera WHERE id_VentaCabecera = 101;
SELECT * FROM Venta_Detalle WHERE id_VentaCabecera = 101;
SELECT id_variante_producto, stock FROM Variante_Producto WHERE id_variante_producto = 1;
GO


-- PRUEBA 2: ERROR PROVOCADO Y ROLLBACK
-- Escenario: Se intenta registrar una venta con un id_usuario inexistente (9999).
-- Falla por la restriccion FK_VentaCabecera_Usuario.
-- Demostracion de Atomicidad: Ninguna tabla debe quedar modificada.

-- Guardamos el stock actual antes de la prueba con error
SELECT id_variante_producto, stock 
FROM Variante_Producto 
WHERE id_variante_producto = 1;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Intentar actualizar stock preventivamente
    UPDATE Variante_Producto
    SET stock = stock - 5
    WHERE id_variante_producto = 1;

    -- 2. Insertar Cabecera con un id_usuario que NO EXISTE (viola FK)
    INSERT INTO Venta_Cabecera (id_VentaCabecera, created_at, updated_at, monto_total, estado, id_usuario)
    VALUES (102, GETDATE(), GETDATE(), 50000.00, 'Pendiente', 9999);

    -- 3. Insertar Detalle
    INSERT INTO Venta_Detalle (id_VentaDetalle, cantidad, precio, id_VentaCabecera, id_variante_producto)
    VALUES (202, 5, 10000.00, 102, 1);

    COMMIT TRANSACTION;
    PRINT 'TRANSACCION EXITOSA';

END TRY
BEGIN CATCH
    -- El error salta al bloque CATCH y ejecuta ROLLBACK
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERROR PROVOCADO CAPTURADO: Se ejecuto ROLLBACK.';
    PRINT 'Detalle del error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Verificacion posterior a la Prueba 2 (Demostracion de Atomicidad):
-- No debe existir la venta 102 ni el detalle 202, y el stock del producto 1 debe ser el mismo que antes.
SELECT * FROM Venta_Cabecera WHERE id_VentaCabecera = 102;
SELECT * FROM Venta_Detalle WHERE id_VentaCabecera = 102;
SELECT id_variante_producto, stock FROM Variante_Producto WHERE id_variante_producto = 1;
GO