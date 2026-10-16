USE EcommerceInd;
GO

-- =========================================================================
-- Ranking de Mejores Clientes (Fidelización)
-- Objetivo: Identificar a los usuarios con mayor volumen de compra 
-- histórico para incluirlos en campañas de marketing o descuentos.
-- =========================================================================

SELECT TOP 10
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email,
    COUNT(vc.id_VentaCabecera) AS cantidad_pedidos,
    SUM(vc.monto_total) AS total_gastado,
    AVG(vc.monto_total) AS ticket_promedio_usuario
FROM Usuario u
INNER JOIN Venta_Cabecera vc 
    ON u.id_usuario = vc.id_usuario
WHERE vc.estado IN ('Completada', 'Pagada', 'Enviada')
GROUP BY 
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email
HAVING SUM(vc.monto_total) > 50000 -- Umbral de gasto mínimo (podés ajustarlo)
ORDER BY 
    total_gastado DESC;
GO

-- =========================================================================
-- Distribución Geográfica de Ingresos (Logística y Ventas)
-- Objetivo: Identificar desde qué provincias y ciudades provienen las ventas 
-- para negociar envíos y dirigir publicidad.
-- =========================================================================

SELECT 
    d.provincia,
    d.ciudad,
    COUNT(DISTINCT vc.id_VentaCabecera) AS cantidad_pedidos_zona,
    SUM(vc.monto_total) AS ingresos_por_zona
FROM Venta_Cabecera vc
INNER JOIN Usuario u 
    ON vc.id_usuario = u.id_usuario
INNER JOIN Direccion d 
    ON u.id_direccion = d.id_direccion
WHERE vc.estado NOT IN ('Cancelada')
GROUP BY 
    d.provincia, 
    d.ciudad
ORDER BY 
    ingresos_por_zona DESC;
GO