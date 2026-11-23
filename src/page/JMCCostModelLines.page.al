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
                field("JMC Cost Value Type"; Rec."JMC Cost Value Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows whether structure cost C01 in the recipe is an Amount in euros or a Percentage of the recipe cost. It is read from the recipe when the model is calculated. With Percentage, Total Cost, Final Manual Cost and Cost Difference are percentages.', Comment = 'ESP="Muestra si el coste de estructura C01 de la receta es un Importe en euros o un Porcentaje sobre el coste de receta. Se lee de la receta al calcular el modelo. Con Porcentaje, Total coste, Coste final manual y Diferencia de coste son porcentajes."';
                }
                field("JMC Total Cost"; Rec."JMC Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the calculated industrial, full management and fixed resource personnel costs, without recipe cost. It is in euros per row unit for the Amount type and the sum of their percentages for the Percentage type. Compare it with Final Manual Cost.', Comment = 'ESP="Muestra los costes industrial, completo de gestión y fijo de personal de recursos, sin coste de receta. Está en euros por unidad de la línea con el tipo Importe y es la suma de sus porcentajes con el tipo Porcentaje. Compárelo con Coste final manual."';
                }
                field("JMC Final Cost"; Rec."JMC Final Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the manual structure cost. Calculate All Costs reads C01 from the recipe; Recalculate Costs keeps the manual value. Changes reach the recipe only through Apply Final Cost to Recipe.', Comment = 'ESP="Muestra el coste manual de estructura. Calcular todos los costes lee C01 de la receta; Recalcular costes conserva el valor manual. Los cambios solo llegan a la receta mediante Aplicar coste final a receta."';
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
                    Caption = 'Cost Difference', Comment = 'ESP="Diferencia coste"';
                }
                field("JMC Actual Production Qty."; Rec."JMC Actual Production Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net production in the period allocated to this sales unit in proportion to net base sales. When there are no sales, it is shown in the base unit.', Comment = 'ESP="Muestra la fabricación neta del periodo asignada a esta unidad de venta proporcionalmente a las ventas netas en unidad base. Si no hay ventas se muestra en unidad base."';
                }
                field("JMC Theoretical Production Qty."; Rec."JMC Theoretical Production Qty.")
                {
                    ApplicationArea = All;
                    Editable = Rec."JMC Production Inputs Ready";
                    ToolTip = 'Specifies the quantity in this line unit for Recalculate Costs. Initially it equals actual production. Zero excludes this line.', Comment = 'ESP="Especifica la cantidad en la unidad de esta línea para Recalcular costes. Inicialmente coincide con la fabricación real. Cero excluye esta línea."';
                }
                field("JMC Allocation Eligible"; Rec."JMC Allocation Eligible")
                {
                    ApplicationArea = All;
                    ToolTip = 'A check mark means that this row met the conditions to receive expenses in the last calculation. If it is not checked then read Calculation Issue. A zero cost on an ineligible row is not a valid calculated cost.', Comment = 'ESP="La marca indica que esta línea cumplió las condiciones para recibir gastos en el último cálculo. Si no está marcada consulte Incidencia del cálculo. Un coste a cero en una línea no apta no es un coste calculado válido."';
                }
                field("JMC Calculation Issue"; Rec."JMC Calculation Issue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Explains why this product and unit could not receive an allocation. Correct the quantity and recalculate costs, or calculate all costs again to refresh the source data.', Comment = 'ESP="Explica por qué este producto y unidad no han podido recibir reparto. Corrija la cantidad y recalcule costes, o calcule todos los costes para actualizar los datos de origen."';
                    Style = Attention;
                    StyleExpr = Rec."JMC Calculation Issue" <> '';
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
                field("JMC Industrial Cost"; Rec."JMC Industrial Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the industrial amount assigned to this row divided by its production quantity used in the calculation.', Comment = 'ESP="Muestra el importe industrial asignado a esta línea dividido entre la cantidad de fabricación utilizada en el cálculo."';
                }
                field("JMC Industrial Cost Pct."; Rec."JMC Industrial Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows industrial cost as a percentage of recipe cost for the same unit. For example 10 percent means industrial cost is one tenth of recipe cost. It is only a comparison and is not an extra cost to add.', Comment = 'ESP="Muestra el coste industrial como porcentaje del coste de receta para la misma unidad. Por ejemplo un diez por ciento significa que el coste industrial es la décima parte del coste de receta. Es solo una comparación y no otro coste que deba sumar."';
                }
                field("JMC Management Cost"; Rec."JMC Management Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the management amount assigned to this row divided by its production quantity used in the calculation.', Comment = 'ESP="Muestra el importe de gestión asignado a esta línea dividido entre la cantidad de fabricación utilizada en el cálculo."';
                }
                field("JMC Management Cost Pct."; Rec."JMC Management Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows management cost as a percentage of recipe cost for the same unit. For example 10 percent means management cost is one tenth of recipe cost. It is only a comparison and is not an extra cost to add.', Comment = 'ESP="Muestra el coste de gestión como porcentaje del coste de receta para la misma unidad. Por ejemplo un diez por ciento significa que el coste de gestión es la décima parte del coste de receta. Es solo una comparación y no otro coste que deba sumar."';
                }
                field("JMC Personnel Cost"; Rec."JMC Personnel Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows fixed resource personnel cost per unit, kept as a separate cost component and included in Total Cost and EXWORK Standard.', Comment = 'ESP="Muestra el coste fijo de personal de recursos por unidad, como partida independiente incluida en Total coste y EXWORK estándar."';
                }
                field("JMC Personnel Cost Pct."; Rec."JMC Personnel Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows personnel cost as a percentage of recipe cost for the same unit.', Comment = 'ESP="Muestra el coste de personal como porcentaje del coste de receta para la misma unidad."';
                }
                field("JMC EXWORK Standard"; Rec."JMC EXWORK Standard")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows calculated industrial, full management and fixed resource personnel costs per row unit, without recipe cost. It does not use Final Manual Cost and does not update the standard cost on the product card.', Comment = 'ESP="Muestra los costes industrial, completo de gestión y fijo de personal calculados por unidad de la línea, sin incluir el coste de receta. No utiliza Coste final manual ni actualiza el coste estándar de la ficha del producto."';
                }
                field("JMC Net Sales Quantity"; Rec."JMC Net Sales Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net sales in this row unit during the period, including uninvoiced shipments. Sales determine the distribution of production between the item''s sales units.', Comment = 'ESP="Muestra las ventas netas del periodo en la unidad de esta línea, incluidos envíos pendientes de facturar. Las ventas determinan el reparto de la fabricación entre las unidades de venta del producto."';
                }
                field("JMC Net Sales Base Qty."; Rec."JMC Net Sales Base Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows this row sales quantity converted to the product base unit using the conversions saved in its entries. Returns are subtracted and sales in other presentations are excluded. It is not another quantity to add to net sales.', Comment = 'ESP="Muestra la cantidad vendida de esta línea convertida a la unidad base del producto con las conversiones guardadas en sus movimientos. Se descuentan devoluciones y no se incluyen ventas de otras presentaciones. No es otra cantidad que deba sumar a las ventas netas."';
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
                field("JMC Assigned Personnel Cost"; Rec."JMC Assigned Personnel Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the total fixed resource personnel amount assigned to this product and unit for the whole period. It is a separate component included in Total Cost.', Comment = 'ESP="Muestra el importe total de personal de recursos fijos asignado a este producto y unidad para todo el periodo. Es una partida independiente incluida en Total coste."';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JMCRecalculateCosts)
            {
                Caption = 'Recalculate Costs', Comment = 'ESP="Recalcular costes"';
                ToolTip = 'Redistributes the saved funds using the theoretical production quantities without rereading accounting, production or recipes.', Comment = 'ESP="Redistribuye los fondos guardados usando las cantidades teóricas de fabricación sin volver a leer contabilidad, producción ni recetas."';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                var
                    jmcCalculation: Codeunit "JMC Cost Model Calculation";
                    jmcModel: Record "JMC Cost Model";
                    jmcLine: Record "JMC Cost Model Line";
                    jmcCompletedLbl: Label 'Costs recalculated using the theoretical production quantities.', Comment = 'ESP="Costes recalculados con las cantidades teóricas de fabricación."';
                    jmcPartialLbl: Label 'Costs recalculated. Lines with issues: %1. Review the issues and the funds pending allocation in the model.', Comment = 'ESP="Costes recalculados. Líneas con incidencia: %1. Revise las incidencias y los fondos pendientes de reparto en el modelo."';
                begin
                    CurrPage.SaveRecord();
                    jmcCalculation.RecalculateProduction(Rec."JMC Model Code");
                    jmcModel.Get(Rec."JMC Model Code");
                    jmcLine.SetRange("JMC Model Code", Rec."JMC Model Code");
                    jmcLine.SetFilter("JMC Calculation Issue", '<>%1', '');
                    if (not jmcLine.IsEmpty()) or (jmcModel."JMC Sales Pending Industrial" <> 0) or (jmcModel."JMC Sales Pending Management" <> 0) or (jmcModel."JMC Resource Cost Pending" <> 0) then
                        Message(jmcPartialLbl, jmcLine.Count())
                    else
                        Message(jmcCompletedLbl);
                    CurrPage.Update(false);
                end;
            }
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
