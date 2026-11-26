report 53112 "JMC Seed Resource Cost Types"
{
    Caption = 'Test Resource Cost Categorization', Comment = 'ESP="Categorizar costes de recursos (pruebas)"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JMCResource; Resource)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", Name;

            trigger OnAfterGetRecord()
            begin
                if JMCResource."JMC Cost Type" <> JMCResource."JMC Cost Type"::" " then begin
                    JMCExistingCount += 1;
                    exit;
                end;

                JMCResource.Validate("JMC Cost Type", JMCResource."JMC Cost Type"::Fixed);
                JMCResource.Modify(true);
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
                        Caption = 'Confirm Test Resource Categorization', Comment = 'ESP="Confirmar categorización de recursos de pruebas"';
                        ToolTip = 'Assigns the Fixed cost type to filtered resources with a blank cost type. Existing cost types are preserved.', Comment = 'ESP="Asigna el tipo de coste Fijo a los recursos filtrados que no tengan tipo de coste. Conserva los tipos existentes."';
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
    end;

    trigger OnPostReport()
    begin
        Message(JMCCompletedMsg, JMCUpdatedCount, JMCExistingCount);
    end;

    var
        JMCConfirmClassification: Boolean;
        JMCUpdatedCount: Integer;
        JMCExistingCount: Integer;
        JMCProductionErr: Label 'This test report cannot run in a production environment. Resource costs must be categorized by the customer.', Comment = 'ESP="Este informe de pruebas no se puede ejecutar en un entorno de producción. El cliente debe categorizar los costes de los recursos."';
        JMCConfirmationRequiredErr: Label 'Select Confirm Test Resource Categorization before running this report.', Comment = 'ESP="Marque Confirmar categorización de recursos de pruebas antes de ejecutar este informe."';
        JMCCompletedMsg: Label 'Test resource categorization completed. Updated: %1. Preserved: %2. Run Calculate All Costs to reread resource entries.', Comment = 'ESP="Categorización de recursos de pruebas completada. Actualizados: %1. Conservados: %2. Ejecute Calcular todos los costes para volver a leer los movimientos de recursos."';
        JMCWarningLbl: Label 'TEST DATA ONLY. Fixed is assigned to all filtered resources with a blank cost type, including resources that are not personnel. Existing values and ledger entries are not changed. Clear resource filters to process every resource. Run Calculate All Costs after categorization.', Comment = 'ESP="SOLO DATOS DE PRUEBA. Se asigna Fijo a todos los recursos filtrados sin tipo de coste, incluidos los que no son personal. No se modifican los valores existentes ni los movimientos. Quite los filtros de recursos para procesarlos todos. Ejecute Calcular todos los costes después de categorizar."';
}
