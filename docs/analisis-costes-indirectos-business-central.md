# Análisis de costes indirectos y su repercusión en productos

## 1. Resumen ejecutivo

Business Central no tiene un único mecanismo universal llamado «coste indirecto» que permita introducir cualquier gasto general y lo reparta automáticamente entre todos los productos. El mecanismo depende de qué representa el coste y del método de reposición y valoración del artículo:

| Necesidad | Mecanismo estándar más apropiado | ¿Aumenta el coste/valor del producto? |
| --- | --- | --- |
| Repartir costes de fabricación o montaje en el coste unitario previsto | Campos **Indirect Cost %** y **Overhead Rate** del artículo, recurso o centro de trabajo, según el elemento del coste; después calcular y mantener los costes estándar | Sí, dentro del cálculo del coste estándar y del coste de producción o montaje, de acuerdo con el setup. |
| Incorporar flete, aduanas, seguro o manipulación de una compra a los artículos concretos recibidos | **Item Charges** en documentos de compra, asignados a líneas de producto/recepciones | Normalmente sí, como coste de inventario y coste de ventas posterior. **Excepción importante:** para artículos con método **Standard**, el cargo no modifica el coste unitario estándar y se registra como variación de compra. |
| Registrar alquiler, administración u otro gasto general no trazable a una recepción o consumo concreto | Contabilizar como gasto según la política contable y, si se necesita atribución gerencial, definir una política de reparto/costeo | No se asigna automáticamente a unidades de inventario solo por contabilizar el gasto en una cuenta de mayor. |
| Mostrar una estimación de coste general en la ficha de una receta CP | Costes generales/adicionales de **BOM Aditional Cost** de CP - Functionality, presentados por la página JMC | La página local calcula EXWORK y beneficio estimados. El código local no demuestra que esto actualice el coste unitario estándar ni los movimientos de valoración. |

**Conclusión para Comidas Populares:** hay que decidir primero si se busca (1) valorar cada unidad producida con un coste estándar integral, (2) absorber un coste real ligado a una compra o lote recibido, o (3) analizar rentabilidad incluyendo gastos generales. No son resultados equivalentes y no deben confundirse.

## 2. Qué significa «repercutir en el producto»

Conviene separar cuatro conceptos:

1. **Coste previsto/estándar:** coste objetivo de una unidad. Puede componerse de materiales, capacidad, subcontratación y gastos generales. Los costes reales se comparan con esta referencia y las diferencias se analizan como variaciones.
2. **Coste de inventario real:** valor contabilizado de las entradas de inventario con el método de valoración elegido. Un cargo asignado a una recepción puede elevar ese valor.
3. **Coste de ventas (COGS):** coste que se reconoce al vender el artículo. Business Central propaga los costes ajustables de las entradas a las salidas según el método de valoración y la aplicación de movimientos.
4. **Coste de rentabilidad/gestión:** coste analítico que sirve para calcular un margen aunque no modifique el mayor de inventario ni el coste registrado de la unidad.

Que un importe aparezca en un cálculo de receta o de beneficio no demuestra por sí mismo que haya sido capitalizado como existencias, transferido al coste de ventas ni contabilizado en el mayor.

## 3. Mecanismos del estándar de Business Central

### 3.1 Método de valoración del artículo

En la ficha del artículo, el campo **Costing Method** determina cómo se valora el inventario y cómo fluye el coste:

- **FIFO:** coste real de las entradas, aplicando primero las más antiguas.
- **Average:** coste promedio ponderado por el periodo y el alcance configurados.
- **Specific:** coste concreto de la unidad identificada.
- **Standard:** coste unitario presupuestado/preestablecido; el coste real se compara con él y las diferencias se registran como variaciones.
- **LIFO:** aparece entre los métodos documentados por BC, pero no está permitido en muchas jurisdicciones; hay que validar su idoneidad legal y fiscal antes de considerarlo.

La elección no es cosmética: cambia el efecto de una compra, de un cargo asignado y de los ajustes sobre existencias y coste de ventas. Microsoft indica que no se puede cambiar libremente el método una vez que existen movimientos del artículo.

### 3.2 Coste indirecto porcentual y tasa fija de gastos generales

Para los costes estándar, BC contempla componentes directos e indirectos. Según el origen, la configuración relevante está en:

