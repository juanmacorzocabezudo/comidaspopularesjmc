# Análisis de importación de nóminas

## Objetivo

Analizar el fichero Excel `NOMINAS COMIDAS POPULARES - RN 2015-2026.xls` y proponer una solución para importar las nóminas en Business Central, generando asientos de nómina pendientes de revisar y registrar.

La recomendación principal es no cargar directamente el Excel al diario contable. Es mejor utilizar una pantalla intermedia donde se pueda revisar, validar y corregir la información antes de generar las líneas del diario general.

## Resumen del Excel

El fichero es un `.xls` clásico con una única hoja llamada `1`. La cabecera real está en la fila 8 y contiene 4.844 líneas de detalle, además de filas de totales al final.

El periodo incluido va desde el 31/01/2015 hasta el 31/08/2026.

### Columnas detectadas

| Campo | Uso probable |
| --- | --- |
| Código trabajador | Columna 2, sin cabecera |
| `TRABAJADOR` | Nombre del empleado |
| `N.I.F.` | Identificación del empleado |
| `TIPO PAGA` | Tipo de nómina: `MENSUAL`, `ATRASOS`, `FINIQUITO` |
| `FECHA COBRO` | Fecha de pago o fecha del asiento |
| `C.BRUTO` | Coste bruto / sueldos y salarios |
| `SS.EMPRESA` | Seguridad Social a cargo de la empresa |
| `C.TOTAL` | Coste total empresa |
| `TC1` | Seguridad Social a pagar |
| `PRIMAS` | Primas |
| `SS.TRAB.` | Seguridad Social del trabajador, con signo negativo |
| `IRPF` | Retención IRPF, con signo negativo |
| `RETENCION` | Otras retenciones |
| `LIQUIDO` | Importe líquido a pagar |
| `BASE S.SOC` | Base de Seguridad Social |
| `BASE IRPF` | Base IRPF |
| `DESCUENTOS` | Descuentos |
| `RTOS ESPEC` | Retribuciones especiales |
| `ANTICIPOS` | Anticipos |
| `seguro med` | Seguro médico |
| `s.med irpf` | Seguro médico sujeto a IRPF |
| `deduc rtos` | Deducción de retribuciones |
| `PP EXTRA` | Posible prorrata/provisión de paga extra |
| `SS AUTONOM` | Seguridad Social autónomos |

### Totales principales

| Concepto | Total |
| --- | ---: |
| Bruto | 6.865.999,85 |
| Seguridad Social empresa | 1.618.600,19 |
| Coste total | 8.484.692,34 |
| TC1 | 1.938.740,07 |
| Seguridad Social trabajador | -320.143,86 |
| IRPF | -662.050,89 |
| Retención | -108.734,50 |
| Líquido | 5.737.862,94 |

### Tipos de paga

| Tipo de paga | Líneas |
| --- | ---: |
| `MENSUAL` | 4.434 |
| `ATRASOS` | 231 |
| `FINIQUITO` | 179 |

## Propuesta funcional

La solución recomendada es crear una funcionalidad específica de importación de nóminas con tabla intermedia. El flujo sería:

```text
Excel -> Tabla intermedia JMC -> Validación -> Generación de diario general -> Revisión estándar BC -> Registro manual
```

De esta forma se consigue:

- Revisar la información antes de crear el diario.
- Detectar errores de formato, importes o fechas.
- Evitar duplicidades.
- Gestionar columnas especiales sin tener que modificar código cada vez.
- Mantener trazabilidad entre Excel, líneas importadas y asiento generado.
- Permitir que el usuario registre manualmente desde Business Central cuando haya revisado el diario.

## Objetos propuestos

### Configuración de importación

Crear una tabla de configuración, por ejemplo `JMC Payroll Import Setup`, donde se indiquen las cuentas y parámetros necesarios.

Campos recomendados:

