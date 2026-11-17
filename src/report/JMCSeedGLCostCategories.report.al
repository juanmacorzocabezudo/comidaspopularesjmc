report 53110 "JMC Seed G/L Cost Categories"
{
    Caption = 'Test G/L Cost Categorization', Comment = 'ESP="Categorizar costes contables (pruebas)"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JMCGLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", Name;

            trigger OnAfterGetRecord()
            begin
                if (StrLen(JMCGLAccount."No.") <> 8) or (DelChr(JMCGLAccount."No.", '=', '0123456789') <> '') then begin
                    JMCExcludedCount += 1;
                    exit;
                end;

                if (JMCGLAccount."JMC Cost Type" <> JMCGLAccount."JMC Cost Type"::" ") and
                   (JMCGLAccount."JMC Cost Classification" <> JMCGLAccount."JMC Cost Classification"::" ")
                then begin
                    JMCExistingCount += 1;
                    exit;
                end;

                CategorizeAccount(JMCGLAccount);
                JMCGLAccount.Modify(true);
                JMCUpdatedCount += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';

                    field(JMCConfirmClassification; JMCConfirmClassification)
                    {
                        ApplicationArea = All;
                        Caption = 'Confirm Test Categorization', Comment = 'ESP="Confirmar categorización de pruebas"';
                        ToolTip = 'Fills missing cost categories for all filtered accounts with eight numeric digits, regardless of account type or prefix. Existing values are preserved.', Comment = 'ESP="Completa las categorías de coste vacías de todas las cuentas filtradas de ocho dígitos numéricos, sin limitar por tipo de cuenta ni prefijo. Conserva los valores existentes."';
                    }
                }
                group(Information)
                {
                    Caption = 'Information', Comment = 'ESP="Información"';

                    field(JMCWarning; JMCWarningLbl)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        Style = StrongAccent;
                    }
                    field(JMCRules; JMCRulesLbl)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            JMCConfirmClassification := false;
        end;
    }

    trigger OnPreReport()
    var
        jmcEnvironmentInformation: Codeunit "Environment Information";
    begin
        if jmcEnvironmentInformation.IsProduction() then
            Error(JMCProductionErr);
        if not JMCConfirmClassification then
            Error(JMCConfirmationRequiredErr);
        JMCUpdatedCount := 0;
        JMCExistingCount := 0;
        JMCExcludedCount := 0;
    end;

    trigger OnPostReport()
    begin
        Message(JMCCompletedMsg, JMCUpdatedCount, JMCExistingCount, JMCExcludedCount);
    end;

    local procedure CategorizeAccount(var jmcGLAccount: Record "G/L Account")
    var
        jmcCostType: Enum "JMC Cost Type";
        jmcCostClassification: Enum "JMC Cost Classification";
    begin
        jmcCostType := jmcCostType::Fixed;
        jmcCostClassification := jmcCostClassification::"Full Management Cost";
        case CopyStr(jmcGLAccount."No.", 1, 2) of
            '60', '61':
                begin
                    jmcCostType := jmcCostType::Variable;
                    jmcCostClassification := jmcCostClassification::"Industrial Manufacturing Cost";
                end;
            '64':
                jmcCostClassification := jmcCostClassification::"Industrial Manufacturing Cost";
        end;
        case CopyStr(jmcGLAccount."No.", 1, 3) of
            '621', '622':
                jmcCostClassification := jmcCostClassification::"Industrial Manufacturing Cost";
            '628':
                begin
                    jmcCostType := jmcCostType::Variable;
                    jmcCostClassification := jmcCostClassification::"Industrial Manufacturing Cost";
                end;
        end;
        if jmcGLAccount."JMC Cost Type" = jmcGLAccount."JMC Cost Type"::" " then
            jmcGLAccount.Validate("JMC Cost Type", jmcCostType);
        if jmcGLAccount."JMC Cost Classification" = jmcGLAccount."JMC Cost Classification"::" " then
            jmcGLAccount.Validate("JMC Cost Classification", jmcCostClassification);
    end;

    var
        JMCConfirmClassification: Boolean;
        JMCUpdatedCount: Integer;
        JMCExistingCount: Integer;
        JMCExcludedCount: Integer;
        JMCProductionErr: Label 'This test report cannot run in a production environment. Cost accounts must be categorized by the customer.', Comment = 'ESP="Este informe de pruebas no se puede ejecutar en un entorno de producción. El cliente debe categorizar las cuentas de costes."';
        JMCConfirmationRequiredErr: Label 'Select Confirm Test Categorization before running this report.', Comment = 'ESP="Marque Confirmar categorización de pruebas antes de ejecutar este informe."';
        JMCCompletedMsg: Label 'Test categorization completed. Updated: %1. Preserved (both fields already filled): %2. Excluded (account code is not eight numeric digits): %3.', Comment = 'ESP="Categorización de pruebas completada. Actualizadas: %1. Conservadas (ambos campos ya informados): %2. Excluidas (el código de cuenta no tiene ocho dígitos numéricos): %3."';
        JMCWarningLbl: Label 'TEST DATA ONLY. All eight-digit account codes are categorized, including balance sheet, revenue and direct cost accounts. These fictitious categories must not be used for real structure allocation. Only blank fields are filled. No ledger entries are changed. Production categorization is the customer responsibility.', Comment = 'ESP="SOLO DATOS DE PRUEBA. Se categorizan todos los códigos de cuenta de ocho dígitos, incluidas cuentas de balance, ingresos y costes directos. Estas categorías ficticias no deben utilizarse para repartir estructura real. Solo se completan campos vacíos. No se modifican movimientos contables. La categorización de producción corresponde al cliente."';
        JMCRulesLbl: Label 'All account types and prefixes are eligible if the code has eight numeric digits. 60/61 and 628: variable industrial. 64 and 621/622: fixed industrial. All others: fixed management. Missing fields are completed independently. Clear account filters to process every account.', Comment = 'ESP="Se admiten todos los tipos de cuenta y prefijos si el código tiene ocho dígitos numéricos. 60/61 y 628: variable industrial. 64 y 621/622: fijo industrial. Resto: fijo de gestión. Los campos vacíos se completan de forma independiente. Quite los filtros de cuenta para procesarlas todas."';
}