- **Artículo:** coste estándar, porcentaje de coste indirecto (**Indirect Cost %**) y tasa fija de gastos generales (**Overhead Rate**) cuando corresponda.
- **Recurso de montaje:** costes de capacidad asociados al recurso.
- **Centro de trabajo o máquina de producción:** coste directo por capacidad y componentes indirectos/fijos asociados a las operaciones de la ruta.
- **Subcontratación:** costes directos e indirectos configurados para el centro de trabajo que representa la operación subcontratada.
- **BOM/receta y ruta:** cantidades de materiales y consumibles, operaciones, tiempos y lotes que alimentan el cálculo del producto terminado.

En términos operativos, el porcentaje aplica sobre la base de coste que determina el cálculo estándar y la tasa fija añade el importe fijo previsto por unidad. La base concreta depende del componente y de la configuración; no debe asumirse que el porcentaje se aplica siempre solo al coste de compra directo.

El ejemplo oficial de Microsoft para un producto fabricado ilustra la composición:

- Material directo: 20
- Material no inventariable: 12
- Capacidad: 27
- Subcontratación: 7
- Gastos generales de capacidad: 2
- Gastos generales de fabricación: 10 % de los componentes incluidos en su base, más una tasa fija de 3; en ese ejemplo son 9,80
- **Coste estándar total: 77,80**

Es un ejemplo de fabricación y no una fórmula universal para todas las fichas, métodos de reposición o configuraciones.

### 3.3 Cálculo y mantenimiento de costes estándar

La práctica estándar consiste en configurar los componentes, calcular/revisar el coste propuesto (por ejemplo, con las herramientas de costes estándar y el análisis de componentes del BOM) y actualizar el coste estándar deliberadamente. El cálculo de componentes de un producto terminado puede incluir subensamblados y costes de distintos niveles.

El coste estándar se mantiene como una referencia. Una compra o una producción real más cara o más barata no implica que cada contabilización reescriba automáticamente el estándar; la diferencia se analiza como variación, de acuerdo con el método y el flujo de registro. Para productos ensamblados o fabricados, los costes y variaciones se reflejan a través del proceso de contabilización correspondiente.

### 3.4 Item Charges: coste real de compra asignable

Los **Item Charges** están diseñados para añadir costes comerciales directamente relacionados con artículos o recepciones, por ejemplo:

- transporte/flete de entrada;
- aranceles y aduanas;
- seguro;
- manipulación.

Se crean códigos de cargo con su configuración contable y se añaden a una factura u otro documento de compra como tipo **Charge (Item)**. Desde **Item Charge Assignment**, el importe puede distribuirse entre las líneas de artículos relacionadas —por ejemplo, por cantidad, importe, peso o volumen, según las opciones disponibles—:

1. En el mismo documento que contiene los artículos, antes de registrarlo; o
2. En una factura separada, vinculando el cargo a una recepción de compra ya registrada.

Al registrar, BC añade el importe como una **Value Entry** relacionada con el movimiento de inventario original; no necesita crear otro movimiento de artículo. La valoración y el coste de ventas se ajustan según el método de coste y la aplicación de movimientos.

**Excepción para coste estándar:** Microsoft documenta que asignar un Item Charge a un artículo con método **Standard** no cambia su coste unitario estándar. El cargo se contabiliza como variación de compra porque el estándar permanece fijo. Por eso, para este método, un cargo real de transporte no debe interpretarse como una actualización automática del unit cost.

Los cargos de salida asignados a envíos de venta pueden ser no inventariables: se registran para análisis de coste/rentabilidad, pero no aumentan el valor de las existencias.

### 3.5 Ajuste de costes

El proceso **Adjust Cost – Item Entries** propaga ajustes de coste desde las entradas origen hasta las salidas relacionadas y actualiza el coste de ventas cuando corresponde. BC requiere ajustar los costes antes de conciliar correctamente los movimientos de valor con el mayor. En Average, además, el coste promedio depende del periodo y del alcance de cálculo establecidos.

Por consiguiente, el efecto final de un cargo en productos ya vendidos puede requerir el ajuste de costes y la contabilización/conciliación correspondiente; no es necesariamente un cambio aislado del campo de coste que se vea de inmediato en una ficha.

## 4. Diferencia entre montaje y fabricación

- **Montaje:** combina componentes y, cuando corresponde, recursos. Su flujo de coste es más sencillo y no utiliza el mismo ciclo de inventario WIP de una orden de producción.
- **Producción:** consume materiales, capacidad y potencialmente subcontratación; acumula costes en WIP y los transfiere a producto terminado al completar la orden. Las variaciones y el ajuste de costes son parte del flujo.

