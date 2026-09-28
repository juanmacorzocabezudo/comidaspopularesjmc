---
description: 'Desarrollar el proceso de importación de nóminas (Excel asesoría) con pantalla intermedia, validación y generación de un asiento por nómina y empleado en el diario general de Business Central.'
agent: agent
---

# Desarrollo: importación de nóminas JMC

## Contexto

Extensión AL `CP-JMC Base` (BC 27, runtime 16.0, rango de IDs 53100–53499). La asesoría envía cada mes a Comidas Populares un Excel de nóminas. Hay que importarlo, revisarlo en una pantalla intermedia y generar las líneas en el diario general. **Las líneas no se registran automáticamente**: el usuario revisa el diario y lo registra de forma estándar.

Documentos de referencia:
- [Análisis inicial](../../AnalisisImportacionNominas.md)
- Excel de ejemplo: `/Users/juanmariacorzo/Documents/Comidas Populares/Ficheros/NOMINAS COMIDAS POPULARES - RN 2015-2026.xlsx` (hoja `1`, 364 nóminas de enero a agosto de 2026). Para leerlo en local: `python3` + `openpyxl` (instalado).
- Análisis revisado por el cliente: `/Users/juanmariacorzo/Documents/Comidas Populares/Ficheros/Importacion Nominas.docx`. Si hay diferencias, **manda este documento**.

## Reglas obligatorias del proyecto

- Aplica los skills `jmc-naming` y `english-fields-spanish-translation`:
  - Objetos, campos y ficheros en inglés, con el prefijo `JMC`.
  - Captions sin `JMC`.
  - `Caption`, `ToolTip` y `Label` llevan en la misma línea `Comment = 'ESP="..."'`.
- Los IDs se obtienen con AL Object ID Ninja. Si falla, busca IDs libres en `src/` dentro del rango 53100–53499.
- Consulta `/memories/repo/al-build-notes.md`. El warning N0301 no bloquea.
- Compila con la herramienta de build AL y corrige todos los errores antes de terminar.
- No modifiques objetos existentes que no tengan relación con esta funcionalidad.

## Estructura del Excel

- Formato: `.xlsx`, una hoja. Se lee con `Excel Buffer`.
- En el ejemplo: filas 2–5 de título (`Moneda: Euro`, `PAGA TOTAL`, periodo, empresa), cabecera en la fila 8, datos desde la fila 9, `TOTAL EMPRESA` en la penúltima fila y `TOTAL TRABAJADORES EMPRESA = N` en la última.
- El código del trabajador viene como texto (`'000001'`) y `FECHA COBRO` como fecha. Aun así, la lectura debe admitir la fecha como número serie de Excel o como texto `dd/mm/aaaa`.
- La cabecera no está en una fila fija. Hay que localizarla buscando `TRABAJADOR`, `N.I.F.`, `TIPO PAGA` y `FECHA COBRO`. En el ejemplo está en la fila 8.
- Las columnas se identifican **por el nombre de la cabecera, no por su posición**. La excepción es el código del trabajador: está en la columna anterior a `TRABAJADOR` y no tiene cabecera.
- Cabeceras: `TRABAJADOR, N.I.F., TIPO PAGA, FECHA COBRO, C.BRUTO, SS.EMPRESA, C.TOTAL, TC1, PRIMAS, SS.TRAB., IRPF, RETENCION, LIQUIDO, BASE S.SOC, BASE IRPF, DESCUENTOS, RTOS ESPEC, ANTICIPOS, seguro med, s.med irpf, deduc rtos, PP EXTRA, SS AUTONOM`.
- Una fila es de detalle solo si tiene código de trabajador, nombre y una fecha válida.
- Se ignoran las filas de título y las de total. Identificar el total por el texto exacto `TOTAL EMPRESA` que empieza en la columna 1. **No** usar `contiene 'TOTAL'`, porque la fila 3 es `PAGA TOTAL`. La fila `TOTAL EMPRESA` se guarda en la cabecera para cuadrar contra ella.
- `TIPO PAGA` puede ser `MENSUAL`, `ATRASOS` o `FINIQUITO`.
- En el Excel, las deducciones vienen en negativo: `SS.TRAB.`, `IRPF`, `RETENCION`, `DESCUENTOS`, `ANTICIPOS`, `RTOS ESPEC`, `deduc rtos`.
- `BASE S.SOC`, `BASE IRPF` y `PP EXTRA` son informativas. Se importan, pero **no generan asiento** salvo que se configure lo contrario.

### Relación con recursos de BC

