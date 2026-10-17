USE EcommerceInd;
GO

-- =========================================================================
-- Detalle de compras por proveedor
-- Objetivo: Consultar cada renglón de reposición con su proveedor, producto,
-- variante, cantidad e importe. Se excluyen las compras canceladas.
-- =========================================================================

SELECT
    c.id_compra,
    c.fecha_compra,
    c.estado AS estado_compra,
    pr.id_proveedor,
    pr.nombre AS proveedor,
    p.nombre AS producto,
    t.nombre AS talle,
    co.nombre AS color,
    dc.cantidad,
    dc.precio_unitario,
    dc.cantidad * dc.precio_unitario AS importe_reposicion
FROM Compra c
INNER JOIN Proveedor pr
    ON c.id_proveedor = pr.id_proveedor
INNER JOIN Detalle_Compra dc
    ON c.id_compra = dc.id_compra
INNER JOIN Variante_Producto vp
    ON dc.id_variante_producto = vp.id_variante_producto
INNER JOIN Producto p
    ON vp.id_producto = p.id_producto
INNER JOIN Talle t
    ON vp.id_talle = t.id_talle
INNER JOIN Color co
    ON vp.id_color = co.id_color
WHERE c.estado <> 'Cancelada'
ORDER BY c.fecha_compra DESC, c.id_compra, dc.id_DetalleCompra;
GO

-- =========================================================================
-- Resumen de cantidades e importes por proveedor
-- Objetivo: Comparar el volumen y costo de reposición asociado a cada
-- proveedor. Se incluyen proveedores sin compras no canceladas.
-- =========================================================================

SELECT
    pr.id_proveedor,
    pr.nombre AS proveedor,
    COUNT(DISTINCT c.id_compra) AS cantidad_compras,
    COALESCE(SUM(dc.cantidad), 0) AS unidades_repuestas,
    COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) AS importe_reposicion
FROM Proveedor pr
LEFT JOIN Compra c
    ON pr.id_proveedor = c.id_proveedor
   AND c.estado <> 'Cancelada'
LEFT JOIN Detalle_Compra dc
    ON c.id_compra = dc.id_compra
GROUP BY pr.id_proveedor, pr.nombre
ORDER BY importe_reposicion DESC, pr.nombre;
GO

-- =========================================================================
-- Reposición por proveedor y variante
-- Objetivo: Identificar qué productos, talles y colores se reponen por
-- proveedor, con cantidades, importes y stock actual como referencia.
-- =========================================================================

SELECT
    pr.id_proveedor,
    pr.nombre AS proveedor,
    p.id_producto,
    p.nombre AS producto,
    vp.id_variante_producto,
    t.nombre AS talle,
    co.nombre AS color,
    vp.stock AS stock_actual,
    COUNT(DISTINCT c.id_compra) AS cantidad_compras,
    SUM(dc.cantidad) AS unidades_repuestas,
    SUM(dc.cantidad * dc.precio_unitario) AS importe_reposicion
FROM Compra c
INNER JOIN Proveedor pr
    ON c.id_proveedor = pr.id_proveedor
INNER JOIN Detalle_Compra dc
    ON c.id_compra = dc.id_compra
INNER JOIN Variante_Producto vp
    ON dc.id_variante_producto = vp.id_variante_producto
INNER JOIN Producto p
    ON vp.id_producto = p.id_producto
INNER JOIN Talle t
    ON vp.id_talle = t.id_talle
INNER JOIN Color co
    ON vp.id_color = co.id_color
WHERE c.estado <> 'Cancelada'
GROUP BY
    pr.id_proveedor,
    pr.nombre,
    p.id_producto,
    p.nombre,
    vp.id_variante_producto,
    t.nombre,
    co.nombre,
    vp.stock
ORDER BY importe_reposicion DESC, proveedor, producto;
GO