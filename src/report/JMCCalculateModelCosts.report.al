report 53111 "JMC Calculate Model Costs"
{
    Caption = 'Calculate All Costs', Comment = 'ESP="Calcular todos los costes"';
    ProcessingOnly = true;
    UseRequestPage = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Calculation for Model Review Only', Comment = 'ESP="Cálculo solo para revisión en el modelo"';
                    field(StartingDate; JMCStartingDate)
                    {
                        Caption = 'Starting Date', Comment = 'ESP="Fecha inicial"';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the first posting date for ledger entries and net sale quantities. Recipe costs are read from the current recipe, not historical costs.', Comment = 'ESP="Especifica la primera fecha de registro de movimientos y cantidades netas de venta. Los costes de receta se leen de la receta actual, no de costes históricos."';
                    }
                    field(EndingDate; JMCEndingDate)
                    {
                        Caption = 'Ending Date', Comment = 'ESP="Fecha final"';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the last posting date. Accounting closing entries are excluded.', Comment = 'ESP="Especifica la última fecha de registro. Se excluyen los asientos contables de cierre."';
                    }
                    field(AccountFilter; JMCAccountFilter)
                    {
                        Caption = 'G/L Account Filter', Comment = 'ESP="Filtro de cuentas contables"';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the account number filter; only configured fixed-cost accounts contribute to structure. Variable accounts are excluded. Test categorization includes fictitious balance and income accounts. Select only suitable accounts; mixed-cost deductions are not implemented.', Comment = 'ESP="Especifica el filtro de números de cuenta; solo aportan estructura las cuentas configuradas de coste fijo. Se excluyen las variables. La categorización de pruebas incluye cuentas ficticias de balance e ingresos. Seleccione solo las adecuadas; no se implementan deducciones de costes mixtos."';
                    }
                    field(ConfirmReviewOnly; JMCConfirmReviewOnly)
                    {
                        Caption = 'Confirm Comparative Test Calculation', Comment = 'ESP="Confirmar cálculo comparativo de pruebas"';
                        ApplicationArea = All;
                        ToolTip = 'Confirms replacement of model results only, using the business split calculated from actual assembly production costs by LINEA dimension, current recipes, item priorities and configured priority percentages. No cost-center eligibility or direct-cost deductions are implemented. Source data is not modified.', Comment = 'ESP="Confirma sustituir solo los resultados del modelo con el reparto por negocio calculado del coste real de producción de ensamblados por dimensión LINEA, recetas actuales, prioridades de producto y porcentajes de prioridad configurados. No se implementan elegibilidad por centros ni deducciones de costes directos. No se modifican los datos de origen."';
                    }
                }
                group(JMCAppliedRules)
                {
                    Caption = 'Applied Filters and Rules (Read-only)', Comment = 'ESP="Filtros y reglas aplicados (solo lectura)"';
                    Editable = false;

                    field(JMCAccountingRules; JMCAccountingRulesLbl)
                    {
                        Caption = 'Accounting Selection', Comment = 'ESP="Selección contable"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCProductionRules; JMCProductionRulesLbl)
                    {
                        Caption = 'Production Selection', Comment = 'ESP="Selección de producción"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCDimensionRules; JMCDimensionRulesLbl)
                    {
                        Caption = 'Production Business Dimension', Comment = 'ESP="Dimensión de negocio de producción"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCProductRules; JMCProductRulesLbl)
                    {
                        Caption = 'Model Product Selection', Comment = 'ESP="Selección de productos del modelo"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCSalesRules; JMCSalesRulesLbl)
                    {
                        Caption = 'Sales Movement Selection', Comment = 'ESP="Selección de movimientos de venta"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCRecipeRules; JMCRecipeRulesLbl)
                    {
                        Caption = 'Recipe Component Selection', Comment = 'ESP="Selección de componentes de receta"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCEligibilityRules; JMCEligibilityRulesLbl)
                    {
                        Caption = 'Allocation Eligibility Rules', Comment = 'ESP="Reglas de aptitud para el reparto"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCAllocationRules; JMCAllocationRulesLbl)
                    {
                        Caption = 'Allocation Grouping Rules', Comment = 'ESP="Reglas de agrupación del reparto"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(JMCUnrestrictedScope; JMCUnrestrictedScopeLbl)
                    {
                        Caption = 'Scope without Additional Filters', Comment = 'ESP="Ámbito sin filtros adicionales"';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        jmcCalculation: Codeunit "JMC Cost Model Calculation";
        jmcConfirmErr: Label 'Confirm that this is a comparative test calculation for model review only and check the account filter.', Comment = 'ESP="Confirme que es un cálculo comparativo de pruebas solo para revisión en el modelo y compruebe el filtro de cuentas."';
    begin
        if not JMCConfirmReviewOnly then
            Error(jmcConfirmErr);
        jmcCalculation.Calculate(JMCModelCode, JMCStartingDate, JMCEndingDate, JMCAccountFilter);
    end;

    trigger OnPostReport()
    var
        jmcLine: Record "JMC Cost Model Line";
        jmcModel: Record "JMC Cost Model";
        jmcIssueCount: Integer;
        jmcCompletedMsg: Label 'The calculation against products has been saved in the model. Items, recipes, documents and ledger entries have not been modified.', Comment = 'ESP="Se ha guardado el cálculo contra productos en el modelo. No se han modificado productos, recetas, documentos ni movimientos."';
        jmcPartialMsg: Label 'Calculation saved for review. Lines with issues and no allocation: %1. Review Calculation Issue and the unallocated funds in the header. The allocation reconciles allocated plus unallocated amounts. No item or ledger data has been changed.', Comment = 'ESP="Cálculo guardado para revisión. Líneas con incidencia y sin reparto: %1. Revise Incidencia del cálculo y los fondos pendientes en cabecera. El reparto concilia lo asignado más lo pendiente. No se han modificado productos ni movimientos."';
    begin
        jmcLine.SetRange("JMC Model Code", JMCModelCode);
        jmcLine.SetFilter("JMC Calculation Issue", '<>%1', '');
        jmcIssueCount := jmcLine.Count();
        jmcModel.Get(JMCModelCode);
        if (jmcIssueCount > 0) or (jmcModel."JMC Sales Pending Industrial" <> 0) or (jmcModel."JMC Sales Pending Management" <> 0) then
            Message(jmcPartialMsg, jmcIssueCount)
        else
            Message(jmcCompletedMsg);
    end;

    procedure SetModel(jmcCostModel: Record "JMC Cost Model")
    begin
        JMCModelCode := jmcCostModel."JMC Code";
        JMCStartingDate := jmcCostModel."JMC Starting Date";
        JMCEndingDate := jmcCostModel."JMC Ending Date";
        JMCAccountFilter := jmcCostModel."JMC Account Filter";
        if JMCStartingDate = 0D then
            JMCStartingDate := CalcDate('<-CM>', WorkDate());
        if JMCEndingDate = 0D then
            JMCEndingDate := WorkDate();
    end;

    var
        JMCModelCode: Code[20];
        JMCStartingDate: Date;
        JMCEndingDate: Date;
        JMCAccountFilter: Text[250];
        JMCConfirmReviewOnly: Boolean;
        JMCAccountingRulesLbl: Label 'Selected dates and account number filter; fixed accounts classified as industrial or management. Variable and wholly unclassified accounts are excluded; incomplete fixed/blank-type classifications cause an error. Closing entries are excluded. Signed amounts are retained; negative funds or no configured entries cause an error.', Comment = 'ESP="Fechas y filtro de cuentas indicados; cuentas fijas clasificadas como industrial o gestión. Se excluyen variables y cuentas sin ambas categorías; las clasificaciones incompletas de tipo fijo o vacío dan error. Se excluyen asientos de cierre. Se respetan los signos; fondos negativos o ausencia de movimientos configurados dan error."';
        JMCProductionRulesLbl: Label 'Item Ledger Entry: Assembly Output, selected posting dates, item number CA* or PT*, nonzero actual cost. PI intermediates are excluded. Includes reversals and available cost adjustments, even later adjustments; currently blocked items are not excluded from historical production.', Comment = 'ESP="Movimiento producto: Salida de ensamblado, fechas de registro indicadas, producto CA* o PT*, coste real distinto de cero. Se excluyen intermedios PI. Incluye reversiones y ajustes de coste disponibles, incluso posteriores; no se excluyen productos actualmente bloqueados de la producción histórica."';
        JMCDimensionRulesLbl: Label 'Dimension LINEA: CATERING or ALIMENTACION on the production movement. Missing/blank LINEA is ignored; any other nonblank value with nonzero final output cost causes an error. Business net costs must be nonnegative and their total positive.', Comment = 'ESP="Dimensión LINEA: CATERING o ALIMENTACION en el movimiento de producción. Se ignora LINEA ausente o vacía; otro valor no vacío con coste final distinto de cero da error. Los costes netos por negocio deben ser no negativos y su suma positiva."';
        JMCProductRulesLbl: Label 'All currently unblocked items, with separate rows for the sales units used in the period. Items without sales remain visible in their base unit with an issue. Only CA* (Catering) and PT* (Industry) can receive allocations; other items remain visible with an issue.', Comment = 'ESP="Todos los productos actualmente no bloqueados, separados por las unidades de venta utilizadas en el periodo. Los productos sin ventas siguen visibles en unidad base con incidencia. Solo CA* (Catering) y PT* (Alimentación) pueden recibir reparto; los demás siguen visibles con incidencia."';
        JMCSalesRulesLbl: Label 'Item Ledger Entry: Sale, selected posting dates, nonzero quantity, grouped by item and posted unit. Returns subtract; shipments not yet invoiced are included. Uses posted conversion factors, not current ones; missing units or nonpositive posted factors produce line issues. Sales revenue is not used.', Comment = 'ESP="Movimiento producto: Venta, fechas de registro indicadas, cantidad distinta de cero, agrupado por producto y unidad registrada. Las devoluciones restan; incluye envíos pendientes de facturar. Usa factores registrados, no actuales; unidades ausentes o factores registrados no positivos generan incidencias. No utiliza ingresos de venta."';
        JMCRecipeRulesLbl: Label 'Current BOM Component for each parent item, Maquila = No. Item components use standard cost and their current unit conversion; resources use unit cost. No historical recipe/date filter or additional general costs. Base unit conversion must be 1; missing components/resources or invalid conversions produce line issues.', Comment = 'ESP="Componente lista materiales actual de cada producto padre, Maquila = No. Los componentes de producto usan coste estándar y su conversión actual; los recursos, coste unitario. Sin filtro histórico de receta/fecha ni costes generales adicionales. La conversión de unidad base debe ser 1; componentes/recursos ausentes o conversiones inválidas generan incidencias."';
        JMCEligibilityRulesLbl: Label 'Requires existing C01 in recipe version 0, positive net quantities in posted and base units, positive recipe cost, an item priority from 1 to 5 and a configured priority percentage. Ineligible lines stay visible without allocation; a business without eligible lines keeps its fund pending. Recalculation reads the final manual cost from structure cost C01 of the recipe, as an amount or a percentage; it does not apply anything to recipes.', Comment = 'ESP="Requiere C01 existente en versión 0 de receta, cantidades netas positivas en unidad registrada y base, receta positiva, prioridad de producto de 1 a 5 y porcentaje de prioridad configurado. Las líneas no aptas siguen visibles sin reparto; un negocio sin aptos conserva su fondo pendiente. Recalcular lee el coste final manual del coste de estructura C01 de la receta, como importe o porcentaje; no aplica nada a las recetas."';
        JMCAllocationRulesLbl: Label 'Calculation against products: group by business and exact unit code; split between groups by recipe value without priority, then within each group by quantity times priority percentage. Industrial and management amounts are rounded separately to 0.01, with final residuals retained.', Comment = 'ESP="Cálculo contra productos: agrupar por negocio y código exacto de unidad; repartir entre grupos por valor de receta sin prioridad, y dentro del grupo por cantidad por porcentaje de prioridad. Industrial y gestión se redondean por separado a 0,01, conservando los residuos finales."';
        JMCUnrestrictedScopeLbl: Label 'Current company. The account filter affects accounting funds only, not production or sales. No additional location, customer, cost center, dimension or invoiced-only filter. No automatic direct-cost deductions or semivariable split; restrict accounts appropriately. Only model results are replaced.', Comment = 'ESP="Empresa actual. El filtro de cuentas solo afecta a fondos contables, no a producción ni ventas. Sin filtros adicionales de almacén, cliente, centro de coste, dimensiones o solo facturados. Sin deducciones automáticas de costes directos ni separación semivariable; limite las cuentas adecuadamente. Solo se sustituyen resultados del modelo."';
}