- El código del trabajador (segunda columna, sin título) se relaciona con `Resource."JMC Gestoría ID"` (Code[20], definido en `src/tableext/JMCResource.tableext.al`).
- Leer el código **como texto, conservando los ceros a la izquierda** (p. ej. `000001`).
- Guardar en la línea de importación el `Resource No.` encontrado y su nombre.
- Si no existe ningún recurso con ese `JMC Gestoría ID`, o existe más de uno, la línea queda en **error**. El usuario puede asignar el recurso manualmente en la pantalla intermedia.

## Asiento a generar

**Un documento (asiento) por cada nómina de cada empleado**, es decir, por cada línea del Excel.

Al validar, el sistema genera una **propuesta de asiento** (tabla `JMC Payroll Import Entry`) que el usuario puede modificar libremente antes de pasarla al diario:
- Fecha de registro: `FECHA COBRO`.
- Nº de documento: se toma de la serie configurada.
- Descripción: `Nómina <tipo paga> <MM/AAAA> - <trabajador>`.

Asiento base de una nómina estándar. Todas las cuentas se toman de la **configuración** (los números entre paréntesis son solo orientativos, no se escriben en código):

| D/H | Concepto | Importe |
|---|---|---|
| Debe | Sueldos y salarios (640) | `C.BRUTO` |
| Debe | SS a cargo de la empresa (642) | `SS.EMPRESA` |
| Haber | Organismos SS acreedores (476) | `TC1` (= SS.EMPRESA + abs(SS.TRAB.)) |
| Haber | HP acreedora por IRPF (4751) | abs(`IRPF`) |
| Haber | Remuneraciones pendientes de pago (465) | `LIQUIDO` |
| Haber | Deducciones (`RETENCION`, `DESCUENTOS`, `ANTICIPOS`) | Cuenta por defecto del mapeo; el usuario la reparte manualmente |

Si hay importe en `PRIMAS`, `RTOS ESPEC`, `seguro med`, `s.med irpf`, `deduc rtos` o `SS AUTONOM`, se contabiliza según el **mapeo de conceptos**. Si una columna trae importe y no tiene mapeo, la línea queda en error.

### Dimensiones

- Las dimensiones son **las que tenga asignadas la cuenta** (dimensiones predeterminadas de `G/L Account`).
- No se crea configuración propia de dimensiones. Al crear la línea en `Gen. Journal Line`, hacer `Validate("Account No.")` para que BC aplique las dimensiones por defecto de forma estándar.
- En la propuesta de asiento se muestran las dimensiones globales 1 y 2 que resultan de la cuenta, solo informativas.

### Préstamos, intereses y embargos: reparto manual

El Excel no desglosa préstamos ni embargos (van dentro de `RETENCION`, `DESCUENTOS` o `ANTICIPOS`). **El reparto lo hace el usuario a mano** en la propuesta de asiento. No se crea un maestro de deducciones por empleado ni un cálculo automático.

Casos que el usuario debe poder reflejar:
- **Préstamo a empleado**: solo amortización.
- **Préstamo a parte vinculada**: una línea de amortización y otra de intereses.
- **Embargo**: la cuenta depende del organismo (Diputación, Juzgado, AEAT, TGSS, Otros).

Para facilitar el reparto manual:
- Cada línea de la propuesta tiene un campo `Concept Type` (enum `JMC Payroll Concept Type`, ampliable) con valores como: Salary, Company SS, SS Payable, IRPF, Net Pay, Advance, Employee Loan, Related Party Loan Principal, Related Party Loan Interest, Garnishment, Other.
- Si el tipo es `Garnishment`, se informa `Garnishment Authority` (enum `JMC Garnishment Authority`, ampliable) y un texto libre de expediente.
- Al elegir el tipo (y el organismo, en embargos), la cuenta se **propone** desde la configuración, pero el usuario puede cambiarla.
- La descripción por defecto incluye el concepto y, en embargos, el organismo y el expediente. Es editable.
- Acción `Split Line` en la propuesta: divide una línea en dos (misma cuenta y signo, importe a repartir) para separar, por ejemplo, amortización e intereses.

## Objetos a crear (nombres orientativos)

