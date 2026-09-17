# Gestor de incidencias de proveedor

El gestor registra incidencias de calidad relacionadas con productos de pedidos de compra o componentes de pedidos de ensamblado. Permite documentar su seguimiento, consultar las incidencias por documento o proveedor y vincularlas a un abono de compra.

## Configuración previa

En **Configuración de compras y pagos**, informe el campo **Nº serie incidencias proveedor**. La aplicación usa esta serie para asignar automáticamente el número de cada nueva incidencia.

## Crear una incidencia

1. Abra un **Pedido de compra** o un **Pedido de ensamblado**.
2. Seleccione **Acciones > Proceso > Crear incidencia**.
3. Elija la línea de producto o componente afectada y confírmela.
4. Se crea y abre la ficha de la incidencia con fecha, proveedor, producto, documento de origen y línea rellenados automáticamente.
5. Complete los datos necesarios: lote, detectado por, recurrencia, NC asociada, descripción, comunicaciones, respuesta y medidas correctivas.

Si el documento no contiene líneas de producto, no se podrá crear la incidencia.

## Consulta e impresión

La página **Lista incidencias** muestra todas las incidencias y permite filtrar por fecha, proveedor, producto, documento de origen, detectado por, recurrencia y abono registrado.

- Desde un pedido, use **Ver incidencias** para abrir la misma lista filtrada por ese documento.
- Desde la ficha de proveedor se muestra un panel con sus incidencias.
- Use **Imprimir incidencias** desde la lista para generar el informe con los filtros activos. El informe incluye fecha, proveedor, persona que detectó la incidencia, recurrencia, NC, descripción, comunicaciones, respuesta y medidas correctivas.

## Documentos adjuntos

El FactBox **Documentos adjuntos** aparece tanto en la ficha como en la lista de incidencias. En el listado muestra los documentos de la incidencia seleccionada.

Desde el FactBox puede añadir varios archivos, verlos, descargarlos o eliminarlos. Cada archivo queda vinculado al número de la incidencia desde la que se carga.

## Abonos de compra

En un **Abono de compra**, seleccione la **Incidencia relacionada**. El selector muestra únicamente incidencias del mismo proveedor con la información disponible en la lista de incidencias.

El código de la incidencia se traspasa al histórico y se muestra en **Abono compra registrado**. El campo **Abono registrado** de la incidencia se marca automáticamente al registrar el abono y no se puede modificar manualmente.