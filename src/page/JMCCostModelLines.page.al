page 53124 "JMC Cost Model Lines"
{
    Caption = 'Products', Comment = 'ESP="Productos"';
    PageType = ListPart;
    SourceTable = "JMC Cost Model Line";
    SourceTableView = sorting("JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method");
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("JMC Item No."; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifies the product for this row. The model has one row per product, in its base unit.', Comment = 'ESP="Identifica el producto de esta línea. El modelo tiene una línea por producto, en su unidad base."';
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
                    ToolTip = 'Shows the calculated industrial, full management and personnel costs, without recipe cost. It is in euros per row unit for the Amount type and the sum of their percentages for the Percentage type. Compare it with Final Manual Cost.', Comment = 'ESP="Muestra los costes industrial, completo de gestión y de personal, sin coste de receta. Está en euros por unidad de la línea con el tipo Importe y es la suma de sus porcentajes con el tipo Porcentaje. Compárelo con Coste final manual."';
                }
                field("JMC Final Cost"; Rec."JMC Final Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the manual structure cost. Calculate All Costs reads C01 from the recipe; Recalculate Costs keeps the manual value. Use the CA or PT apply action to update the recipe.', Comment = 'ESP="Muestra el coste manual de estructura. Calcular todos los costes lee C01 de la receta; Recalcular costes conserva el valor manual. Use la acción de aplicar CA o PT para actualizar la receta."';
                    Editable = Rec."JMC Manual Totals Ready" and Rec."JMC Structure Totals Ready";
                    Style = Ambiguous;
                    StyleExpr = true;

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
                    Style = Unfavorable;
                    StyleExpr = Rec."JMC Cost Difference" < 0;
                }
                field("JMC Actual Production Qty."; Rec."JMC Actual Production Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net production in the period in the product base unit.', Comment = 'ESP="Muestra la fabricación neta del periodo en la unidad base del producto."';
                }
                field("JMC Theoretical Production Qty."; Rec."JMC Theoretical Production Qty.")
                {
                    ApplicationArea = All;
                    Editable = Rec."JMC Production Inputs Ready";
                    Style = Ambiguous;
                    StyleExpr = true;
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
                    Editable = false;
                    ToolTip = 'Shows the product base unit used for quantities and unit costs.', Comment = 'ESP="Muestra la unidad base del producto utilizada para las cantidades y los costes unitarios."';
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
                    ToolTip = 'Shows fixed and direct personnel cost per unit, kept as a separate cost component and included in Total Cost and EXWORK Standard.', Comment = 'ESP="Muestra el coste fijo y directo de personal por unidad, como partida independiente incluida en Total coste y EXWORK estándar."';
                }
                field("JMC Personnel Cost Pct."; Rec."JMC Personnel Cost Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows personnel cost as a percentage of recipe cost for the same unit.', Comment = 'ESP="Muestra el coste de personal como porcentaje del coste de receta para la misma unidad."';
                }
                field("JMC EXWORK Standard"; Rec."JMC EXWORK Standard")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows calculated industrial, full management and personnel costs per row unit, without recipe cost. It does not use Final Manual Cost and does not update the standard cost on the product card.', Comment = 'ESP="Muestra los costes industrial, completo de gestión y de personal calculados por unidad de la línea, sin incluir el coste de receta. No utiliza Coste final manual ni actualiza el coste estándar de la ficha del producto."';
                }
                field("JMC Net Sales Quantity"; Rec."JMC Net Sales Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net sales in the product base unit during the period, including all sales units and uninvoiced shipments.', Comment = 'ESP="Muestra las ventas netas del periodo en la unidad base del producto, incluidas todas las unidades de venta y los envíos pendientes de facturar."';
                }
                field("JMC Net Sales Base Qty."; Rec."JMC Net Sales Base Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows net sales across all presentations in the product base unit. This is the same quantity as Net Sales Quantity, not an additional quantity.', Comment = 'ESP="Muestra las ventas netas de todas las presentaciones en la unidad base del producto. Es la misma cantidad que Cantidad neta de venta, no una cantidad adicional."';
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
                    ToolTip = 'Shows the total fixed and direct personnel amount assigned to this product and unit for the whole period. It is a separate component included in Total Cost.', Comment = 'ESP="Muestra el importe total de personal fijo y directo asignado a este producto y unidad para todo el periodo. Es una partida independiente incluida en Total coste."';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JMCC01CostHistory)
            {
                Caption = 'Structure Cost History', Comment = 'ESP="Histórico costes de estructura"';
                ToolTip = 'Shows the C01 costs applied to the selected product and allows you to fix a historical value.', Comment = 'ESP="Muestra los costes C01 aplicados al producto seleccionado y permite fijar un valor histórico."';
                ApplicationArea = All;
                Image = History;
                RunObject = page "JMC C01 Cost History";
                RunPageLink = "JMC Item No." = field("JMC Item No.");
            }
            action(JMCRecalculateCosts)
            {
                Caption = 'Recalculate Costs', Comment = 'ESP="Recalcular costes"';
                ToolTip = 'Redistributes the saved costs using the theoretical production quantities without rereading accounting, production or recipes.', Comment = 'ESP="Redistribuye los costes guardados usando las cantidades teóricas de fabricación sin volver a leer contabilidad, producción ni recetas."';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                var
                    jmcCalculation: Codeunit "JMC Cost Model Calculation";
                    jmcModel: Record "JMC Cost Model";
                    jmcLine: Record "JMC Cost Model Line";
                    jmcCompletedLbl: Label 'Costs recalculated using the theoretical production quantities.', Comment = 'ESP="Costes recalculados con las cantidades teóricas de fabricación."';
                    jmcPartialLbl: Label 'Costs recalculated. Lines with issues: %1. Unallocated personnel cost: %2. Review the issues and unallocated accounting costs in the model. Personnel cost remains unallocated when a business has no eligible production quantity.', Comment = 'ESP="Costes recalculados. Líneas con incidencia: %1. Coste de personal sin repartir: %2. Revise las incidencias y los costes contables pendientes en el modelo. El coste de personal queda sin repartir cuando un negocio no tiene cantidad de fabricación apta."';
                begin
                    CurrPage.SaveRecord();
                    jmcCalculation.RecalculateProduction(Rec."JMC Model Code");
                    jmcModel.Get(Rec."JMC Model Code");
                    jmcLine.SetRange("JMC Model Code", Rec."JMC Model Code");
                    jmcLine.SetFilter("JMC Calculation Issue", '<>%1', '');
                    if (not jmcLine.IsEmpty()) or (jmcModel."JMC Sales Pending Industrial" <> 0) or (jmcModel."JMC Sales Pending Management" <> 0) or (jmcModel."JMC Resource Cost Pending" <> 0) then
                        Message(jmcPartialLbl, jmcLine.Count(), jmcModel."JMC Resource Cost Pending")
                    else
                        Message(jmcCompletedLbl);
                    CurrPage.Update(false);
                end;
            }
            action(JMCApplyCACostToRecipe)
            {
                Caption = 'Apply Final Cost to CA Recipes', Comment = 'ESP="Aplicar coste final a recetas CA"';
                ToolTip = 'Applies the manual structure cost of eligible CA, MP and MA products to C01 in recipe version 0. Unchanged values are not recorded in the history; ineligible lines are skipped.', Comment = 'ESP="Aplica el coste manual de estructura de los productos CA, MP y MA aptos al C01 de la versión 0 de receta. Los valores sin cambios no se guardan en el histórico; se omiten las líneas no aptas."';
                ApplicationArea = All;
                Image = Apply;

                trigger OnAction()
                begin
                    ApplyCostToBusiness(Enum::"JMC Business Line Filter"::Catering, 'CA, MP, MA');
                end;
            }
            action(JMCApplyPTCostToRecipe)
            {
                Caption = 'Apply Final Cost to PT Recipes', Comment = 'ESP="Aplicar coste final a recetas PT"';
                ToolTip = 'Applies the manual structure cost of eligible PT, PI, PR and SER products to C01 in recipe version 0. Unchanged values are not recorded in the history; ineligible lines are skipped.', Comment = 'ESP="Aplica el coste manual de estructura de los productos PT, PI, PR y SER aptos al C01 de la versión 0 de receta. Los valores sin cambios no se guardan en el histórico; se omiten las líneas no aptas."';
                ApplicationArea = All;
                Image = Apply;

                trigger OnAction()
                begin
                    ApplyCostToBusiness(Enum::"JMC Business Line Filter"::Industry, 'PT, PI, PR, SER');
                end;
            }
        }
    }

    local procedure ApplyCostToBusiness(jmcBusiness: Enum "JMC Business Line Filter"; jmcPrefix: Text)
    var
        jmcCompanyInfo: Record "Company Information";
        jmcRecipeCosts: Codeunit "JMC Structure Recipe Costs";
        jmcChangedItems: List of [Text];
        jmcRecipients: Text;
        jmcNotificationError: Text;
        jmcApplied: Integer;
        jmcUnchanged: Integer;
        jmcSkipped: Integer;
        jmcConfirmLbl: Label 'Apply the final manual cost of all eligible %1 products in this model to C01 in their recipes? Lines with calculation issues will be skipped. The existing cost type is preserved.', Comment = 'ESP="¿Aplicar el coste final manual de todos los productos %1 aptos de este modelo a C01 en sus recetas? Se omitirán las líneas con incidencias de cálculo. Se conservará el tipo de coste existente."';
        jmcAppliedLbl: Label 'Final cost applied to %1 recipes. Recipes with no change: %2. Lines skipped due to calculation issues: %3. No standard cost calculation or posting has been run.', Comment = 'ESP="Coste final aplicado a %1 recetas. Recetas sin cambios: %2. Líneas omitidas por incidencias de cálculo: %3. No se ha ejecutado ningún cálculo de coste estándar ni registro contable."';
        jmcEmailSentLbl: Label 'The cost notification email was sent.', Comment = 'ESP="Se ha enviado el email de notificación de costes."';
        jmcEmailFailedLbl: Label 'The cost changes were saved, but the notification email could not be confirmed. Do not apply the costs again just to resend the email. Details: %1', Comment = 'ESP="Los cambios de coste se han guardado, pero no se ha podido confirmar el email de notificación. No vuelva a aplicar los costes solo para reenviar el email. Detalles: %1"';
    begin
        CurrPage.SaveRecord();
        if not Confirm(jmcConfirmLbl, false, jmcPrefix) then
            exit;
        if jmcCompanyInfo.Get() then
            case jmcBusiness of
                jmcBusiness::Catering:
                    jmcRecipients := jmcCompanyInfo."JMC CA Cost Email";
                jmcBusiness::Industry:
                    jmcRecipients := jmcCompanyInfo."JMC PT Cost Email";
            end;
        jmcRecipeCosts.ApplyModelForBusinessWithItems(Rec."JMC Model Code", jmcBusiness, jmcApplied, jmcUnchanged, jmcSkipped, jmcChangedItems);
        if (jmcRecipients <> '') and (jmcApplied > 0) then begin
            jmcRecipeCosts.SetNotification(jmcRecipients, jmcPrefix, jmcChangedItems);
            Commit();
            if not jmcRecipeCosts.Run() then begin
                jmcNotificationError := GetLastErrorText();
                Message(jmcAppliedLbl, jmcApplied, jmcUnchanged, jmcSkipped);
                Message(jmcEmailFailedLbl, jmcNotificationError);
                exit;
            end;
            Message(jmcAppliedLbl, jmcApplied, jmcUnchanged, jmcSkipped);
            Message(jmcEmailSentLbl);
            exit;
        end;
        Message(jmcAppliedLbl, jmcApplied, jmcUnchanged, jmcSkipped);
    end;
}
