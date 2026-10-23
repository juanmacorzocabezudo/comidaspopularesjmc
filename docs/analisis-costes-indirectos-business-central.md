# Requerimientos del módulo de costes indirectos / estructura

**Ámbito:** Catering e Industria de Comidas Populares. La elaboración de recetas se realiza mediante **pedidos de ensamblado**. Este documento define el desarrollo solicitado, tomando como base el Excel del CEO y las aclaraciones del 22/10/2026.

## 1. Objetivo y alcance

Calcular periódicamente la estructura por producto y centro de coste, comparar **dos métodos de reparto simultáneos**, simular cantidades y consultar su repercusión en recetas, eventos y movimientos de producto.

Se propone una primera versión **analítica y trazable**: añadir información de estructura sin modificar los importes estándar del inventario ni los precios de venta. Reflejar el coste en un movimiento analítico vinculado al movimiento de producto no equivale a modificar su valoración contable. La capitalización de estructura requerirá una aprobación y un alcance contable independientes.

## 2. Configuración y fuentes

- **Cuentas contables:** reutilizar la clasificación fijo/variable existente y añadir inclusión explícita en el modelo y destino **industrial** o **gestión adicional**. Seleccionar las cuentas de detalle de ocho dígitos utilizadas por la empresa.
- **Gasto neto:** movimientos contables del periodo menos costes directos ya imputados. Deducir de sueldos el personal operativo y de suministros el consumo de máquinas ya incorporado a los ensamblados, con reglas identificables por cuenta/recurso.
- **Producción:** costes de ensamblados registrados del periodo, sin la estructura que calcula el propio módulo; **CA = Catering**, **PT = Industria**. Los productos intermedios **PI** no deben duplicarse si su coste ya está contenido en el producto final.
- **Ventas:** cantidades netas de abonos por producto y unidad equivalente. «Contra ventas» significa **unidades vendidas**, no importe de facturación.
- **Receta:** coste unitario de la lista de materiales, con fecha y fuente guardadas. No utilizar un coste que incluya de nuevo la estructura del modelo.
- **Equivalencias y prioridades:** conversiones por producto entre ración, kg y formato comercial; niveles 1 a 5, inicialmente 1, con factores aprobados decrecientes. No inventar conversiones ni pesos.

Todos los datos deben corresponder al mismo periodo y alcance. Los gastos de gestión son adicionales al industrial: el coste completo no debe sumar dos veces el mismo gasto.

## 3. Reparto por centros de coste

Configurar centros y vincular a ellos gastos, recursos/máquinas y productos. Reutilizar los centros existentes en las dependencias CP si cubren esta necesidad; usar una dimensión configurable para identificar el centro en los movimientos, sin codificar un nombre fijo.

1. Asignar cada gasto al centro correspondiente. Los gastos comunes se distribuyen mediante porcentajes documentados que sumen el 100 %; lo no asignado queda visible.
2. Para una máquina, determinar los productos elegibles por su uso en recetas o recursos de ensamblados registrados. Conservar la fuente de esa relación; no basta con pertenecer a la misma familia.
3. Repartir la estructura del centro solo entre negocios y productos elegibles. Un producto que no utiliza esa máquina recibe **cero** de ese centro en ambos métodos, aunque tenga ventas.
4. Dentro del centro, ponderar Catering/Industria por su coste de ensamblado elegible; después aplicar los dos métodos a los productos correspondientes.
5. Si un producto usa varios centros, sumar sus asignaciones sin duplicar el gasto. No combinar centros con unidades no comparables sin equivalencias aprobadas.

**Ejemplo:** el mantenimiento del horno se reparte solo entre las recetas que pasan por él; no se carga a una receta fría. Administración puede pertenecer a un centro común con alcance más amplio.

## 4. Modelo de costes indirectos: dos métodos obligatorios

Crear una página con **cabecera por periodo/versión** y detalle por producto, centro y método. Debe mostrar origen contable, deducciones, gasto neto, unidades equivalentes, coste de receta, prioridad y los siguientes resultados en paralelo:

| Método | Base por producto |
| --- | --- |
| **Contra ventas** | Unidades vendidas netas equivalentes × factor de prioridad |
| **Contra receta** | Unidades vendidas netas equivalentes × coste unitario de receta × factor de prioridad |

Para cada centro, negocio y destino industrial/gestión:

`Importe asignado al producto = estructura del grupo × base del producto / suma de bases elegibles`

`Coste indirecto unitario = importe asignado / unidades vendidas netas equivalentes`

Cada método reparte **el mismo fondo de estructura de forma alternativa**. Nunca se suman sus resultados. Mostrar, para ambos, importe industrial, gestión adicional, estructura total, porcentaje sobre receta y **EXWORK = receta + industrial + gestión adicional**.

Una base total nula o negativa, equivalencias ausentes o residuales negativos debe generar una incidencia y bloquear la publicación del cálculo afectado. Los productos sin ventas quedan sin tasa calculable en estos métodos y se identifican como tales; no asignarles un cero ficticio. Conciliar gasto repartido más pendiente con gasto neto y distribuir los residuos de redondeo de forma trazable.

## 5. Simulador desde el modelo

Añadir la acción **Simular coste de estructura**:

- **Entradas:** versión calculada, producto, cantidad y unidad de medida; filtros de periodo de origen, negocio y centro de coste, con desglose industrial/gestión.
- **Cálculo:** convertir la cantidad a la unidad de la tasa y multiplicarla por los costes unitarios anteriores de ambos métodos.
- **Salidas:** coste indirecto unitario y total, desglose por centro, EXWORK y diferencia entre métodos, con versión y filtros utilizados.
- **Reglas:** no modificar modelos, productos ni movimientos. Los filtros seleccionan tasas existentes; **no redistribuyen todo el gasto sobre el subconjunto filtrado**. Una simulación con tasas distintas requiere calcular otra versión.

