table 53105 "JMC Cost Calculation Detail"
{
    Caption = 'Saved Cost Calculation Detail', Comment = 'ESP="Detalle guardado del cálculo de costes"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Model Code"; Code[20])
        {
            Caption = 'Breakdown Model Code', Comment = 'ESP="Código modelo del desglose"';
            TableRelation = "JMC Cost Model"."JMC Code";
        }
        field(2; "JMC Entry No."; Integer)
        {
            Caption = 'Detail Entry No.', Comment = 'ESP="Nº movimiento del detalle"';
        }
        field(3; "JMC Summary Field No."; Integer)
        {
            Caption = 'Summary Field No.', Comment = 'ESP="Nº campo del resumen"';
        }
        field(4; "JMC Detail Type"; Option)
        {
            Caption = 'Breakdown Level', Comment = 'ESP="Nivel del desglose"';
            ToolTip = 'Identifies what this row explains: a source movement, a business fund, a unit group, a product allocation or money left unallocated. These are different steps, not amounts to add together.', Comment = 'ESP="Indica qué explica esta fila: un movimiento de origen, el fondo de un negocio, un grupo de unidades, el reparto a un producto o dinero pendiente. Son pasos distintos, no importes que deban sumarse entre sí."';
            OptionMembers = Formula,Accounting,Production,Allocation,Pending,"Unit Group","Business Fund";
            OptionCaption = 'Formula,Accounting,Production,Allocation,Pending,Unit Group,Business Fund', Comment = 'ESP="Fórmula,Contabilidad,Producción,Reparto,Pendiente,Grupo de unidad,Fondo del negocio"';
        }
        field(5; "JMC Source Entry No."; Integer)
        {
            Caption = 'Saved Source Entry or Line No.', Comment = 'ESP="Nº movimiento o línea de origen guardados"';
            ToolTip = 'Shows the source movement number for accounting and production rows, or the model line number for product allocations. It is not a document number. A zero means no source number applies.', Comment = 'ESP="Es el número del movimiento en filas contables y de producción, o el número de línea del modelo en repartos a productos. No es el número de documento. Un cero indica que no corresponde un número de origen."';
        }
        field(6; "JMC Posting Date"; Date)
        {
            Caption = 'Saved Posting Date', Comment = 'ESP="Fecha registro guardada"';
            ToolTip = 'Shows the posting date of the source movement when the calculation was saved. It is blank for rows that explain a distribution rather than a movement.', Comment = 'ESP="Es la fecha de registro del movimiento de origen que se guardó al calcular. Está vacía en las filas que explican un reparto y no un movimiento."';
        }
        field(7; "JMC Document No."; Code[20])
        {
            Caption = 'Saved Document No.', Comment = 'ESP="Nº documento guardado"';
            ToolTip = 'Shows the document reference copied from the accounting or production movement. Use it to identify the document that produced that movement.', Comment = 'ESP="Es la referencia del documento copiada del movimiento contable o de producción. Permite identificar el documento que generó ese movimiento."';
        }
        field(8; "JMC Account No."; Code[20])
        {
            Caption = 'Saved Account No.', Comment = 'ESP="Nº cuenta guardada"';
            ToolTip = 'Identifies the G/L account from which this expense was taken. It applies to accounting rows, not to the subsequent product allocations.', Comment = 'ESP="Identifica la cuenta contable de la que se tomó este gasto. Se utiliza en las filas contables, no en los repartos posteriores a productos."';
        }
        field(9; "JMC Item No."; Code[20])
        {
            Caption = 'Saved Item No.', Comment = 'ESP="Nº producto guardado"';
            ToolTip = 'Identifies the product in the production movement or allocation line. It is blank for amounts that apply to a whole business or group rather than one product.', Comment = 'ESP="Identifica el producto del movimiento de producción o de la línea de reparto. Está vacío en importes que corresponden a todo un negocio o grupo y no a un producto concreto."';
        }
        field(10; "JMC Unit Code"; Code[10])
        {
            Caption = 'Saved Movement or Sales Unit', Comment = 'ESP="Unidad de movimiento o venta guardada"';
            ToolTip = 'Shows the unit recorded on the production movement or used for the sales allocation, such as kilograms or boxes. Check the quantity field help before adding quantities from different rows.', Comment = 'ESP="Es la unidad anotada en el movimiento de producción o utilizada en el reparto de ventas, como kilos o cajas. Consulte la ayuda del campo cantidad antes de sumar cantidades de distintas filas."';
        }
        field(11; "JMC Business"; Code[20])
        {
            Caption = 'LINEA Dimension', Comment = 'ESP="DIMENSION LINEA"';
            ToolTip = 'Identifies the business assigned to this row: Catering or Industry. Production uses the LINEA dimension; product allocations use the product code. This is the assignment saved at calculation time.', Comment = 'ESP="Indica el negocio asignado a esta fila: Catering o Alimentación. En producción se utiliza la dimensión LINEA; en los repartos a productos, el código del producto. Es la asignación guardada al calcular."';
        }
        field(12; "JMC Classification"; Enum "JMC Cost Classification")
        {
            Caption = 'Saved Cost Classification', Comment = 'ESP="Clasificación del coste guardada"';
            ToolTip = 'Indicates whether the amount belongs to industrial or management costs. Each category is distributed separately. Production rows do not use this classification.', Comment = 'ESP="Indica si el importe corresponde a costes industriales o de gestión. Cada categoría se reparte por separado. Los movimientos de producción no utilizan esta clasificación."';
        }
        field(13; "JMC Method"; Enum "JMC Cost Allocation Method")
        {
            Caption = 'Saved Allocation Method', Comment = 'ESP="Método de reparto guardado"';
        }
        field(14; "JMC Description"; Text[100])
        {
            Caption = 'Saved Source Description', Comment = 'ESP="Descripción de origen guardada"';
            ToolTip = 'Shows the account and movement description, or the product description, copied when calculating. Later description changes do not change this saved text.', Comment = 'ESP="Muestra la descripción de la cuenta y del movimiento, o la del producto, copiada al calcular. Los cambios posteriores de descripción no modifican este texto guardado."';
        }
        field(15; "JMC Formula"; Text[100])
        {
            Caption = 'Saved Calculation Formula', Comment = 'ESP="Fórmula de cálculo guardada"';
            ToolTip = 'Shows the calculation used for this row. The letters refer to the A, B and C value columns on the same row. Source movements have no formula because their amounts are taken directly.', Comment = 'ESP="Muestra la operación utilizada para esta fila. Las letras corresponden a las columnas de valores A, B y C de esa misma fila. Los movimientos de origen no tienen fórmula porque se toma su importe directamente."';
        }
        field(16; "JMC Operand A"; Decimal)
        {
            Caption = 'Saved Operand A', Comment = 'ESP="Operando A guardado"';
            ToolTip = 'Shows the value marked A in this row formula. In product allocations it measures how much the product counts in the distribution; in unit groups it is the value of the group recipes.', Comment = 'ESP="Es el valor marcado como A en la fórmula de esta fila. En repartos a productos mide cuánto cuenta el producto al distribuir el dinero; en grupos de unidad es el valor de las recetas del grupo."';
            DecimalPlaces = 2 : 2;
        }
        field(17; "JMC Operand B"; Decimal)
        {
            Caption = 'Saved Operand B', Comment = 'ESP="Operando B guardado"';
            ToolTip = 'Shows the value marked B in this row formula. In product allocations it is the sum of the weights of the products participating together. It is used to calculate each share, not as an extra cost.', Comment = 'ESP="Es el valor marcado como B en la fórmula de esta fila. En repartos a productos es la suma de los pesos de los productos que participan juntos. Sirve para calcular cada parte, no es un coste adicional."';
            DecimalPlaces = 2 : 2;
        }
        field(18; "JMC Operand C"; Decimal)
        {
            Caption = 'Saved Operand C', Comment = 'ESP="Operando C guardado"';
            ToolTip = 'Shows the money to distribute in formulas that use C. For a product it is the fund available to its group or business; for a unit group it is the business fund. It is not an additional amount.', Comment = 'ESP="Es el dinero que se reparte en las fórmulas que utilizan C. Para un producto es el fondo disponible para su grupo o negocio; para un grupo de unidad es el fondo del negocio. No es un importe adicional."';
            DecimalPlaces = 2 : 2;
        }
        field(19; "JMC Raw Result"; Decimal)
        {
            Caption = 'Result before Rounding', Comment = 'ESP="Resultado antes de redondeo"';
            ToolTip = 'Shows this row result before rounding or adjusting the final remaining amount. The saved result can differ slightly so that all allocated amounts match the available fund.', Comment = 'ESP="Es el resultado de esta fila antes de redondear o ajustar el importe que queda al final. El resultado guardado puede variar ligeramente para que todo lo repartido coincida con el fondo disponible."';
            DecimalPlaces = 2 : 2;
        }
        field(20; "JMC Result"; Decimal)
        {
            Caption = 'Saved Result or Contribution', Comment = 'ESP="Resultado o aportación guardados"';
            ToolTip = 'Shows how much this row contributes. In product allocations it is the money assigned to the product. Do not add different levels together, because that would count the same money more than once.', Comment = 'ESP="Muestra cuánto aporta esta fila. En repartos a productos es el dinero asignado al producto. No sume niveles distintos, porque contaría el mismo dinero más de una vez."';
            DecimalPlaces = 2 : 2;
        }
        field(21; "JMC Rounding Difference"; Decimal)
        {
            Caption = 'Rounding or Residual Difference', Comment = 'ESP="Diferencia de redondeo o residuo"';
            ToolTip = 'Shows this row saved result minus its result before rounding. It explains adjustments needed to distribute the fund exactly; it does not add another expense.', Comment = 'ESP="Es el resultado guardado de esta fila menos su resultado antes de redondear. Explica los ajustes necesarios para repartir exactamente el fondo; no añade otro gasto."';
            DecimalPlaces = 2 : 2;
        }
        field(22; "JMC Source Amount"; Decimal)
        {
            Caption = 'Original Saved Amount', Comment = 'ESP="Importe original guardado"';
            ToolTip = 'Shows the amount copied from the source movement, with its original sign. A production movement can have an original amount but contribute nothing if it was excluded. Check Included and the reason.', Comment = 'ESP="Es el importe copiado del movimiento de origen, con su signo original. Un movimiento de producción puede tener importe y no aportar nada si fue excluido. Consulte Incluido y el motivo."';
            DecimalPlaces = 2 : 2;
        }
        field(23; "JMC Included"; Boolean)
        {
            Caption = 'Included when Calculated', Comment = 'ESP="Incluido al calcular"';
            ToolTip = 'Indicates whether this row participated in the saved calculation. If not selected, check the exclusion reason. Included rows at different levels still describe steps of the same calculation and must not all be added together.', Comment = 'ESP="Indica si esta fila participó en el cálculo guardado. Si no está marcada, consulte el motivo de exclusión. Las filas incluidas de distintos niveles siguen siendo pasos del mismo cálculo y no deben sumarse todas."';
        }
        field(24; "JMC Issue"; Text[250])
        {
            Caption = 'Saved Exclusion or Pending Reason', Comment = 'ESP="Motivo de exclusión o pendiente guardado"';
            ToolTip = 'Explains why a movement or product was excluded, or why money could not be distributed. The reason is the one saved when calculating; correcting the source requires recalculating to update this detail.', Comment = 'ESP="Explica por qué se excluyó un movimiento o producto, o por qué no se pudo repartir un importe. Es el motivo guardado al calcular; si corrige el origen, debe recalcular para actualizar este detalle."';
        }
        field(25; "JMC Quantity"; Decimal)
        {
            Caption = 'Saved Movement or Sales Quantity', Comment = 'ESP="Cantidad de movimiento o venta guardada"';
            ToolTip = 'Shows the production movement quantity in the base unit, or the production quantity used for an allocation in its line unit. Do not add different units together.', Comment = 'ESP="Muestra la cantidad del movimiento de producción en unidad base o la cantidad de fabricación utilizada para un reparto en la unidad de la línea. No sume unidades diferentes."';
            DecimalPlaces = 2 : 2;
        }
        field(26; "JMC Calculated At"; DateTime)
        {
            Caption = 'Breakdown Calculation Time', Comment = 'ESP="Fecha y hora del cálculo del desglose"';
        }
        field(27; "JMC Starting Date"; Date)
        {
            Caption = 'Breakdown Starting Date', Comment = 'ESP="Fecha inicial del desglose"';
        }
        field(28; "JMC Ending Date"; Date)
        {
            Caption = 'Breakdown Ending Date', Comment = 'ESP="Fecha final del desglose"';
        }
        field(29; "JMC Account Filter"; Text[250])
        {
            Caption = 'Saved Accounting Filter', Comment = 'ESP="Filtro contable guardado"';
        }
        field(30; "JMC Rounding Precision"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Amounts are always rounded to 0.01, so no rounding precision is saved.';
            ObsoleteTag = '27.5.0.50';
            Caption = 'Saved Monetary Rounding Precision', Comment = 'ESP="Precisión de redondeo monetario guardada"';
            DecimalPlaces = 2 : 2;
        }
        field(31; "JMC Base Quantity"; Decimal)
        {
            Caption = 'Saved Net Base Quantity', Comment = 'ESP="Cantidad base neta guardada"';
            ToolTip = 'Shows the production quantity used for the allocation converted to the product base unit.', Comment = 'ESP="Muestra la cantidad de fabricación utilizada para el reparto convertida a la unidad base del producto."';
            DecimalPlaces = 2 : 2;
        }
        field(32; "JMC Base Recipe Cost"; Decimal)
        {
            Caption = 'Saved Base Recipe Unit Cost', Comment = 'ESP="Coste receta por unidad base guardado"';
            ToolTip = 'Shows the recipe cost used for one base unit of the product when calculating. It is not the selling price or the amount allocated to that product.', Comment = 'ESP="Es el coste de receta utilizado para una unidad base del producto al calcular. No es el precio de venta ni el importe de estructura asignado al producto."';
            DecimalPlaces = 2 : 2;
        }
        field(33; "JMC Priority Factor"; Decimal)
        {
            Caption = 'Saved Applied Priority Factor', Comment = 'ESP="Factor de prioridad aplicado guardado"';
            ToolTip = 'Shows the priority percentage applied to this line weight as a multiplier, for example 0.8 for 80 percent. A higher value gives it a larger relative share. This is the value saved when calculating, not necessarily the current setting.', Comment = 'ESP="Es el porcentaje de la prioridad aplicado al peso de esta línea como multiplicador, por ejemplo 0,8 para el 80 %. Un valor mayor le da una participación relativa mayor. Es el valor guardado al calcular y puede no coincidir con la configuración actual."';
            DecimalPlaces = 2 : 2;
        }
        field(34; "JMC Priority Level"; Integer)
        {
            Caption = 'Saved Item Priority Level', Comment = 'ESP="Nivel de prioridad del producto guardado"';
            ToolTip = 'Shows the priority from 1 to 5 that the item had on its card when calculating. It selects the percentage applied to the distribution. Changing the priority later does not change this saved breakdown.', Comment = 'ESP="Es la prioridad del 1 al 5 que tenía el producto en su ficha al calcular. Determina el porcentaje aplicado al reparto. Cambiar la prioridad después no modifica este desglose guardado."';
        }
    }

    keys
    {
        key(PK; "JMC Model Code", "JMC Entry No.")
        {
            Clustered = true;
        }
        key(Summary; "JMC Model Code", "JMC Detail Type", "JMC Summary Field No.")
        {
        }
    }
}
