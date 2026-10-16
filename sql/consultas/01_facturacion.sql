USE EcommerceInd;
GO

-- =========================================================================
-- Factura / Comprobante
-- Objetivo: Mostrar encabezado y detalle de una venta, calculando subtotales 
-- por renglón y el total acumulado.
-- =========================================================================

SELECT 
    vc.id_VentaCabecera AS Nro_Factura,
    vc.created_at AS Fecha_Emision,
    u.nombre + ' ' + u.apellido AS Cliente,
    u.dni AS DNI_Cliente,
    p.nombre AS Producto,
    t.nombre AS Talle,
    c.nombre AS Color,
    vd.cantidad AS Cantidad,
    vd.precio AS Precio_Unitario,
    (vd.cantidad * vd.precio) AS Subtotal_Renglon,
    SUM(vd.cantidad * vd.precio) OVER (PARTITION BY vc.id_VentaCabecera) AS Total_Calculado_Factura
FROM Venta_Cabecera vc
INNER JOIN Usuario u 
    ON vc.id_usuario = u.id_usuario
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
INNER JOIN Variante_Producto vp 
    ON vd.id_variante_producto = vp.id_variante_producto
INNER JOIN Producto p 
    ON vp.id_producto = p.id_producto
INNER JOIN Talle t 
    ON vp.id_talle = t.id_talle
INNER JOIN Color c 
    ON vp.id_color = c.id_color
WHERE vc.id_VentaCabecera = 1 -- cambiar este ID para probar con otras ventas
ORDER BY vd.id_VentaDetalle;
GO

-- =========================================================================
-- Historial de Facturas por Cliente
-- Objetivo: Listar todos los comprobantes generados para un usuario 
-- específico, resumiendo la cantidad de artículos y el total de cada orden.
-- =========================================================================

SELECT 
    vc.id_VentaCabecera AS Nro_Factura,
    vc.created_at AS Fecha_Emision,
    vc.estado AS Estado_Venta,
    vc.monto_total AS Total_Facturado,
    COUNT(vd.id_VentaDetalle) AS Cantidad_Renglones,
    SUM(vd.cantidad) AS Total_Unidades_Compradas
FROM Venta_Cabecera vc
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
WHERE vc.id_usuario = 2 -- Se puede cambiar para consultar otros clientes
GROUP BY 
    vc.id_VentaCabecera, 
    vc.created_at, 
    vc.estado, 
    vc.monto_total
ORDER BY 
    vc.created_at DESC;
GO

-- =========================================================================
-- Detalle de Pagos del Comprobante
-- Objetivo: Mostrar los métodos de pago utilizados y los montos abonados 
-- para cancelar una factura específica.
-- =========================================================================

SELECT 
    vc.id_VentaCabecera AS Nro_Factura,
    vc.monto_total AS Total_Factura,
    mp.descripcion AS Metodo_Pago,
    p.monto AS Monto_Abonado,
    p.referencia AS Nro_Transaccion,
    p.fecha AS Fecha_Pago,
    (vc.monto_total - SUM(p.monto) OVER (PARTITION BY vc.id_VentaCabecera)) AS Saldo_Restante
FROM Venta_Cabecera vc
INNER JOIN Pago p 
    ON vc.id_VentaCabecera = p.id_VentaCabecera
INNER JOIN metodo_pago mp 
    ON p.id_metodo = mp.id_metodo
WHERE vc.id_VentaCabecera = 1 -- Debe coincidir con el ID de tu factura principal
ORDER BY 
    p.fecha ASC;
GO


-- =========================================================================
-- Ticket de Cambio (Sin precios)
-- Objetivo: Generar un comprobante válido únicamente para cambios de 
-- mercadería, mostrando los artículos pero ocultando los valores económicos.
-- =========================================================================

SELECT 
    vc.id_VentaCabecera AS Nro_Ticket,
    vc.created_at AS Fecha_Compra,
    u.nombre + ' ' + u.apellido AS Comprador,
    p.nombre AS Producto,
    t.nombre AS Talle,
    c.nombre AS Color,
    vd.cantidad AS Cantidad_Comprada,
    DATEADD(day, 30, vc.created_at) AS Fecha_Limite_Cambio -- Calcula 30 días de validez
FROM Venta_Cabecera vc
INNER JOIN Usuario u 
    ON vc.id_usuario = u.id_usuario
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
INNER JOIN Variante_Producto vp 
    ON vd.id_variante_producto = vp.id_variante_producto
INNER JOIN Producto p 
    ON vp.id_producto = p.id_producto
INNER JOIN Talle t 
    ON vp.id_talle = t.id_talle
INNER JOIN Color c 
    ON vp.id_color = c.id_color
WHERE vc.id_VentaCabecera = 1;
GO


USE EcommerceInd;
GO

-- =========================================================================
-- Presupuesto o Cotización (Venta Pendiente)
-- Objetivo: Emitir un documento detallado de un carrito abandonado o 
-- pendiente de pago, calculando los costos para el cliente.
-- =========================================================================

SELECT 
    vc.id_VentaCabecera AS Nro_Presupuesto,
    vc.created_at AS Fecha_Cotizacion,
    u.nombre + ' ' + u.apellido AS Cliente_Interesado,
    u.email AS Correo_Contacto,
    p.nombre AS Producto,
    t.nombre AS Talle,
    c.nombre AS Color,
    vd.cantidad AS Cantidad,
    vd.precio AS Precio_Unitario_Fijado,
    (vd.cantidad * vd.precio) AS Subtotal_Renglon,
    SUM(vd.cantidad * vd.precio) OVER (PARTITION BY vc.id_VentaCabecera) AS Total_Presupuestado
FROM Venta_Cabecera vc
INNER JOIN Usuario u 
    ON vc.id_usuario = u.id_usuario
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
INNER JOIN Variante_Producto vp 
    ON vd.id_variante_producto = vp.id_variante_producto
INNER JOIN Producto p 
    ON vp.id_producto = p.id_producto
INNER JOIN Talle t 
    ON vp.id_talle = t.id_talle
INNER JOIN Color c 
    ON vp.id_color = c.id_color
WHERE vc.id_VentaCabecera = 3 -- ID de una venta que no se haya pagado
  AND vc.estado = 'Pendiente';
GO