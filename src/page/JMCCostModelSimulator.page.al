page 53126 "JMC Cost Model Simulator"
{
    Caption = 'Structure Cost Simulator', Comment = 'ESP="Simulador de costes de estructura"';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(SavedCalculation)
            {
                Caption = 'Saved Calculation', Comment = 'ESP="Cálculo guardado"';
                Editable = false;

                field(JMCModelCode; JMCModel."JMC Code")
                {
                    Caption = 'Model Code', Comment = 'ESP="Código modelo"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the model whose saved rates are used. No new allocation is calculated.', Comment = 'ESP="Especifica el modelo cuyas tasas guardadas se utilizan. No se calcula un nuevo reparto."';
                }
                field(JMCCalculatedAt; JMCModel."JMC Calculated At")
                {
                    Caption = 'Calculated At', Comment = 'ESP="Fecha y hora del cálculo"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the last full model calculation was saved.', Comment = 'ESP="Especifica cuándo se guardó el último cálculo completo del modelo."';
                }
                field(JMCStartingDate; JMCModel."JMC Starting Date")
                {
                    Caption = 'Calculation Starting Date', Comment = 'ESP="Fecha inicial del cálculo"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the saved calculation period.', Comment = 'ESP="Especifica la fecha inicial del periodo del cálculo guardado."';
                }
                field(JMCEndingDate; JMCModel."JMC Ending Date")
                {
                    Caption = 'Calculation Ending Date', Comment = 'ESP="Fecha final del cálculo"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the saved calculation period.', Comment = 'ESP="Especifica la fecha final del periodo del cálculo guardado."';
                }
                field(JMCScope; JMCScopeLbl)
                {
                    Caption = 'Scope', Comment = 'ESP="Alcance"';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(JMCWarning; JMCWarningLbl)
                {
                    Caption = 'Warning', Comment = 'ESP="Advertencia"';
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = JMCShowWarning;
                    Style = Attention;
                    StyleExpr = true;
                }
            }
            group(Simulation)
            {
                Caption = 'Simulation', Comment = 'ESP="Simulación"';

                field(JMCItemNo; JMCItemNo)
                {
                    Caption = 'Item No.', Comment = 'ESP="Nº producto"';
                    ApplicationArea = All;
                    Lookup = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the saved product to simulate. The lookup lists only product and unit combinations in this model.', Comment = 'ESP="Especifica el producto guardado que desea simular. La consulta solo muestra combinaciones de producto y unidad de este modelo."';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(SelectSavedUnit(false));
                    end;

                    trigger OnValidate()
                    begin
                        JMCPairs.Reset();
                        JMCPairs.SetRange("JMC Item No.", JMCItemNo);
                        if JMCItemNo = '' then
                            Clear(JMCUnitCode)
                        else begin
                            if not JMCPairs.FindFirst() then
                                Error(JMCNoProductErr, JMCItemNo);
                            JMCUnitCode := JMCPairs."JMC Unit of Measure Code";
                        end;
                        UpdateSimulation();
                    end;
                }
                field(JMCItemDescription; JMCItemDescription)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the product description saved in the model, not the current item master.', Comment = 'ESP="Especifica la descripción del producto guardada en el modelo, no la del maestro actual."';
                }
                field(JMCUnitCode; JMCUnitCode)
                {
                    Caption = 'Unit of Measure Code', Comment = 'ESP="Unidad de medida"';
                    ApplicationArea = All;
                    Lookup = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the saved sales unit. Rates from other units are not converted or substituted.', Comment = 'ESP="Especifica la unidad de venta guardada. No se convierten ni sustituyen tasas de otras unidades."';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(SelectSavedUnit(true));
                    end;

                    trigger OnValidate()
                    begin
                        UpdateSimulation();
                    end;
                }
                field(JMCQuantity; JMCQuantity)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 2;
                    MinValue = 0;
                    ToolTip = 'Specifies the quantity in the selected sales unit. It multiplies saved unit costs without redistributing the model costs.', Comment = 'ESP="Especifica la cantidad en la unidad de venta seleccionada. Multiplica los costes unitarios guardados sin redistribuir los costes del modelo."';

                    trigger OnValidate()
                    begin
                        UpdateSimulation();
                    end;
                }
            }
            group(Sales)
            {
                Caption = 'Calculation Against Products', Comment = 'ESP="Cálculo contra productos"';
                Editable = false;
                Visible = JMCHasSelection;

                field(JMCSalesIssue; JMCSalesIssue)
                {
                    Caption = 'Simulation Issue', Comment = 'ESP="Incidencia de la simulación"';
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = not JMCSalesAvailable;
                    Style = Attention;
                    StyleExpr = true;
                }
                group(SalesResults)
                {
                    ShowCaption = false;
                    Visible = JMCSalesAvailable;

                    field(JMCSalesRecipeUnitCost; JMCSalesLine."JMC Recipe BOM Cost")
                    {
                        Caption = 'Recipe Cost per Unit', Comment = 'ESP="Coste de receta por unidad"';
                        ApplicationArea = All;
                        Visible = false;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the saved recipe cost per selected unit. The current recipe is not read.', Comment = 'ESP="Especifica el coste de receta guardado por unidad seleccionada. No se consulta la receta actual."';
                    }
                    field(JMCSalesIndustrialUnitCost; JMCSalesLine."JMC Industrial Cost")
                    {
                        Caption = 'Industrial Cost per Unit', Comment = 'ESP="Coste industrial por unidad"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the final manual expense per unit allocated in the original industrial proportion.', Comment = 'ESP="Especifica el gasto final manual por unidad distribuido en la proporción industrial original."';
                    }
                    field(JMCSalesManagementUnitCost; JMCSalesLine."JMC Management Cost")
                    {
                        Caption = 'Management Cost per Unit', Comment = 'ESP="Coste de gestión por unidad"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the final manual expense per unit allocated in the original management proportion.', Comment = 'ESP="Especifica el gasto final manual por unidad distribuido en la proporción de gestión original."';
                    }
                    field(JMCSalesPersonnelUnitCost; JMCSalesLine."JMC Personnel Cost")
                    {
                        Caption = 'Personnel Cost per Unit', Comment = 'ESP="Coste de personal por unidad"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the fixed and direct personnel cost per unit, kept separately and included in the total.', Comment = 'ESP="Especifica el coste fijo y directo de personal por unidad, como partida independiente incluida en el total."';
                    }
                    field(JMCSalesIndustrialAmount; JMCSalesIndustrial)
                    {
                        Caption = 'Simulated Industrial Amount', Comment = 'ESP="Importe industrial simulado"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies quantity multiplied by the effective industrial rate from final manual expense, rounded to 0.01.', Comment = 'ESP="Especifica la cantidad por la tasa industrial efectiva del gasto final manual, redondeada a 0,01."';
                    }
                    field(JMCSalesManagementAmount; JMCSalesManagement)
                    {
                        Caption = 'Simulated Management Amount', Comment = 'ESP="Importe de gestión simulado"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies quantity multiplied by the effective management rate from final manual expense, rounded to 0.01.', Comment = 'ESP="Especifica la cantidad por la tasa de gestión efectiva del gasto final manual, redondeada a 0,01."';
                    }
                    field(JMCSalesPersonnelAmount; JMCSalesPersonnel)
                    {
                        Caption = 'Simulated Personnel Amount', Comment = 'ESP="Importe de personal simulado"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the simulated fixed and direct personnel amount.', Comment = 'ESP="Especifica el importe simulado de personal fijo y directo."';
                    }
                    field(JMCSalesStructureAmount; JMCSalesStructure)
                    {
                        Caption = 'Simulated Structure Amount', Comment = 'ESP="Importe de estructura simulado"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies simulated industrial, additional management and personnel amounts.', Comment = 'ESP="Especifica la suma de los importes industrial, adicional de gestión y personal simulados."';
                    }
                    field(JMCSalesEXWORKAmount; JMCSalesEXWORK)
                    {
                        Caption = 'Simulated EXWORK Amount', Comment = 'ESP="Importe EXWORK simulado"';
                        ApplicationArea = All;
                        DecimalPlaces = 2 : 2;
                        ToolTip = 'Specifies the simulated industrial, additional management and personnel amounts, without recipe cost. It is not a sales price.', Comment = 'ESP="Especifica los importes industrial, adicional de gestión y personal simulados, sin incluir el coste de receta. No es un precio de venta."';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        JMCModel.TestField("JMC Code");
        JMCModel.TestField("JMC Calculated At");
    end;

    procedure SetModel(jmcModelCode: Code[20])
    var
        jmcLine: Record "JMC Cost Model Line";
        jmcCheckModel: Record "JMC Cost Model";
        jmcChangedErr: Label 'The model changed while loading the simulator. Open the simulator again to use a consistent saved calculation.', Comment = 'ESP="El modelo cambió mientras se cargaba el simulador. Abra el simulador de nuevo para utilizar un cálculo guardado coherente."';
    begin
        JMCModel.Get(jmcModelCode);
        JMCModel.TestField("JMC Calculated At");
        JMCSavedLines.Reset();
        JMCSavedLines.DeleteAll(false);
        JMCPairs.Reset();
        JMCPairs.DeleteAll(false);
        JMCPairs.SetCurrentKey("JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method");
        JMCPairs.SetRange("JMC Model Code", jmcModelCode);
        jmcLine.SetRange("JMC Model Code", jmcModelCode);
        jmcLine.SetRange("JMC Allocation Method", jmcLine."JMC Allocation Method"::Sales);
        if not jmcLine.FindSet() then
            Error(JMCNoLinesErr);
        repeat
            JMCSavedLines := jmcLine;
            JMCSavedLines.Insert(false);
            JMCPairs.SetRange("JMC Item No.", jmcLine."JMC Item No.");
            JMCPairs.SetRange("JMC Unit of Measure Code", jmcLine."JMC Unit of Measure Code");
            if JMCPairs.IsEmpty() then begin
                JMCPairs := jmcLine;
                JMCPairs.Insert(false);
            end;
        until jmcLine.Next() = 0;
        jmcCheckModel.Get(jmcModelCode);
        if jmcCheckModel.SystemRowVersion <> JMCModel.SystemRowVersion then
            Error(jmcChangedErr);
        JMCShowWarning := not JMCModel."JMC Calculation Current";
        JMCQuantity := 1;
        Clear(JMCItemNo);
        Clear(JMCUnitCode);
        ClearSimulationResults();
        JMCHasSelection := false;
    end;

    local procedure SelectSavedUnit(jmcFilterItem: Boolean): Boolean
    var
        jmcLookup: Page "JMC Cost Simulation Lookup";
        jmcLine: Record "JMC Cost Model Line";
    begin
        JMCPairs.Reset();
        if jmcFilterItem and (JMCItemNo <> '') then
            JMCPairs.SetRange("JMC Item No.", JMCItemNo);
        jmcLookup.SetLines(JMCPairs);
        jmcLookup.LookupMode(true);
        if jmcLookup.RunModal() = Action::LookupOK then begin
            jmcLookup.GetRecord(jmcLine);
            JMCItemNo := jmcLine."JMC Item No.";
            JMCUnitCode := jmcLine."JMC Unit of Measure Code";
            UpdateSimulation();
        end;
        exit(true);
    end;

    local procedure ValidateSavedPair()
    var
        jmcNoUnitErr: Label 'No saved model line exists for item %1 and unit %2. Select a saved product and unit; rates from another unit are not substituted.', Comment = 'ESP="No existe una línea guardada del modelo para el producto %1 y la unidad %2. Seleccione un producto y unidad guardados; no se sustituyen tasas de otra unidad."';
    begin
        JMCPairs.Reset();
        JMCPairs.SetRange("JMC Item No.", JMCItemNo);
        JMCPairs.SetRange("JMC Unit of Measure Code", JMCUnitCode);
        if not JMCPairs.FindFirst() then
            Error(jmcNoUnitErr, JMCItemNo, JMCUnitCode);
        JMCItemDescription := JMCPairs."JMC Item Description";
    end;

    local procedure UpdateSimulation()
    begin
        ClearSimulationResults();
        JMCHasSelection := JMCItemNo <> '';
        if JMCHasSelection then begin
            ValidateSavedPair();
            JMCSalesAvailable := ReadSavedRate(JMCSalesLine, JMCSalesIssue);
            if JMCSalesAvailable then
                CalculateAmounts(JMCSalesLine, JMCSalesIndustrial, JMCSalesManagement, JMCSalesPersonnel, JMCSalesStructure, JMCSalesEXWORK);
        end;
        CurrPage.Update(false);
    end;

    local procedure ClearSimulationResults()
    begin
        Clear(JMCItemDescription);
        Clear(JMCSalesLine);
        Clear(JMCSalesIssue);
        Clear(JMCSalesIndustrial);
        Clear(JMCSalesManagement);
        Clear(JMCSalesPersonnel);
        Clear(JMCSalesStructure);
        Clear(JMCSalesEXWORK);
        JMCSalesAvailable := false;
    end;

    local procedure ReadSavedRate(var jmcLine: Record "JMC Cost Model Line"; var jmcIssue: Text[250]): Boolean
    var
        jmcNoRateLbl: Label 'No valid saved rate exists for this product and unit. Review its model line before simulating.', Comment = 'ESP="No existe una tasa guardada válida para este producto y unidad. Revise su línea del modelo antes de simular."';
        jmcOriginalExpense: Decimal;
    begin
        JMCSavedLines.Reset();
        JMCSavedLines.SetRange("JMC Item No.", JMCItemNo);
        JMCSavedLines.SetRange("JMC Unit of Measure Code", JMCUnitCode);
        JMCSavedLines.SetRange("JMC Allocation Method", JMCSavedLines."JMC Allocation Method"::Sales);
        if not JMCSavedLines.FindFirst() then begin
            jmcIssue := jmcNoRateLbl;
            exit(false);
        end;
        jmcLine := JMCSavedLines;
        if (not jmcLine."JMC Allocation Eligible") or (jmcLine."JMC Calculation Issue" <> '') then begin
            if jmcLine."JMC Calculation Issue" <> '' then
                jmcIssue := jmcLine."JMC Calculation Issue"
            else
                jmcIssue := jmcNoRateLbl;
            exit(false);
        end;
        if not jmcLine."JMC Manual Totals Ready" or not jmcLine."JMC Structure Totals Ready" then begin
            jmcIssue := JMCRecalculateManualLbl;
            exit(false);
        end;
        jmcOriginalExpense := jmcLine."JMC Industrial Cost" + jmcLine."JMC Management Cost" + jmcLine."JMC Personnel Cost";
        if (jmcOriginalExpense = 0) and (jmcLine.GetFinalExpenseAmount() <> 0) then begin
            jmcIssue := JMCNoSplitLbl;
            exit(false);
        end;
        if jmcOriginalExpense <> 0 then begin
            jmcLine."JMC Industrial Cost" := jmcLine.GetFinalExpenseAmount() * jmcLine."JMC Industrial Cost" / jmcOriginalExpense;
            jmcLine."JMC Management Cost" := jmcLine.GetFinalExpenseAmount() * jmcLine."JMC Management Cost" / jmcOriginalExpense;
            jmcLine."JMC Personnel Cost" := jmcLine.GetFinalExpenseAmount() - jmcLine."JMC Industrial Cost" - jmcLine."JMC Management Cost";
        end;
        exit(true);
    end;

    local procedure CalculateAmounts(jmcLine: Record "JMC Cost Model Line"; var jmcIndustrial: Decimal; var jmcManagement: Decimal; var jmcPersonnel: Decimal; var jmcStructure: Decimal; var jmcEXWORK: Decimal)
    begin
        jmcIndustrial := Round(JMCQuantity * jmcLine."JMC Industrial Cost", 0.01);
        jmcManagement := Round(JMCQuantity * jmcLine."JMC Management Cost", 0.01);
        jmcPersonnel := Round(JMCQuantity * jmcLine."JMC Personnel Cost", 0.01);
        jmcStructure := jmcIndustrial + jmcManagement + jmcPersonnel;
        jmcEXWORK := jmcStructure;
    end;

    var
        JMCModel: Record "JMC Cost Model";
        JMCSavedLines: Record "JMC Cost Model Line" temporary;
        JMCPairs: Record "JMC Cost Model Line" temporary;
        JMCSalesLine: Record "JMC Cost Model Line";
        JMCItemNo: Code[20];
        JMCUnitCode: Code[10];
        JMCItemDescription: Text[100];
        JMCQuantity: Decimal;
        JMCSalesIndustrial: Decimal;
        JMCSalesManagement: Decimal;
        JMCSalesPersonnel: Decimal;
        JMCSalesStructure: Decimal;
        JMCSalesEXWORK: Decimal;
        JMCHasSelection: Boolean;
        JMCSalesAvailable: Boolean;
        JMCShowWarning: Boolean;
        JMCSalesIssue: Text[250];
        JMCScopeLbl: Label 'Uses saved model rates, not current recipes or priority factors. Does not recalculate or save costs.', Comment = 'ESP="Utiliza las tasas guardadas del modelo, no las recetas ni los factores de prioridad actuales. No recalcula ni guarda costes."';
        JMCWarningLbl: Label 'The model has changed since calculation. This simulation uses the saved values, which may have been edited; it does not recalculate them.', Comment = 'ESP="El modelo ha cambiado desde el cálculo. Esta simulación utiliza los valores guardados, que pueden haberse editado; no los recalcula."';
        JMCNoProductErr: Label 'Item %1 has no saved lines in this model.', Comment = 'ESP="El producto %1 no tiene líneas guardadas en este modelo."';
        JMCNoLinesErr: Label 'This model has no saved product lines to simulate.', Comment = 'ESP="Este modelo no tiene líneas de producto guardadas para simular."';
        JMCRecalculateManualLbl: Label 'Recalculate the model to initialize final manual totals before simulating this line.', Comment = 'ESP="Recalcule el modelo para inicializar los totales finales manuales antes de simular esta línea."';
        JMCNoSplitLbl: Label 'The calculated expense is zero, so a positive manual expense cannot be split proportionally between industrial, management and personnel costs.', Comment = 'ESP="El gasto calculado es cero; no se puede desglosar proporcionalmente un gasto manual positivo entre costes industrial, de gestión y personal."';
}
