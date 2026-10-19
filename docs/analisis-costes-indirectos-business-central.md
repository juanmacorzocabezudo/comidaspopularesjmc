# Costes indirectos en Business Central: análisis y propuesta para Comidas Populares

## Resumen

Business Central ofrece mecanismos distintos según se quiera valorar inventario, cargar costes reales de compra o analizar rentabilidad. No hay un reparto automático universal de los gastos generales entre productos.

Para Comidas Populares se recomienda mantener **dos circuitos relacionados, pero distintos**:

1. **Catering:** imputar gastos indirectos al evento y, si interesa, distribuirlos entre los menús/productos servidos para conocer su rentabilidad. No cambiar con ello el coste de inventario de artículos que no se están fabricando para stock.
2. **Recetas elaboradas mediante pedidos de ensamblado:** incluir materiales y recursos en el coste de ensamblado, y añadir la absorción de gastos generales mediante líneas de recurso calculadas para cada pedido. Registrar el ensamblado por el flujo estándar para que el coste llegue al producto terminado.

El coste adicional de receta CP existente sirve para presentar costes y márgenes calculados, pero el código local no demuestra que contabilice esos importes en el inventario. La personalización propuesta debe conservar la trazabilidad entre el coste calculado, el documento de origen y el efecto contable.

## 1. Análisis breve del estándar y de la solución actual

### Estándar de Business Central

- Los campos **% de coste indirecto (Indirect Cost %)** y **Tasa de gastos generales (Overhead Rate)** forman parte del cálculo de costes estándar. Su aplicación depende del elemento de coste y de la configuración del artículo, recurso o centro de trabajo.
- Los **cargos de producto (Item Charges)** sirven para distribuir costes reales de adquisición —por ejemplo, transporte, aduanas y seguro— entre productos o recepciones. Pueden incrementar el valor de inventario y, posteriormente, el coste de los productos vendidos.
- **Excepción:** si el artículo utiliza el método de coste **Estándar (Standard)**, un cargo de producto no modifica el coste unitario estándar; se registra como variación de compra.
- Un gasto contabilizado en una cuenta del libro mayor no se asigna automáticamente a las existencias ni a un evento. La empresa debe definir la base de reparto y el proceso.
- Los pedidos de ensamblado pueden usar componentes y recursos. Su contabilización estándar traslada el coste de los componentes/recursos al artículo ensamblado; no es el mismo proceso de WIP que una orden de producción.

### Lo que muestra el código CP-JMC Base

- [JMC CP BOM Aditional Cost](../src/page/JMCCPBOMAditionalCost.page.al) muestra costes fijos y de producto, coste EXWORK (coste en fábrica) y beneficio. Los cálculos se delegan a `AlxiaAssemblyInfoManagement`, de una dependencia.
- La integración JMC prevista en [JMC Receta](../src/pageext/JMCReceta.pageext.al) está comentada; el botón JMC **Coste adicional** no ejecuta una acción.
- Las extensiones de ficha/lista calculan costes de existencias y de compra, pero no suman explícitamente los costes adicionales de receta.

Por tanto, la personalización debe verificar primero en el entorno qué hace la página **Costes Generales** provista por la dependencia y no tratar su coste calculado como coste contabilizado hasta probar el flujo.

## 2. Propuesta funcional

### 2.1 Configuración común de conceptos y tasas

Crear una configuración JMC de **conceptos de coste indirecto**, separada de los movimientos contabilizados. Como mínimo, cada concepto debería indicar:

- código, descripción, estado y vigencia;
- ámbito: **Catering**, **Ensamblado** o ambos;
- clase: **fijo por evento/pedido**, **por comensal**, **por unidad ensamblada**, **por hora/recurso** o **porcentaje**;
- base del porcentaje (por ejemplo, coste directo de materiales o coste directo de recursos), evitando bases ambiguas;
- unidad de medida y coste/tasa;
- criterio de distribución cuando el gasto se comparte entre varios productos;
- cuenta contable o recurso asociado, cuando el importe vaya a formar parte del coste contabilizado.

Permitir vigencias para actualizar tasas futuras sin alterar los cálculos históricos. Las tasas porcentuales deben definir explícitamente qué costes incluye su base y evitar el doble cómputo de conceptos ya incluidos en el coste directo.

### 2.2 Catering: coste indirecto del evento y del menú servido

La entidad de imputación principal debe ser el **evento**, porque preparación, transporte, montaje, limpieza y coordinación suelen beneficiar al servicio completo, no a una unidad de inventario.

1. Registrar o importar el coste real del evento desde las líneas de recursos, compras/facturas u otras fuentes configuradas.
2. Asociar el coste al número de evento y conservar la referencia al documento origen.
3. Repartir el coste común usando un criterio definido por concepto: importe fijo por evento, comensales, unidades servidas, horas de recurso o porcentaje del coste directo.
4. Si el evento incluye varios productos/menús, asignarles su parte y calcular margen por producto y por evento.
5. Mostrar coste directo, coste indirecto asignado, coste total y margen en consultas del evento y, si procede, en las líneas comerciales.

**Recomendación contable:** tratar este reparto como analítico para medir rentabilidad del catering; no incrementar el coste de inventario de los productos por el mero hecho de servirlos en un evento. Para fletes u otros costes reales de compra ligados a existencias, usar Item Charges en el circuito de compras.

### 2.3 Recetas: coste indirecto en pedidos de ensamblado

