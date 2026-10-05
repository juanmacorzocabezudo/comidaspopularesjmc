# Importación de nóminas

La importación de nóminas carga el Excel de la asesoría en una pantalla de revisión, genera una propuesta de asiento por trabajador y, cuando se confirma, crea las líneas en el diario general. **La aplicación no registra el diario**: el usuario lo revisa y lo registra con el proceso estándar de Business Central.

## Configuración inicial

Busque **Importaciones de nóminas** y abra **Configuración**.

1. En **Diario**, seleccione la **Plantilla diario** y la **Sección diario** donde se crearán las líneas. Cada importación guarda la plantilla y sección configuradas al crearla.
2. Configure la **Nº serie documento** si la sección no tiene una serie propia.
3. Revise la **Tolerancia de cuadre**, usada en las comprobaciones de importes. El valor inicial es 0,01.
4. Use **Inicializar valores por defecto** para crear los conceptos, organismos y mapeos que falten. Esta acción no cambia los registros existentes.
5. Abra **Cuentas por concepto** y asigne una cuenta contable a cada concepto que vaya a generar asientos.
6. Abra **Mapeo de columnas** y revise el tratamiento de cada columna del Excel.

En el mapeo, cada columna con importe debe tener un **Tipo concepto** si debe generar líneas contables. Si solo se conserva para consulta y no debe contabilizarse desde esa columna, marque **Informativa**. No marque como informativa una columna cuyo importe deba formar parte del asiento.

Algunas columnas ya tienen un tratamiento predeterminado, como `C.BRUTO`, `SS.EMPRESA`, `TC1`, `IRPF`, `RETENCION`, `LIQUIDO`, `ANTICIPOS`, `C.TOTAL`, `SS.TRAB.`, `BASE S.SOC` y `BASE IRPF`. Las columnas adicionales pueden necesitar configuración según el criterio contable de la empresa. Por ejemplo, `RTOS ESPEC`, `seguro med` y `s.med irpf` deben mapearse a un concepto o marcarse como informativas si no generan asiento.

## Preparar los datos

- Use un fichero **`.xlsx`** con una hoja de nóminas.
- La fila de cabecera se localiza por sus nombres; no tiene que estar en una fila fija. El código del trabajador no lleva cabecera y debe estar justo antes de `TRABAJADOR`.
- Las columnas de nómina se reconocen por su cabecera, por ejemplo `TRABAJADOR`, `N.I.F.`, `TIPO PAGA`, `FECHA COBRO`, `C.BRUTO`, `SS.EMPRESA`, `TC1`, `LIQUIDO` y las columnas adicionales configuradas.
- Cada fila de nómina debe tener código de gestoría, nombre de trabajador y fecha de cobro válida. La fecha puede venir como fecha de Excel o como texto `dd/mm/aaaa`.
- La fila de totales se identifica por el texto exacto `TOTAL EMPRESA` al comienzo de la fila. Si existe, sus totales se usan para comprobar los importes importados.
- Mantenga el código de gestoría como texto para conservar ceros iniciales, por ejemplo `000001`.

Antes de importar, compruebe que los recursos de Business Central tienen informado **ID Gestoría** en su ficha. Ese código relaciona cada fila del Excel con un recurso. Si no se puede encontrar un único recurso, podrá asignarlo manualmente en la pantalla de importación.

## Crear una importación

1. En **Importaciones de nóminas**, seleccione **Importar Excel**.
2. Elija el fichero `.xlsx` de la asesoría. La aplicación crea una importación, lee las nóminas y muestra sus líneas.
3. Revise el **Estado**, el nombre y el código de gestoría, el recurso relacionado, las fechas y los importes.
4. Si falta un recurso o el código coincide con varios recursos, corrija el ID en la ficha del recurso o seleccione el recurso correcto manualmente en la línea.
5. Revise la propuesta de asiento de la nómina seleccionada en la subpágina inferior. Las líneas de propuesta se pueden modificar antes de crear el diario.

Si vuelve a importar un fichero en una importación que ya tiene líneas, se pedirá confirmación: las líneas actuales se eliminarán y se sustituirán por las del nuevo fichero.

## Validar y revisar

Pulse **Validar**. Para las nóminas que todavía no tienen propuesta, la aplicación genera líneas según el mapeo de columnas y las cuentas configuradas. Después comprueba, entre otros aspectos:

- que cada trabajador tenga un recurso válido;
- que la fecha de cobro esté dentro del periodo permitido;
- que las columnas con importe estén mapeadas;
- que los conceptos tengan cuentas contables válidas;
- que los importes y las líneas de cada documento cuadren;
- que los totales importados coincidan con la fila `TOTAL EMPRESA`, cuando exista;
- que no se dupliquen nóminas.

Use **Ver errores** para filtrar las nóminas con errores o avisos y **Ver todas** para volver a mostrar el conjunto completo. Los errores impiden crear el diario. Los avisos, como una diferencia de totales, requieren confirmación al continuar.

### Corregir mapeos después de validar

Si aparece un mensaje como «La columna `RTOS ESPEC` tiene importe pero no tiene concepto asignado en el mapeo»:

1. Abra **Configuración > Mapeo de columnas**.
2. Busque la columna indicada.
3. Asígnele un **Tipo concepto** y asegúrese de que ese concepto tiene una cuenta en **Cuentas por concepto**; o marque **Informativa** si no debe generar asiento.
4. En las nóminas afectadas, use **Regenerar asiento** y confirme. Esta acción vuelve a crear la propuesta desde los importes y **pierde los cambios manuales** realizados en ella.
5. Vuelva a **Validar**.

La validación conserva las propuestas que ya existen; por eso cambiar el mapeo, por sí solo, no añade nuevas líneas a propuestas ya generadas.

## Crear y registrar el diario

Cuando la importación esté validada y no tenga errores:

1. Pulse **Crear diario** y confirme.
2. La sección configurada debe estar vacía. La aplicación crea un documento por nómina en el diario general y guarda la plantilla, sección y números de documento en la importación.
3. Pulse **Abrir diario** para revisar las líneas creadas. Los asientos todavía no están registrados.
4. Registre el diario con el proceso estándar de Business Central.
5. Cuando el diario se haya registrado, vuelva a la importación y pulse **Marcar como procesado**.

Una importación en estado **Diario creado** o **Procesado** ya no se puede modificar ni volver a importar.

## Mensajes habituales

| Mensaje o situación | Qué revisar |
|---|---|
| Una columna con importe no tiene concepto asignado | Configure un tipo de concepto o marque la columna como informativa, según su tratamiento contable. |
| No hay ningún recurso con el ID Gestoría | Informe el mismo código de gestoría en el recurso o asigne el recurso manualmente en la línea. |
| Varios recursos tienen el mismo ID Gestoría | Corrija los códigos duplicados para que el código identifique un único recurso. |
| Una línea no tiene cuenta contable o la cuenta no es válida | Asigne una cuenta al concepto y compruebe que sea una cuenta auxiliar habilitada para registro directo. |
| Los totales no coinciden con `TOTAL EMPRESA` | Compare las nóminas importadas y el total del Excel; el diario solo puede continuar con la confirmación correspondiente. |
| La sección del diario no está vacía | Revise o retire sus líneas antes de crear los asientos de nómina. |