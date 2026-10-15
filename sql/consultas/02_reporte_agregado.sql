USE EcommerceInd;
GO


SELECT 
    c.id_categoria,
    c.descripcion AS categoria,
    COUNT(DISTINCT vc.id_venta_cabecera) AS cantidad_ventas,
    SUM(vd.cantidad) AS total_unidades_vendidas,
    SUM(vd.cantidad * vd.precio) AS importe_total_vendido
FROM Categoria c
INNER JOIN Producto p 
    ON c.id_categoria = p.id_categoria
INNER JOIN Variante_Producto vp 
    ON p.id_producto = vp.id_producto
INNER JOIN Venta_Detalle vd 
    ON vp.id_variante_producto = vd.id_variante_producto
INNER JOIN Venta_Cabecera vc 
    ON vd.id_venta_cabecera = vc.id_venta_cabecera
WHERE vc.created_at BETWEEN '2023-01-01 00:00:00' AND '2023-12-31 23:59:59'
  AND vc.estado = 'Completada' -- Filtro opcional de ventas válidas
GROUP BY 
    c.id_categoria,
    c.descripcion
ORDER BY 
    importe_total_vendido DESC;
GO