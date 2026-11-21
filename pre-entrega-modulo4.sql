-- CONSULTA 1: RENTABILIDAD POR CATEGORIA
-- Permite identificar las categorias que generan mayores ingresos
-- para orientar decisiones comerciales y de inventario.
-- Umbral definido en 100000 porque permite excluir categorias
-- con ingresos bajos y concentrar el analisis en las mas relevantes.

SELECT
    c.nombre AS categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * v.precio_unitario) AS ingreso_total
FROM ventas AS v
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS c
    ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING SUM(v.cantidad * v.precio_unitario) > 100000
ORDER BY ingreso_total DESC;


-- CONSULTA 2: CLIENTES SIN COMPRAS
-- Permite identificar clientes registrados que todavia no compraron
-- para desarrollar campañas comerciales y fomentar su primera compra.

SELECT
    c.nombre,
    c.apellido,
    c.email,
    COALESCE(COUNT(v.id_venta), 0) AS total_compras
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido,
    c.email
HAVING COUNT(v.id_venta) = 0;


-- CONSULTA 3: TOP DE COMPRAS POR CLIENTE
-- Permite identificar el producto que cada cliente compra con mayor
-- frecuencia y la fecha de su ultima transaccion.
-- Esta informacion ayuda a conocer preferencias de consumo
-- y desarrollar estrategias comerciales personalizadas.

SELECT
    c.nombre,
    c.apellido,
    (
        SELECT p2.nombre
        FROM ventas AS v2
        INNER JOIN productos AS p2
            ON v2.id_producto = p2.id_producto
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY p2.id_producto, p2.nombre
        ORDER BY COUNT(*) DESC, p2.id_producto
        LIMIT 1
    ) AS producto_mas_comprado,
    MAX(v.fecha_venta) AS ultima_transaccion
FROM clientes AS c
INNER JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido
ORDER BY c.id_cliente;