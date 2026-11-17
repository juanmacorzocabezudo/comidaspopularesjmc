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
                        ToolTip = 'Confirms replacement of model results only, using the business split calculated from actual assembly production costs by LINEA dimension, current recipes and configured priority factors. No cost-center eligibility or direct-cost deductions are implemented. Source data is not modified.', Comment = 'ESP="Confirma sustituir solo los resultados del modelo con el reparto por negocio calculado del coste real de producción de ensamblados por dimensión LINEA, recetas actuales y factores configurados. No se implementan elegibilidad por centros ni deducciones de costes directos. No se modifican los datos de origen."';
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
        jmcCompletedMsg: Label 'Both allocation blocks have been calculated in the model. Items, recipes, documents and ledger entries have not been modified. Review each method separately; never add their results together.', Comment = 'ESP="Se han calculado ambos bloques de reparto en el modelo. No se han modificado productos, recetas, documentos ni movimientos. Revise cada método por separado; nunca sume sus resultados."';
        jmcPartialMsg: Label 'Calculation saved for review. Lines with issues and no allocation: %1. Review Calculation Issue and the unallocated funds in the header. Each method reconciles allocated plus unallocated amounts. No item or ledger data has been changed.', Comment = 'ESP="Cálculo guardado para revisión. Líneas con incidencia y sin reparto: %1. Revise Incidencia del cálculo y los fondos pendientes en cabecera. Cada método concilia lo asignado más lo pendiente. No se han modificado productos ni movimientos."';
    begin
        jmcLine.SetRange("JMC Model Code", JMCModelCode);
        jmcLine.SetFilter("JMC Calculation Issue", '<>%1', '');
        jmcIssueCount := jmcLine.Count();
        jmcModel.Get(JMCModelCode);
        if (jmcIssueCount > 0) or (jmcModel."JMC Sales Pending Industrial" <> 0) or (jmcModel."JMC Sales Pending Management" <> 0) or
           (jmcModel."JMC Recipe Pending Industrial" <> 0) or (jmcModel."JMC Recipe Pending Management" <> 0)
        then
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
}