Por ello, una receta CP basada en **Assembly BOM** no equivale sin más a una **Production BOM + Routing** de fabricación. Si Comidas Populares necesita absorber tiempo de mano de obra o costes de cocina/centro productivo al producto fabricado, hay que validar primero qué mecanismo de montaje/producción utiliza realmente cada artículo y si el dato se registra en el proceso estándar o solo se calcula para análisis.

## 5. Dónde se mantienen en Business Central

Los nombres exactos de acciones pueden variar según la versión, perfil y localización, pero el recorrido estándar es:

### Coste estándar / indirecto de material

1. Buscar **Items** y abrir la ficha del artículo.
2. Revisar **Costing Method**, **Standard Cost**, **Indirect Cost %** y **Overhead Rate** en los campos/secciones de costes de la ficha.
3. Para artículos ensamblados/fabricados, revisar también la **Assembly BOM** o **Production BOM**, la ruta (si aplica), los recursos/centros de trabajo y sus costes.
4. Calcular y revisar el coste propuesto con las hojas/funciones de coste estándar y, una vez validado, aplicar el nuevo estándar.

### Coste real de compra ligado al producto

1. Preparar la factura de compra con la línea de cargo **Charge (Item)**.
2. Abrir **Item Charge Assignment** y asignar el importe a líneas de artículo/recepción concretas.
3. Registrar el documento y, si procede, ejecutar el ajuste de costes y revisar los movimientos de valor.

El cargo puede venir en la factura original de compra o llegar después, en una factura separada del transportista u otro proveedor.

### Gastos generales no ligados a productos concretos

Un asiento de gasto normal a una cuenta de mayor registra el gasto financiero, pero no crea por sí mismo una asignación a cada unidad de inventario. Si se quiere incorporar a coste de producto, hace falta definir una política de absorción (por ejemplo, una tasa de capacidad/fabricación) y configurar/ejecutar el proceso que la materialice. Si solo se requiere rentabilidad de gestión, puede conservarse como coste analítico sin modificar la valoración inventariable.

## 6. Qué demuestra el código CP-JMC Base

### 6.1 Costes de receta CP

La página [JMC CP BOM Aditional Cost](../src/page/JMCCPBOMAditionalCost.page.al) muestra líneas de la tabla externa **BOM Aditional Cost**, que dispone de campos como artículo, versión de BOM, tipo, valor y opciones de aplicación. En la pantalla se muestran:

- coste de BOM/receta «fijado» y costes generales fijos;
- coste de BOM/receta calculado para el producto y costes generales de producto;
- coste EXWORK resultante y beneficio/porcentaje de beneficio estimados.

Las expresiones locales suman los costes generales al coste de receta para presentar el EXWORK y restan ese importe del precio unitario para estimar el beneficio. El porcentaje que calcula el código usa el coste como denominador; por tanto, es un **recargo sobre coste**, no un margen sobre ventas.

La implementación de los cálculos se delega a `AlxiaAssemblyInfoManagement`, de CP - Functionality. Este código local permite confirmar qué resultados expone la página, pero no la fórmula completa que aplica la dependencia ni si lleva los datos a Value Entries, Unit Cost o al mayor.

### 6.2 Disponibilidad de la integración personalizada

La extensión [JMC Receta](../src/pageext/JMCReceta.pageext.al) contiene, dentro de un bloque comentado, la intención de insertar la página JMC en Receta y añadir una acción JMC que abra los costes filtrados por artículo y versión 0. Ese bloque no está activo.

La acción **Additional Cost** de la página JMC tiene un `OnAction` vacío, con comentario de que no está implementada. No es una ruta operativa para añadir costes mediante plantilla.

Los símbolos de las dependencias muestran una página **Receta** con la acción **BOMCost** (caption **Costes Generales**) y una página externa **BOM Aditional Cost**. Esto apunta a que la entrada estándar actual del entorno CP se proporciona por la dependencia y no por la extensión JMC comentada. La disponibilidad efectiva requiere validarlo en el entorno Business Central.

### 6.3 Costes visibles en ficha/lista de artículo

Las extensiones locales [JMC Item Card](../src/pageext/JMCItemCard.pageext.al) y [JMC Item List](../src/pageext/JMCItemList.pageext.al) muestran:

- coste unitario de existencias calculado desde movimientos con cantidad pendiente y sus Value Entries;
- coste medio de compra del último año, calculado a partir de `Direct Unit Cost` en facturas registradas;
- último coste directo de compra guardado en un campo de extensión.

Las rutinas locales no leen **BOM Aditional Cost** ni suman los costes generales de la receta. El campo de último coste directo se describe expresamente como dato derivado de compras. Así, no hay evidencia en este repositorio de que los costes generales CP actualicen estos indicadores.

