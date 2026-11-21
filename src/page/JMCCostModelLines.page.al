page 53124 "JMC Cost Model Lines"
{
    Caption = 'Products', Comment = 'ESP="Productos"';
    PageType = ListPart;
    SourceTable = "JMC Cost Model Line";
    SourceTableView = sorting("JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method");
    DelayedInsert = true;
    MultipleNewLines = true;
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("JMC Item No."; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the product for this row. Its results belong only to the unit shown in this row. Changing the product requires calculating the model again.', Comment = 'ESP="Identifica el producto de esta línea. Sus resultados corresponden solo a la unidad de esta línea. Si cambia el producto debe volver a calcular el modelo."';
                }
                field("JMC Item Description"; Rec."JMC Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the product name saved in the model. It helps identify the row and does not change how expenses are distributed.', Comment = 'ESP="Muestra el nombre del producto guardado en el modelo. Sirve para identificar la línea y no cambia cómo se reparten los gastos."';
                }
                field("JMC Allocation Eligible"; Rec."JMC Allocation Eligible")
                {
                    ApplicationArea = All;
                    ToolTip = 'A check mark means that this row met the conditions to receive expenses in the last calculation. If it is not checked then read Calculation Issue. A zero cost on an ineligible row is not a valid calculated cost.', Comment = 'ESP="La marca indica que esta línea cumplió las condiciones para recibir gastos en el último cálculo. Si no está marcada consulte Incidencia del cálculo. Un coste a cero en una línea no apta no es un coste calculado válido."';
                }
                field("JMC Calculation Issue"; Rec."JMC Calculation Issue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Explains why this product and unit could not receive an allocation. Correct the cause and run Calculate All Costs again to update the row.', Comment = 'ESP="Explica por qué este producto y unidad no han podido recibir reparto. Corrija la causa y ejecute de nuevo Calcular todos los costes para actualizar la línea."';
                    Style = Attention;
                    StyleExpr = Rec."JMC Calculation Issue" <> '';
                }
                field("JMC Cost Value Type"; Rec."JMC Cost Value Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows whether structure cost C01 in the recipe is an Amount in euros or a Percentage of the recipe cost. It is read from the recipe when the model is calculated. With Percentage, Total Cost, Final Manual Cost and Cost Difference are percentages.', Comment = 'ESP="Muestra si el coste de estructura C01 de la receta es un Importe en euros o un Porcentaje sobre el coste de receta. Se lee de la receta al calcular el modelo. Con Porcentaje, Total coste, Coste final manual y Diferencia de coste son porcentajes."';
                }
                field("JMC Total Cost"; Rec."JMC Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the calculated industrial cost plus full management cost, without recipe cost. It is in euros per row unit for the Amount type and the sum of the industrial and management percentages for the Percentage type. Compare it with Final Manual Cost.', Comment = 'ESP="Muestra el coste industrial más el coste completo de gestión calculados, sin coste de receta. Está en euros por unidad de la línea con el tipo Importe y es la suma de los porcentajes industrial y de gestión con el tipo Porcentaje. Compárelo con Coste final manual."';
                }
                field("JMC Final Cost"; Rec."JMC Final Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the structure cost kept in the recipe for this row, read from structure cost C01 when the model was calculated: euros per row unit, or the percentage itself for the Percentage type. You can edit it, but the change reaches the recipe only through Apply Final Cost to Recipe. Recalculating reads it from the recipe again.', Comment = 'ESP="Muestra el coste de estructura que se mantiene en la receta para esta línea, leído del coste de estructura C01 al calcular el modelo: euros por unidad de la línea, o el propio porcentaje con el tipo Porcentaje. Puede editarlo, pero el cambio solo llega a la receta mediante Aplicar coste final a receta. Al recalcular se vuelve a leer de la receta."';
                    Editable = Rec."JMC Manual Totals Ready" and Rec."JMC Structure Totals Ready";

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
                field("JMC Cost Difference"; Rec."JMC Cost Difference")
                {
                    ApplicationArea = All;
                }
                field("JMC Recipe BOM Cost"; Rec."JMC Recipe BOM Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the recipe cost read when the model was calculated and expressed per row unit. It is hidden by default and is not part of the structure totals.', Comment = 'ESP="Muestra el coste de receta leído al calcular el modelo y expresado por unidad de la línea. Está oculto de forma predeterminada y no forma parte de los totales de estructura."';
                    Visible = false;
                }
                field("JMC Unit of Measure Code"; Rec."JMC Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the sales unit for this row. Unit costs refer to one unit of this presentation and quantities include only its sales. Changing it requires calculating again. Do not add quantities in different units.', Comment = 'ESP="Identifica la unidad de venta de esta línea. Los costes unitarios corresponden a una unidad de esta presentación y las cantidades incluyen solo sus ventas. Si la cambia debe volver a calcular. No sume cantidades de unidades diferentes."';
                }
                field("JMC Priority Level"; Rec."JMC Priority Level")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the priority of the product, from 1 to 5, copied from its item card when the model was calculated. It cannot be edited here. Its percentage in Priority Factors gives the line more or less share of the expenses.', Comment = 'ESP="Muestra la prioridad del producto, del 1 al 5, copiada de su ficha al calcular el modelo. No se puede editar aquí. Su porcentaje en Factores de prioridad da a la línea más o menos parte de los gastos."';
                }
                field("JMC Industrial Cost"; Rec."JMC Industrial Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the industrial amount assigned to this row divided by its net sales quantity. It is a cost per row unit and is included in TOTAL COST. Editing Final Manual Cost does not change this calculated value.', Comment = 'ESP="Muestra el importe industrial asignado a esta línea dividido entre su cantidad neta vendida. Es un coste por unidad de la línea y está incluido en TOTAL COSTE. Cambiar Coste final manual no modifica este valor calculado."';
                }
                field("JMC Industrial Cost Pct."; Rec."JMC Industrial Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows industrial cost as a percentage of recipe cost for the same unit. For example 10 percent means industrial cost is one tenth of recipe cost. It is only a comparison and is not an extra cost to add.', Comment = 'ESP="Muestra el coste industrial como porcentaje del coste de receta para la misma unidad. Por ejemplo un diez por ciento significa que el coste industrial es la décima parte del coste de receta. Es solo una comparación y no otro coste que deba sumar."';
                }
                field("JMC Management Cost"; Rec."JMC Management Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the management amount assigned to this row divided by its net sales quantity. It is the management cost per row unit and does not include industrial or recipe cost. It is included in TOTAL COST.', Comment = 'ESP="Muestra el importe de gestión asignado a esta línea dividido entre su cantidad neta vendida. Es el coste de gestión por unidad de la línea y no incluye el coste industrial ni el de receta. Está incluido en TOTAL COSTE."';
                }
                field("JMC Management Cost Pct."; Rec."JMC Management Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows management cost as a percentage of recipe cost for the same unit. For example 10 percent means management cost is one tenth of recipe cost. It is only a comparison and is not an extra cost to add.', Comment = 'ESP="Muestra el coste de gestión como porcentaje del coste de receta para la misma unidad. Por ejemplo un diez por ciento significa que el coste de gestión es la décima parte del coste de receta. Es solo una comparación y no otro coste que deba sumar."';
                }
                field("JMC EXWORK Standard"; Rec."JMC EXWORK Standard")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows calculated industrial cost plus full management cost per row unit, without recipe cost. It does not use Final Manual Cost and does not update the standard cost on the product card.', Comment = 'ESP="Muestra el coste industrial más el coste completo de gestión calculados por unidad de la línea, sin incluir el coste de receta. No utiliza Coste final manual ni actualiza el coste estándar de la ficha del producto."';
                }
                field("JMC Net Sales Quantity"; Rec."JMC Net Sales Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the quantity sold in this row unit during the period after subtracting returns. It includes posted shipments not yet invoiced. Assigned amounts are divided by this quantity to obtain unit costs.', Comment = 'ESP="Muestra la cantidad vendida en la unidad de esta línea durante el periodo tras descontar devoluciones. Incluye los envíos registrados pendientes de facturar. Los importes asignados se dividen entre esta cantidad para obtener los costes unitarios."';
                }
                field("JMC Net Sales Base Qty."; Rec."JMC Net Sales Base Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows this row sales quantity converted to the product base unit using the conversions saved in its entries. Returns are subtracted and sales in other presentations are excluded. It is not another quantity to add to net sales.', Comment = 'ESP="Muestra la cantidad vendida de esta línea convertida a la unidad base del producto con las conversiones guardadas en sus movimientos. Se descuentan devoluciones y no se incluyen ventas de otras presentaciones. No es otra cantidad que deba sumar a las ventas netas."';
                }
                field("JMC Applied Priority Factor"; Rec."JMC Applied Priority Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the priority percentage used in the last calculation as a multiplier, for example 1 for 100 percent and 0.8 for 80 percent. A larger value gives more share of the expenses. If you change the item priority or the percentages, calculate again to update this value.', Comment = 'ESP="Muestra el porcentaje de la prioridad utilizado en el último cálculo como multiplicador, por ejemplo 1 para el 100 % y 0,8 para el 80 %. Un valor mayor da más parte de los gastos. Si cambia la prioridad del producto o los porcentajes, debe volver a calcular para actualizar este valor."';
                }
                field("JMC Assigned Industrial Cost"; Rec."JMC Assigned Industrial Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the total industrial expense assigned to this product and unit for the whole period. It is not a unit cost. These amounts can be added across the lines of the calculation.', Comment = 'ESP="Muestra el gasto industrial total asignado a este producto y unidad para todo el periodo. No es un coste unitario. Estos importes pueden sumarse entre las líneas del cálculo."';
                }
                field("JMC Assigned Management Cost"; Rec."JMC Assigned Management Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the total management expense assigned to this product and unit for the whole period. It is not a unit cost. These amounts can be added across the lines of the calculation.', Comment = 'ESP="Muestra el gasto de gestión total asignado a este producto y unidad para todo el periodo. No es un coste unitario. Estos importes pueden sumarse entre las líneas del cálculo."';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JMCApplyCostToRecipe)
            {
                Caption = 'Apply Final Cost to Recipe', Comment = 'ESP="Aplicar coste final a receta"';
                ToolTip = 'Applies this row''s manual structure amount to existing C01 in recipe version 0, converting euros to base units. C01 must already use Amount; its type and other recipe costs are not changed.', Comment = 'ESP="Aplica el importe manual de estructura de esta línea a C01 existente en la versión 0 de receta, convirtiendo euros a unidad base. C01 debe estar ya en Importe; no se cambia su tipo ni otros costes de receta."';
                ApplicationArea = All;
                Image = Apply;

                trigger OnAction()
                var
                    jmcRecipeCosts: Codeunit "JMC Structure Recipe Costs";
                    jmcConfirmLbl: Label 'Apply final structure cost %1 (%2) from item %3 and unit %4 to the current recipe? The manual cost replaces the Value of C01, converted to the base unit for an amount or as the percentage itself, without subtracting recipe cost. C01 must have the same type as the line and allow editing; its type and other costs remain unchanged.', Comment = 'ESP="¿Aplicar coste final de estructura %1 (%2) del producto %3 y unidad %4 a la receta actual? El coste manual sustituye el Valor de C01, convertido a unidad base si es un importe o como el propio porcentaje, sin restar la receta. C01 debe tener el mismo tipo que la línea y permitir edición; su tipo y los demás costes no cambian."';
                    jmcAppliedLbl: Label 'Final cost applied through C01 for item %1. No standard cost calculation or posting has been run.', Comment = 'ESP="Coste final aplicado mediante C01 del producto %1. No se ha ejecutado ningún cálculo de coste estándar ni registro contable."';
                begin
                    CurrPage.SaveRecord();
                    Rec.TestManualTotals();
                    if not Confirm(jmcConfirmLbl, false, Rec."JMC Final Cost", Rec."JMC Cost Value Type", Rec."JMC Item No.", Rec."JMC Unit of Measure Code") then
                        exit;
                    jmcRecipeCosts.ApplyLine(Rec);
                    Message(jmcAppliedLbl, Rec."JMC Item No.");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."JMC Line No." := 0;
    end;
}