Usar el pedido de ensamblado como documento que concreta la producción y permite ligar cantidades reales, producto terminado y costes:

1. Mantener ingredientes y consumibles como componentes de la lista de materiales de ensamblado.
2. Representar la mano de obra o servicios medibles con **recursos** en la lista de materiales o en el pedido; capturar cantidades/horas cuando existan datos fiables.
3. Para gastos generales de cocina compartidos —energía, uso de instalaciones u otros— calcular el importe del pedido según una regla aprobada: por unidad producida, por lote, por hora o porcentaje de una base explícita.
4. Añadir al pedido las líneas de recurso que correspondan antes de registrar el ensamblado, distribuyendo costes fijos del lote entre la cantidad terminada cuando proceda.
5. Registrar el pedido por el proceso estándar. El coste de salida del producto debe incluir los componentes y recursos aplicables; contrastar el resultado en movimientos de producto, movimientos de valor y valoración.
6. Guardar en las líneas creadas el código de concepto y la tasa aplicada, para poder explicar y auditar el importe.

La personalización no debe escribir directamente en el coste unitario del artículo ni crear ajustes de inventario manuales sin una contabilización estándar. Si un importe solo sirve para rentabilidad y no debe capitalizarse, mostrarlo como **coste analítico no inventariable** y mantenerlo separado.

## 3. Diseño técnico recomendado

Mantener el diseño pequeño y trazable:

- **Configuración de coste indirecto:** concepto, ámbito, tipo de cálculo, base, tasa, vigencia y recurso/cuenta asociado.
- **Imputación de coste:** evento o pedido de ensamblado, producto, concepto, cantidad/base, tasa, importe, documento origen y estado.
- **Procesador de cálculo:** obtiene la base real del evento o pedido, calcula el importe y valida que no se haya aplicado ya.
- **Integración de catering:** calcula y consulta el reparto por evento/producto sin alterar inventario.
- **Integración de ensamblado:** propone líneas de recurso en el pedido antes del registro; el usuario revisa y contabiliza con el flujo estándar.
- **Consulta de rentabilidad:** muestra costes directos e indirectos por separado, total, margen y referencias origen.

Las tasas deben copiarse a cada imputación al calcularla. Así, un cambio de configuración no reescribe eventos ni ensamblados históricos. Debe existir control de duplicados, redondeo, reejecución y cancelación; toda modificación posterior al registro debe seguir el mecanismo estándar de corrección, no editar silenciosamente los movimientos contabilizados.

## 4. Alcance y fases sugeridas

**Fase 1 — Validación funcional:** identificar los conceptos de coste, asignar cada uno a catering o ensamblado, acordar bases/tasas y comprobar el método de coste de los artículos. Probar con una receta y un evento representativos.

**Fase 2 — Catering analítico:** imputar costes al evento y distribuirlos a productos/menús con informes de margen. Esta fase no cambia la valoración del inventario.

**Fase 3 — Coste de ensamblado contabilizado:** configurar recursos y calcular líneas para los pedidos de ensamblado. Validar cuidadosamente el resultado contable e inventariable antes de desplegarlo.

**Fase 4 — Integración de compras:** normalizar el uso de Item Charges para transporte, aduanas y costes de compra atribuibles a recepciones, con pruebas específicas para artículos de coste estándar.

## 5. Pruebas de aceptación

- Un evento distribuye el coste común según la base configurada; el total asignado coincide con el coste del evento y no duplica líneas origen.
- La consulta muestra margen del evento y de sus productos/menús, y distingue importes analíticos de costes inventariables.
- Un pedido de ensamblado incorpora materiales y recursos esperados; el importe indirecto, cantidad terminada y coste unitario resultante son trazables.
- Registrar, ajustar y conciliar el ensamblado no genera diferencias inesperadas entre valoración de inventario y libro mayor.
- Una repetición del cálculo no duplica costes; la modificación de tasas solo afecta a nuevos cálculos.
- Un Item Charge de compra actualiza el coste según el método de valoración y, para el método estándar, produce la variación esperada sin modificar el estándar.

## 6. Supuestos y fuentes

La propuesta se basa en el código local CP-JMC Base y en la documentación estándar de Business Central. No se dispone aquí del código de **CP - Functionality** ni de la implementación completa de la página externa de costes de receta. Antes de construir, hay que confirmar en el entorno qué campos, cálculos y contabilizaciones realiza esa dependencia y validar la política de capitalización con el responsable financiero.

Documentación oficial:

- [Costes de compra adicionales y cargos de producto](https://learn.microsoft.com/en-us/dynamics365/business-central/payables-how-assign-item-charges)
- [Cálculo del coste estándar](https://learn.microsoft.com/en-us/dynamics365/business-central/finance-about-calculating-standard-cost)
- [Métodos de coste](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-costing-methods)
- [Ajuste de costes de inventario](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-cost-adjustment)
- [Registro de órdenes de producción](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-production-order-posting)

Código revisado:

- [JMC CP BOM Aditional Cost](../src/page/JMCCPBOMAditionalCost.page.al)
- [JMC Receta](../src/pageext/JMCReceta.pageext.al)
- [JMC Assembly Order](../src/pageext/JMCAssemblyOrder.pageext.al)
- [JMC Item Card](../src/pageext/JMCItemCard.pageext.al)
- [JMC Item List](../src/pageext/JMCItemList.pageext.al)
- [JMC Item](../src/tableext/JMCItem.tableext.al)
- [app.json](../app.json)