| Campo | Uso |
| --- | --- |
| Plantilla diario general | Plantilla destino para las líneas generadas |
| Sección diario general | Sección destino |
| Nº serie documento | Serie para generar el número de documento |
| Cuenta sueldos y salarios | Cuenta para `C.BRUTO` |
| Cuenta Seguridad Social empresa | Cuenta para `SS.EMPRESA` |
| Cuenta Seguridad Social acreedora | Cuenta para `TC1` |
| Cuenta Hacienda IRPF | Cuenta para `IRPF` |
| Cuenta remuneraciones pendientes | Cuenta para `LIQUIDO` |
| Cuenta anticipos | Cuenta para `ANTICIPOS` |
| Cuenta retenciones varias | Cuenta para `RETENCION` o descuentos especiales |
| Tolerancia de cuadre | Por ejemplo 0,01 |

Además, conviene crear una tabla de mapeo de conceptos para las columnas especiales. Así, si aparece un importe en una columna no configurada, el sistema marcará error en vez de generar un asiento incorrecto.

### Cabecera de importación

Crear una tabla de cabecera, por ejemplo `JMC Payroll Import Header`.

Campos recomendados:

| Campo | Uso |
| --- | --- |
| Nº importación | Identificador interno |
| Nombre fichero | Nombre del Excel importado |
| Fecha/hora importación | Auditoría |
| Usuario importación | Auditoría |
| Estado | Pendiente, Validado, Diario creado |
| Fecha desde | Primera fecha detectada |
| Fecha hasta | Última fecha detectada |
| Total bruto | Total importado |
| Total SS empresa | Total importado |
| Total líquido | Total importado |
| Nº documento diario | Documento generado, si aplica |

### Líneas de importación

Crear una tabla de líneas, por ejemplo `JMC Payroll Import Line`, con una línea por registro del Excel.

Campos recomendados:

| Campo | Uso |
| --- | --- |
| Nº importación | Relación con la cabecera |
| Nº línea | Línea interna |
| Nº línea Excel | Trazabilidad con el fichero |
| Código trabajador | Código leído de la columna 2 |
| Trabajador | Nombre |
| NIF | Identificación |
| Tipo paga | Mensual, atrasos o finiquito |
| Fecha cobro | Fecha del Excel |
| Bruto | `C.BRUTO` |
| SS empresa | `SS.EMPRESA` |
| Coste total | `C.TOTAL` |
| TC1 | `TC1` |
| SS trabajador | `SS.TRAB.` |
| IRPF | `IRPF` |
| Retención | `RETENCION` |
| Líquido | `LIQUIDO` |
| Anticipos | `ANTICIPOS` |
| Descuentos | `DESCUENTOS` |
| Retribuciones especiales | `RTOS ESPEC` |
| Seguro médico | `seguro med` |
| Seguro médico IRPF | `s.med irpf` |
| Deducción retribuciones | `deduc rtos` |
| PP extra | `PP EXTRA` |
| SS autónomos | `SS AUTONOM` |
| Estado validación | Correcta, Aviso, Error |
| Mensaje validación | Descripción del problema |
| Nº documento diario | Documento generado |

### Página intermedia

Crear una página tipo worksheet/list, por ejemplo `JMC Payroll Import Worksheet`, para revisar la información importada.

Acciones recomendadas:

| Acción | Función |
| --- | --- |
| Importar Excel | Carga el fichero en la tabla intermedia |
| Validar | Ejecuta validaciones contables y de formato |
| Ver errores | Filtra líneas con problemas |
| Crear diario | Crea líneas en `Gen. Journal Line` |
| Abrir diario | Abre el diario general generado |
| Marcar procesado | Bloquea la importación tras crear el diario |

### Codeunit de gestión

Crear una codeunit, por ejemplo `JMC Payroll Import Mgt.`, para centralizar la lógica:

- Leer el Excel con `Excel Buffer`.
- Detectar la fila de cabecera buscando columnas como `TRABAJADOR`, `N.I.F.`, `TIPO PAGA` y `FECHA COBRO`.
- Ignorar filas de título y filas de total como `TOTAL EMPRESA`.
- Importar solo filas con código de trabajador, trabajador y fecha válida.
- Normalizar signos.
- Validar importes y cuentas.
- Crear líneas en `Gen. Journal Line`.
- Guardar trazabilidad entre línea importada y línea de diario.

## Asiento contable base

Para una nómina estándar, el asiento base sería:

