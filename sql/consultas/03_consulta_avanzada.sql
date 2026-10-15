
USE EcommerceInd;
GO

-- Consulta de negocio avanzada:
-- Identificar variantes de productos con stock bajo cuyo precio unitario supere el promedio del catalogo.
-- Se utilizan INNER JOIN y una subconsulta con AVG().

SELECT
    p.id_producto,
    p.nombre AS producto,
    t.nombre AS talle,
    c.nombre AS color,
    vp.stock,
    p.precio_unitario,
    (
        SELECT AVG(precio_unitario)
        FROM Producto
    ) AS precio_promedio_catalogo
FROM Producto AS p
INNER JOIN Variante_Producto AS vp
    ON p.id_producto = vp.id_producto
INNER JOIN Talle AS t
    ON vp.id_talle = t.id_talle
INNER JOIN Color AS c
    ON vp.id_color = c.id_color
WHERE vp.stock <= 15
  AND p.precio_unitario > (
      SELECT AVG(precio_unitario)
      FROM Producto
  )
ORDER BY
    vp.stock ASC,
    p.precio_unitario DESC;
GO