| Objeto | Propósito |
|---|---|
| Table `JMC Payroll Import Setup` | Plantilla y sección del diario, serie de documentos y tolerancia de cuadre (0,01). |
| Table `JMC Payroll Concept Setup` | Por cada `Concept Type`: cuenta contable por defecto y lado Debe/Haber. **Todas las cuentas se parametrizan aquí**, ninguna en código. |
| Table `JMC Payroll Column Mapping` | Columna del Excel → `Concept Type` (o Informativo). Define qué concepto propone cada columna. |
| Enum `JMC Payroll Concept Type` | Ver sección de reparto manual (extensible). |
| Enum `JMC Garnishment Authority` | Diputación, Juzgado, AEAT, TGSS, Otro (extensible). |
| Table `JMC Garnishment Account Setup` | Organismo → cuenta contable. |
| Table `JMC Payroll Import Header` | Nº importación, fichero, fecha/usuario, estado (Pendiente, Validado, Diario creado, Procesado), rango de fechas y totales importados frente a `TOTAL EMPRESA`. |
| Table `JMC Payroll Import Line` | Una línea por cada nómina del Excel: todas sus columnas, código gestoría, `Resource No.`, estado de validación (Correcta/Aviso/Error), mensaje y Nº de documento generado. |
| Table `JMC Payroll Import Entry` | Propuesta de asiento de cada nómina: concepto, organismo, expediente, cuenta, descripción, importe Debe/Haber, dimensiones globales (informativas). |
| Page `JMC Payroll Import List` / `JMC Payroll Import` | Documento con cabecera, subpágina de nóminas y subpágina de propuesta de asiento de la nómina seleccionada. Acciones: Importar Excel, Validar/Generar propuesta, Ver errores, Crear diario, Abrir diario, Marcar procesado. |
| Pages de configuración | Setup, conceptos, mapeo de columnas y cuentas por organismo. |
| Codeunit `JMC Payroll Import Mgt.` | Lectura del Excel con `Excel Buffer`, relación con recursos, validación, generación de la propuesta y creación de líneas en `Gen. Journal Line`. |
| PermissionSet `JMC PAYROLL IMPORT` | Acceso a todos los objetos nuevos, a `Gen. Journal Line`, a lectura de `Resource` y a lectura de plantillas, secciones, cuentas y series. |

### Pantalla intermedia completamente editable

- Mientras la importación no esté en `Diario creado` o `Procesado`, **todo es editable**:
  - Nóminas: recurso, fecha, tipo de paga e importes.
  - Propuesta de asiento: añadir, borrar y modificar líneas (concepto, organismo, expediente, cuenta, descripción, importe).
- Al modificar una nómina o su propuesta, la línea vuelve a estado pendiente de validar.
- Acción `Regenerate Entry` para rehacer la propuesta desde los importes de la nómina, con confirmación porque se pierden los cambios manuales.
- Mostrar en la nómina el total Debe, total Haber y descuadre de su propuesta, con estilo destacado cuando no cuadre.

## Validaciones

Antes de crear el diario hay que comprobar:
- Que cada nómina tiene un recurso válido relacionado por `JMC Gestoría ID`.
- Que todas las cuentas obligatorias están configuradas y que cada línea de la propuesta tiene cuenta.
- Que las líneas de embargo tienen organismo informado.
- Que ninguna columna con importe se queda sin tratamiento.
- Que la fecha es válida y está dentro de un periodo contable permitido.
- Que no hay duplicados: la misma combinación de NIF, tipo de paga, fecha e importes no puede estar en esta importación, ni en otra anterior que ya haya creado diario.
- Que `C.TOTAL = C.BRUTO + SS.EMPRESA` y que `TC1 = SS.EMPRESA + abs(SS.TRAB.)`, con la tolerancia configurada.
- Que el asiento de cada nómina cuadra. Si no cuadra dentro de la tolerancia, la línea queda en error y no se crea el diario.
- Que los totales importados coinciden con `TOTAL EMPRESA`.
- Que el reparto manual de cada columna de deducción suma el importe original de la columna. Si no, **aviso** (el usuario puede haberlo cambiado a propósito), pero el asiento debe seguir cuadrando.
- Que se pueden filtrar las líneas `FINIQUITO` y `ATRASOS` para revisarlas por separado.

Además:
- No se permite crear el diario si hay alguna línea en error.
- Los avisos exigen confirmación del usuario.
- Una importación en estado `Diario creado` o `Procesado` no se puede modificar ni volver a importar.

## Forma de trabajar

1. Decisiones ya tomadas (no volver a preguntar): cuentas parametrizadas, reparto manual, pantalla editable, dimensiones de la cuenta, relación por `JMC Gestoría ID`, Excel en `.xlsx`. Antes de programar, pregunta solo:
   - Si el líquido va siempre a cuenta contable o también debe permitir tipo de cuenta `Employee`.
   - Si `PP EXTRA` se contabiliza.
   - Si en la descripción del asiento se usa el nombre del Excel o el del recurso.
2. Propón los IDs y la lista de ficheros y espera confirmación.
3. Implementa en este orden: enums y tablas de configuración → tablas de importación y propuesta → importación → validación → generación del diario → páginas → permission set → traducciones (XLF).
4. Compila y corrige los errores.
5. Resume los objetos creados y los pasos para probarlo con el Excel de ejemplo `.xlsx`.