| Debe/Haber | Cuenta | Importe |
| --- | --- | ---: |
| Debe | Sueldos y salarios | `C.BRUTO` |
| Debe | Seguridad Social empresa | `SS.EMPRESA` |
| Haber | Seguridad Social acreedora | `TC1` |
| Haber | Hacienda acreedora por IRPF | Valor absoluto de `IRPF` |
| Haber | Remuneraciones pendientes de pago | `LIQUIDO` |

Conceptualmente:

```text
Debe:
  640 = C.BRUTO
  642 = SS.EMPRESA

Haber:
  476 = TC1
  4751 = abs(IRPF)
  465 = LIQUIDO
```

En las líneas normales, el patrón esperado es:

```text
C.TOTAL = C.BRUTO + SS.EMPRESA
TC1 = SS.EMPRESA + abs(SS.TRAB.)
LIQUIDO = C.BRUTO - abs(SS.TRAB.) - abs(IRPF) - otras deducciones
```

## Columnas especiales

No conviene codificar una lógica fija para todas las columnas especiales, porque algunas aparecen en pocos casos pero tienen importes significativos.

| Columna | Casos | Total |
| --- | ---: | ---: |
| `RETENCION` | 296 | -108.734,50 |
| `DESCUENTOS` | 45 | -10.829,07 |
| `RTOS ESPEC` | 12 | -12.838,69 |
| `ANTICIPOS` | 33 | -11.902,69 |
| `seguro med` | 10 | 1.865,35 |
| `s.med irpf` | 10 | 1.131,89 |
| `SS AUTONOM` | 2 | 1.636,71 |
| `PP EXTRA` | 3.874 | 739.531,23 |

La recomendación es que estas columnas se gestionen mediante una tabla de mapeo de conceptos. Si una columna trae importe y no tiene cuenta configurada, la línea debe quedar en error y no se debe permitir generar el diario.

La columna `PP EXTRA` parece informativa o relacionada con prorrata/provisión de paga extra. No debería incluirse en el asiento automáticamente sin confirmar el criterio contable.

## Agrupación del diario

Hay dos alternativas principales.

| Opción | Ventaja | Inconveniente |
| --- | --- | --- |
| Una línea contable por trabajador y concepto | Máxima trazabilidad en contabilidad | Diario con muchas líneas |
| Asiento agrupado por fecha/tipo paga/concepto | Diario más limpio y manejable | Menos detalle en contabilidad |

La opción recomendada es importar y revisar a nivel trabajador en la pantalla intermedia, pero generar el diario agrupado por fecha de cobro, tipo de paga y concepto contable.

Si se quiere controlar la deuda con empleados individualmente, la cuenta de remuneraciones pendientes de pago podría generarse por trabajador, usando el código o NIF como dimensión, cuenta auxiliar o texto descriptivo.

## Validaciones recomendadas

Antes de generar el diario, la importación debería validar:

- Que existen cuentas configuradas para todos los conceptos obligatorios.
- Que no hay columnas especiales con importe sin cuenta asignada.
- Que la fecha de cobro es válida.
- Que la fecha está dentro de un periodo contable abierto o permitido.
- Que no se ha importado previamente la misma combinación de trabajador, NIF, tipo paga, fecha e importes.
- Que `C.TOTAL` cuadra con `C.BRUTO + SS.EMPRESA`, admitiendo una tolerancia de 0,01.
- Que `TC1` cuadra con `SS.EMPRESA + abs(SS.TRAB.)`, cuando ambos importes existan.
- Que el asiento resultante queda balanceado por documento.
- Que los totales importados coinciden con la fila `TOTAL EMPRESA`.
- Que las líneas de `FINIQUITO` y `ATRASOS` puedan revisarse por separado.

## Permisos

Conviene crear o ampliar un permission set JMC para esta funcionalidad, con acceso a:

- Tablas de cabecera y líneas de importación.
- Página de importación.
- Codeunit de importación.
- Lectura y creación de líneas en `Gen. Journal Line`.
- Lectura de configuración de diario, secciones, cuentas contables y series.

## Conclusión

La mejor solución es una importación con pantalla intermedia y generación posterior del diario general. No se recomienda registrar directamente desde el Excel.

El flujo propuesto permite revisar la información, controlar duplicidades, validar el cuadre contable, tratar columnas especiales de forma configurable y mantener trazabilidad completa desde el Excel original hasta el asiento generado.