## 7. Recomendación para Comidas Populares

Antes de decidir cómo introducir cada coste, clasificarlo:

| Tipo de coste | Tratamiento recomendado |
| --- | --- |
| Ingrediente/material comprado y su coste normal | Artículo con método de valoración acordado; revisar factura, costes directos y ajuste de costes. |
| Flete/aduana/seguro atribuible a una compra o recepción | Item Charge asignado a los artículos/recepciones que lo originan. Comprobar si el artículo es Standard: en ese caso se registra variación y no se modifica el unit cost estándar. |
| Mano de obra, energía u overhead de cocina/fabricación | Si se quiere absorber de forma repetible al coste unitario, definir los componentes de capacidad/overhead del montaje o fabricación y mantener el coste estándar. Confirmar si las recetas actuales son Assembly BOM o Production BOM + Routing. |
| Alquiler, administración, costes generales no trazables | No esperar que una línea de gasto de mayor altere automáticamente el coste inventariable. Definir si se desea absorción de fabricación o solo imputación gerencial. |
| Coste comercial/analítico específico de una receta | El coste adicional de BOM CP puede dar una estimación de coste y margen; validar la dependencia y tratarlo como analítico hasta comprobar que se registra como coste inventariable. |

### Pruebas de aceptación propuestas

En una empresa de prueba, comparar un producto antes/después y verificar:

1. Ficha de artículo: método, coste estándar, coste unitario e indirect cost/overhead configurados.
2. Coste calculado y componentes de coste del BOM/receta.
3. Tras registrar producción/montaje: consumos, capacidad, salida, Value Entries y variaciones.
4. Tras asignar un Item Charge: Value Entry relacionada, coste del movimiento y efecto en el coste de ventas de unidades ya vendidas, después del ajuste de costes.
5. Para la página CP: importe de la línea de coste, EXWORK/margen de la pantalla JMC, y confirmar si cambia o no el coste unitario y los movimientos de valor.
6. Conciliación entre valoración de inventario y mayor, sin interpretar como equivalentes el coste de gestión y el coste contabilizado.

## 8. Límites y supuestos

- La parte local estática se ha analizado en CP-JMC Base; no se dispone aquí del código fuente de **CP - Functionality**, **CP - Feature** ni de todas las apps externas declaradas en `app.json`.
- La fórmula exacta de `AlxiaAssemblyInfoManagement`, la acción externa **BOMCost** y cualquier lógica de actualización de artículos requieren inspección del paquete/fuente de la dependencia o una prueba en el entorno.
- Los nombres de menús y campos pueden cambiar por versión, perfil y localización. Los nombres de los campos estándar se citan en inglés para facilitar su localización en BC.
- Este documento describe capacidades funcionales, no sustituye la definición de política contable, fiscal ni de valoración aprobada por la empresa.

## 9. Fuentes

Documentación oficial de Microsoft Learn consultada el 14 de octubre de 2026:

1. [Use item charges to account for extra trade costs](https://learn.microsoft.com/en-us/dynamics365/business-central/payables-how-assign-item-charges) — asignación de cargos, efecto sobre inventario y coste de ventas, Value Entries y excepción de coste estándar.
2. [About calculating standard cost](https://learn.microsoft.com/en-us/dynamics365/business-central/finance-about-calculating-standard-cost) — componentes de coste estándar en compra, montaje y producción, y desglose de overhead.
3. [Design details: Costing methods](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-costing-methods) — efecto de los métodos de valoración FIFO, Average, Specific y Standard.
4. [Design details: Inventory costing](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-inventory-costing) — conceptos y principios generales de valoración.
5. [Design details: Cost adjustment](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-cost-adjustment) — ajuste de costes y propagación a coste de ventas.
6. [Design details: Average cost](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-average-cost) — coste promedio periódico y su configuración.
7. [Design details: Production order posting](https://learn.microsoft.com/en-us/dynamics365/business-central/design-details-production-order-posting) — acumulación de WIP y transferencia de coste a producto terminado en producción.

Fuentes del repositorio:

- [`app.json`](../app.json)
- [`JMC CP BOM Aditional Cost`](../src/page/JMCCPBOMAditionalCost.page.al)
- [`JMC Receta`](../src/pageext/JMCReceta.pageext.al)
- [`JMC Item Card`](../src/pageext/JMCItemCard.pageext.al)
- [`JMC Item List`](../src/pageext/JMCItemList.pageext.al)
- [`JMC Item`](../src/tableext/JMCItem.tableext.al)
