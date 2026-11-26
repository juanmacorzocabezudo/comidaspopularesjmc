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
                    field(JMCResourceRules; JMCResourceRulesLbl)
                    {
                        Caption = 'Personnel Cost Selection', Comment = 'ESP="Selección del coste de personal"';
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
    begin
        jmcCalculation.Calculate(JMCModelCode, JMCStartingDate, JMCEndingDate, JMCAccountFilter);
    end;

    trigger OnPostReport()
    var
        jmcLine: Record "JMC Cost Model Line";
        jmcModel: Record "JMC Cost Model";
        jmcIssueCount: Integer;
        jmcCompletedMsg: Label 'The calculation against products has been saved in the model. Items, recipes, documents and ledger entries have not been modified.', Comment = 'ESP="Se ha guardado el cálculo contra productos en el modelo. No se han modificado productos, recetas, documentos ni movimientos."';
        jmcPartialMsg: Label 'Calculation saved for review. Lines with issues and no allocation: %1. Unallocated personnel cost: %2. Review Calculation Issue and unallocated accounting costs in the header. Personnel cost remains unallocated when a business has no eligible production quantity. No item or ledger data has been changed.', Comment = 'ESP="Cálculo guardado para revisión. Líneas con incidencia y sin reparto: %1. Coste de personal sin repartir: %2. Revise Incidencia del cálculo y los costes contables pendientes en cabecera. El coste de personal queda sin repartir cuando un negocio no tiene cantidad de fabricación apta. No se han modificado productos ni movimientos."';
    begin
        jmcLine.SetRange("JMC Model Code", JMCModelCode);
        jmcLine.SetFilter("JMC Calculation Issue", '<>%1', '');
        jmcIssueCount := jmcLine.Count();
        jmcModel.Get(JMCModelCode);
        if (jmcIssueCount > 0) or (jmcModel."JMC Sales Pending Industrial" <> 0) or (jmcModel."JMC Sales Pending Management" <> 0) or (jmcModel."JMC Resource Cost Pending" <> 0) then
            Message(jmcPartialMsg, jmcIssueCount, jmcModel."JMC Resource Cost Pending")
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
        JMCAccountingRulesLbl: Label 'Selected dates and account number filter; fixed accounts classified as industrial or management. Variable and wholly unclassified accounts are excluded; incomplete fixed/blank-type classifications cause an error. Closing entries are excluded. Signed amounts are retained; negative cost amounts or no configured entries cause an error.', Comment = 'ESP="Fechas y filtro de cuentas indicados; cuentas fijas clasificadas como industrial o gestión. Se excluyen variables y cuentas sin ambas categorías; las clasificaciones incompletas de tipo fijo o vacío dan error. Se excluyen asientos de cierre. Se respetan los signos; importes de coste negativos o ausencia de movimientos configurados dan error."';
        JMCResourceRulesLbl: Label 'Fixed personnel: net income-statement G/L entries linked to fixed resources, within the dates and account filter, excluding closing entries. Split uses structure percentages. Non-fixed resources: all posted assembly lines and outstanding order quantities are assigned to Industry by posting date; eligible event assignments are assigned to Catering using the event date and saved quantity times unit cost, excluding quotes, rejected and cancelled events. Personnel is allocated over eligible base production quantities and included separately in Total Cost and EXWORK.', Comment = 'ESP="Personal fijo: movimientos contables netos de cuentas de resultados vinculados a recursos fijos, según fechas y filtro de cuentas, sin cierres. Se reparte con los porcentajes de estructura. Recursos no fijos: todas las líneas de ensamblado registradas y cantidades pendientes de pedidos se asignan a Alimentación por fecha de registro; las asignaciones a eventos válidos se asignan a Catering por fecha del evento y cantidad por coste unitario guardados, sin presupuestos, rechazados ni anulados. El personal se reparte sobre fabricación apta en unidad base y se incluye por separado en Total coste y EXWORK."';
        JMCProductionRulesLbl: Label 'Item Ledger Entry: Assembly Output, selected posting dates, item number CA* or PT*, nonzero actual cost. PI intermediates are excluded. Includes reversals and available cost adjustments, even later adjustments; currently blocked items are not excluded from historical production.', Comment = 'ESP="Movimiento producto: Salida de ensamblado, fechas de registro indicadas, producto CA* o PT*, coste real distinto de cero. Se excluyen intermedios PI. Incluye reversiones y ajustes de coste disponibles, incluso posteriores; no se excluyen productos actualmente bloqueados de la producción histórica."';
        JMCDimensionRulesLbl: Label 'Dimension LINEA: CATERING or ALIMENTACION on the production movement. Missing/blank LINEA is ignored; any other nonblank value with nonzero final output cost causes an error. Business net costs must be nonnegative and their total positive.', Comment = 'ESP="Dimensión LINEA: CATERING o ALIMENTACION en el movimiento de producción. Se ignora LINEA ausente o vacía; otro valor no vacío con coste final distinto de cero da error. Los costes netos por negocio deben ser no negativos y su suma positiva."';
        JMCProductRulesLbl: Label 'All currently unblocked items, with one row per item in its base unit. Eligible CA, MP and MA products receive the Catering allocation; eligible PT, PI, PR and SER products receive the Industry allocation.', Comment = 'ESP="Todos los productos actualmente no bloqueados, con una línea por producto en su unidad base. Los productos CA, MP y MA aptos reciben el reparto de Catering; los PT, PI, PR y SER aptos reciben el de Alimentación."';
        JMCSalesRulesLbl: Label 'Item Ledger Entry: Sale, selected posting dates, nonzero base quantity, grouped by item across all sales units. Returns subtract; shipments not yet invoiced are included. Sales revenue is not used.', Comment = 'ESP="Movimiento producto: Venta, fechas de registro indicadas, cantidad base distinta de cero, agrupado por producto para todas las unidades de venta. Las devoluciones restan; incluye envíos pendientes de facturar. No utiliza ingresos de venta."';
        JMCRecipeRulesLbl: Label 'Current BOM Component for each parent item, Maquila = No. Item components use standard cost and their current unit conversion; resources use unit cost. No historical recipe/date filter or additional general costs. Base unit conversion must be 1; missing components/resources or invalid conversions produce line issues.', Comment = 'ESP="Componente lista materiales actual de cada producto padre, Maquila = No. Los componentes de producto usan coste estándar y su conversión actual; los recursos, coste unitario. Sin filtro histórico de receta/fecha ni costes generales adicionales. La conversión de unidad base debe ser 1; componentes/recursos ausentes o conversiones inválidas generan incidencias."';
        JMCEligibilityRulesLbl: Label 'Requires existing C01 in recipe version 0, a valid unit, positive recipe cost and positive production quantity. Ineligible lines stay visible without allocation; a business without eligible lines keeps its cost pending. Calculate All Costs reads C01 without applying anything to recipes.', Comment = 'ESP="Requiere C01 existente en versión 0 de receta, unidad válida, receta positiva y cantidad fabricada positiva. Las líneas no aptas siguen visibles sin reparto; un negocio sin aptos conserva su coste pendiente. Calcular todos los costes lee C01 sin aplicar nada a las recetas."';
        JMCAllocationRulesLbl: Label 'Net assembly production is expressed in each product base unit. Costs are grouped by business and base unit, distributed between groups by production recipe value, and within each group by production quantity. Amounts are rounded separately to 0.01.', Comment = 'ESP="La fabricación neta de ensamblado se expresa en la unidad base de cada producto. Los costes se agrupan por negocio y unidad base, se reparten entre grupos por valor de receta de la fabricación y dentro del grupo por cantidad fabricada. Los importes se redondean por separado a 0,01."';
        JMCUnrestrictedScopeLbl: Label 'Current company. The account filter affects accounting costs only, not production or sales. No additional location, customer, cost center, dimension or invoiced-only filter. No automatic direct-cost deductions or semivariable split; restrict accounts appropriately. Only model results are replaced.', Comment = 'ESP="Empresa actual. El filtro de cuentas solo afecta a costes contables, no a producción ni ventas. Sin filtros adicionales de almacén, cliente, centro de coste, dimensiones o solo facturados. Sin deducciones automáticas de costes directos ni separación semivariable; limite las cuentas adecuadamente. Solo se sustituyen resultados del modelo."';
}