Ejemplo: si las tasas históricas son 0,30 €/ración contra ventas y 0,45 €/ración contra receta, simular 100 raciones devuelve 30 € y 45 € de estructura. Para 10 barquetas de 2,5 kg con tasa en €/kg, utilizar 25 kg. Si no existe tasa o equivalencia, informar del motivo y no presentar un resultado válido.

## 6. Cálculo periódico y publicación

**Recomendación: usar la cola de proyectos de BC**, con una tarea programada por empresa y periodicidad configurable:

1. Proponer cálculo **mensual**, después del cierre y ajuste de costes de los ensamblados; programación diaria opcional para borradores provisionales.
2. La tarea recoge fuentes del periodo, calcula ambos métodos y genera/actualiza un **borrador** con detalle e incidencias. También se podrá ejecutar manualmente desde el modelo.
3. Un responsable revisa y **publica** la versión, indicando vigencia de aplicación. La tarea no sustituye automáticamente los costes publicados.
4. Bloquear ejecuciones concurrentes del mismo periodo. Repetir una ejecución no debe duplicar importes ni alterar versiones publicadas.
5. Si llegan facturas o ajustes tardíos, crear una nueva versión para revisión. Mantener históricos, registro de ejecución y errores consultables; no modificar silenciosamente costes aplicados.

Ejemplo: cerrar septiembre, calcular y revisar su modelo y publicarlo con vigencia desde octubre. Evitar vigencias solapadas para un mismo negocio/centro; sin modelo vigente, dejar la imputación pendiente con aviso visible, no utilizar tasas de otro periodo sin autorización.

## 7. Dónde y cómo aplicar el coste

| Superficie | Requerimiento |
| --- | --- |
| **Ficha de producto y Recetas** | Mostrar ambas tasas vigentes, industrial/gestión, EXWORK, unidad, prioridad y versión. Acceso al desglose por centros y al histórico. Campos calculados o vinculados, no edición libre del resultado. |
| **Pedido de ensamblado** | Mostrar la estructura estimada para la cantidad del pedido con ambos métodos, separada del coste estándar de componentes y recursos. No añadir recursos que dupliquen costes. |
| **Movimientos de producto** | Crear movimientos analíticos JMC de estructura vinculados al número de movimiento estándar, producto, centro, método, cantidad, tasa, importe y versión. Consultarlos desde la página de movimientos. |
| **Catering / eventos** | Mostrar estructura por producto servido y total del evento con ambos métodos. Si el evento consume productos ya imputados, reutilizar su atribución; no volver a cargar la misma estructura. |

Para los movimientos se propone aplicar las tasas publicadas a **salidas por venta y entradas de producto terminado por ensamblado** según su fecha de registro. Distinguir fabricación y venta como vistas de análisis: no sumar ambas como dos gastos del mismo producto. Un movimiento con varios centros tendrá detalle por centro y método.

Guardar la tasa aplicada y sus referencias al registrar; un cambio posterior del modelo no altera el histórico. Para abonos/correcciones vinculados, revertir proporcionalmente la imputación original y su tasa; cualquier regularización histórica debe ser explícita y conservar el origen. La carga inicial de movimientos anteriores se hará mediante una acción controlada, sin duplicados.

**Límite contable:** no escribir en el coste unitario estándar, modificar movimientos de valor ni generar asientos automáticamente. Si se decide capitalizar parte de la estructura industrial, diseñar su registro estándar según el método de valoración antes de ampliar este alcance; gestión no se capitaliza por defecto.

## 8. Entregables y aceptación

**Desarrollo:** configuración de centros y deducciones; cabecera/detalle del modelo y versiones; cálculo manual/programado; simulador; extensión de producto/Recetas y documentos; movimientos analíticos y consulta de conciliación.

**Validación mínima:**

- Ambos métodos concilian por separado con el mismo fondo; nunca se suman entre sí.
- La máquina solo repercute en productos elegibles; se excluyen duplicados de personal, suministros y PI.
- Simulador, equivalencias y redondeos reproducen los resultados de prueba.
- La cola deja borradores revisables, registra errores y no altera versiones publicadas.
- Producto, receta y movimientos permiten consultar tasas, centros y versión de origen; correcciones revierten sin duplicar.
- La aplicación analítica no cambia inventario ni precios. Comparar informes de fabricación y venta no duplica estructura.

**Pendiente de aprobación antes de desarrollar:** factores de prioridad, dimensión y relación de centros, fecha/fuente del coste de receta y calendario de cierre. La periodicidad mensual y la aplicación analítica a movimientos son las recomendaciones de este documento. Las amortizaciones específicas siguen fuera de esta fase.

## Referencias

- [Excel del CEO](../../Costes%20de%20estructura.xlsx). Usar sus reglas de negocio, no copiar las fórmulas ilustrativas que igualan el fondo de estructura al coste total de receta.
- Código existente: [cuentas](../src/tableext/JMCGLAccount.tableext.al), [recursos](../src/tableext/JMCResource.tableext.al), [costes de receta](../src/page/JMCCPBOMAditionalCost.page.al) y [Recetas](../src/pageext/JMCReceta.pageext.al). Validar las integraciones CP antes de reutilizarlas; no se presupone su contabilización interna.
