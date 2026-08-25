# MiniStore — LEFT, RIGHT y FULL OUTER JOIN

Auditoría del catálogo de productos y el historial de ventas de MiniStore, usando uniones externas para detectar productos nunca vendidos y ventas con productos inexistentes en el catálogo.

## ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN?

Un `INNER JOIN` solo devuelve filas que tienen coincidencia en **ambas** tablas — por lo tanto, un producto que nunca fue vendido (sin ninguna fila coincidente en `ventas`) directamente desaparecería del resultado, no aparecería con `NULL`, sino que no aparecería en absoluto. Como la pregunta de negocio es justamente "¿qué productos **no** tienen ventas?", necesito que esos productos sigan visibles en el resultado. `LEFT JOIN` garantiza que todas las filas de `productos` (la tabla de la izquierda) aparezcan siempre, tengan o no coincidencia en `ventas`, completando con `NULL` las columnas de venta cuando no la hay. Con `INNER JOIN` habría perdido exactamente la información que buscaba: los productos 108 (Hub USB-C) y 109 (Parlante Bluetooth).

## ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha?

En mi consulta, `productos` está a la izquierda (`FROM productos p`) y `ventas` está a la derecha (`RIGHT JOIN ventas v`). Necesitaba asegurar que **todas** las ventas aparecieran en el resultado, incluso aquellas cuyo `producto_id` no existe en el catálogo — y `RIGHT JOIN` devuelve todas las filas de la tabla derecha (`ventas`) más las coincidencias de la izquierda. Así, la venta con `producto_id = 999` (que no existe en `productos`) queda visible con `NULL` en las columnas de producto, en vez de desaparecer como pasaría con un `INNER JOIN`.

## ¿Qué representan los valores NULL en cada resultado?

En la **Consulta 1**, un `venta_id` en `NULL` significa que ese producto del catálogo nunca apareció en ninguna venta — por ejemplo, el producto 108 (Hub USB-C 7p) tiene `venta_id = NULL` porque nunca fue vendido, no porque haya un error de datos.

En la **Consulta 2**, un `producto_id` de `productos` en `NULL` significa que esa venta hace referencia a un producto que no existe en el catálogo — la venta 10 tiene `producto_id = 999` en la tabla `ventas`, pero como ese ID no existe en `productos`, todas las columnas provenientes de `productos` (nombre, categoría, precio) quedan en `NULL`. Esto es una señal de un posible error de carga de datos (un producto que se dio de baja del catálogo pero cuyas ventas históricas quedaron registradas, o un ID mal tipeado al cargar la venta).

## ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?

Lo usaría en escenarios de **auditoría o validación de calidad de datos**, donde necesito ver el panorama completo de dos tablas relacionadas sin perder ninguna fila de ninguna de las dos, como en este mismo ejercicio: quiero ver a la vez los productos sin ventas y las ventas sin producto válido, en una sola consulta. También es útil al migrar datos entre sistemas, para detectar registros huérfanos en cualquiera de las dos direcciones antes de dar por buena una migración, o al conciliar dos fuentes de datos que deberían estar sincronizadas (por ejemplo, un sistema de inventario y un sistema de ventas) y quiero encontrar todas las discrepancias de una sola vez.
