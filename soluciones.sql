-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Marcos
-- Fecha: 25-08-2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- FROM productos (izquierda) asegura que TODOS los productos aparezcan,
-- tengan o no ventas asociadas. El filtro WHERE v.venta_id IS NULL aísla
-- justamente los productos que no encontraron ninguna coincidencia en ventas.
SELECT p.producto_id, p.nombre, p.categoria, v.venta_id, v.cantidad
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- FROM productos ... RIGHT JOIN ventas asegura que TODAS las ventas
-- aparezcan, incluso las que no encuentran producto_id coincidente
-- en productos. WHERE p.producto_id IS NULL aísla esos registros huérfanos.
SELECT v.venta_id, v.producto_id, v.cliente_id, v.cantidad, v.fecha_venta, p.nombre
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.
-- Combina el comportamiento de LEFT y RIGHT: nada se pierde de ninguna
-- de las dos tablas, y donde no hay coincidencia aparece NULL.
SELECT p.producto_id, p.nombre, v.venta_id, v.producto_id AS producto_id_venta, v.cantidad
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
ORDER BY p.producto_id, v.venta_id;
