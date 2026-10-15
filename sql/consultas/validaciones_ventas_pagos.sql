-- Consulta 1: Validacion de Importes de Venta (Cabecera vs. Calculo de Detalles)
-- Objetivo: Comprobar que el monto_total declarado en la cabecera sea igual 
-- a la sumatoria fisica de (cantidad * precio) de cada item del detalle.

SELECT 
    vc.id_VentaCabecera,
    vc.created_at AS fecha_venta,
    vc.estado,
    vc.monto_total AS monto_cabecera,
    SUM(vd.cantidad * vd.precio) AS total_calculado_detalles,
    (vc.monto_total - SUM(vd.cantidad * vd.precio)) AS diferencia
FROM Venta_Cabecera vc
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
GROUP BY 
    vc.id_VentaCabecera, 
    vc.created_at, 
    vc.estado, 
    vc.monto_total
ORDER BY vc.id_VentaCabecera;
GO


-- Consulta 2: Conciliacion de Ventas vs. Pagos Registrados
-- Objetivo: Revisar el total pagado por venta, verificar el saldo restante
-- y controlar si coincide con el estado actual de la venta.

SELECT 
    vc.id_VentaCabecera,
    vc.monto_total AS importe_venta,
    vc.estado,
    ISNULL(SUM(p.monto), 0) AS total_pagado,
    (vc.monto_total - ISNULL(SUM(p.monto), 0)) AS saldo_pendiente,
    CASE 
        WHEN ISNULL(SUM(p.monto), 0) >= vc.monto_total THEN 'Cancelado / Cubierto'
        WHEN ISNULL(SUM(p.monto), 0) > 0 THEN 'Pago Parcial'
        ELSE 'Sin Pagos'
    END AS estado_pago_calculado
FROM Venta_Cabecera vc
LEFT JOIN Pago p 
    ON vc.id_VentaCabecera = p.id_VentaCabecera
GROUP BY 
    vc.id_VentaCabecera, 
    vc.monto_total, 
    vc.estado
ORDER BY vc.id_VentaCabecera;
GO


-- Consulta 3: Desglose Completo de Venta, Detalles y Metodos de Pago
-- Objetivo: Trazabilidad integral de una orden (items comprados y transacciones).

SELECT 
    vc.id_VentaCabecera,
    vc.created_at AS fecha_venta,
    vc.id_usuario,
    vd.id_variante_producto,
    vd.cantidad,
    vd.precio AS precio_unitario,
    (vd.cantidad * vd.precio) AS subtotal_item,
    mp.descripcion AS metodo_pago_utilizado,
    p.referencia AS ref_pago,
    p.monto AS monto_transaccion
FROM Venta_Cabecera vc
INNER JOIN Venta_Detalle vd 
    ON vc.id_VentaCabecera = vd.id_VentaCabecera
LEFT JOIN Pago p 
    ON vc.id_VentaCabecera = p.id_VentaCabecera
LEFT JOIN metodo_pago mp 
    ON p.id_metodo = mp.id_metodo
ORDER BY vc.id_VentaCabecera, vd.id_variante_producto;
GO


-- Consulta 4: Auditoria de Inconsistencias (Control de Calidad de Datos)
-- Objetivo: Listar unicamente aquellas ventas cuyo estado sea 'Pagada' o 
-- 'Completada' pero que no tengan el monto 100% cubierto en la tabla Pago.

SELECT 
    vc.id_VentaCabecera,
    vc.estado,
    vc.monto_total,
    ISNULL(SUM(p.monto), 0) AS total_abonado,
    (vc.monto_total - ISNULL(SUM(p.monto), 0)) AS faltante
FROM Venta_Cabecera vc
LEFT JOIN Pago p 
    ON vc.id_VentaCabecera = p.id_VentaCabecera
WHERE vc.estado IN ('Pagada', 'Completada')
GROUP BY 
    vc.id_VentaCabecera, 
    vc.estado, 
    vc.monto_total
HAVING (vc.monto_total - ISNULL(SUM(p.monto), 0)) > 0;
GO


-- Consulta 5: Resumen Financiero por Metodo de Pago (Participacion de Cobros)
-- Objetivo: Determinar que vias de cobro concentran el mayor flujo de dinero
-- y la cantidad de transacciones registradas.

SELECT 
    mp.id_metodo,
    mp.descripcion AS metodo_pago,
    COUNT(p.id_pago) AS cantidad_transacciones,
    ISNULL(SUM(p.monto), 0) AS total_recaudado,
    ISNULL(AVG(p.monto), 0) AS ticket_promedio_cobro
FROM metodo_pago mp
LEFT JOIN Pago p 
    ON mp.id_metodo = p.id_metodo
GROUP BY 
    mp.id_metodo, 
    mp.descripcion
ORDER BY total_recaudado DESC;
GO



-- Consulta 6: Ventas Mayores al Promedio General (Subconsulta)
-- Objetivo: Identificar compras de alto valor que superan la media global
-- facturada en el ecommerce.

SELECT 
    vc.id_VentaCabecera,
    vc.created_at,
    vc.id_usuario,
    vc.monto_total
FROM Venta_Cabecera vc
WHERE vc.monto_total > (
    SELECT AVG(monto_total) 
    FROM Venta_Cabecera 
    WHERE estado <> 'Cancelada'
)
ORDER BY vc.monto_total DESC;
GO



--  Consulta 7: Clientes con Ventas pero Sin Pagos Registrados (Control)
-- Objetivo: Localizar carritos/pedidos pendientes o en riesgo de abandono.

SELECT 
    vc.id_VentaCabecera,
    vc.created_at,
    vc.id_usuario,
    vc.monto_total,
    vc.estado
FROM Venta_Cabecera vc
WHERE NOT EXISTS (
    SELECT 1 
    FROM Pago p 
    WHERE p.id_VentaCabecera = vc.id_VentaCabecera
);
GO