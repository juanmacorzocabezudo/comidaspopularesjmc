page 53154 "JMC Payroll Import List"
{
    Caption = 'Payroll Imports', Comment = 'ESP="Importaciones de nóminas"';
    PageType = List;
    SourceTable = "JMC Payroll Import Header";
    SourceTableView = sorting("JMC No.") order(descending);
    CardPageId = "JMC Payroll Import";
    UsageCategory = Tasks;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(No; Rec."JMC No.") { }
                field(Description; Rec."JMC Description") { }
                field(Status; Rec."JMC Status") { }
                field(DateFrom; Rec."JMC Date From") { }
                field(DateTo; Rec."JMC Date To") { }
                field(NoOfLines; Rec."JMC No. of Lines") { }
                field(NoOfErrors; Rec."JMC No. of Errors") { }
                field(FileName; Rec."JMC File Name") { }
                field(ImportDateTime; Rec."JMC Import DateTime") { }
                field(ImportedBy; Rec."JMC Imported By") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportExcel)
            {
                Caption = 'Import Excel', Comment = 'ESP="Importar Excel"';
                ToolTip = 'Create a new payroll import from the Excel file of the payroll provider.', Comment = 'ESP="Crea una nueva importación de nóminas a partir del Excel de la asesoría."';
                Image = ImportExcel;

                trigger OnAction()
                var
                    jmcPayrollHeader: Record "JMC Payroll Import Header";
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    if jmcPayrollImportMgt.CreateAndImport(jmcPayrollHeader) then
                        Page.Run(Page::"JMC Payroll Import", jmcPayrollHeader);
                end;
            }
        }
        area(Navigation)
        {
            action(Setup)
            {
                Caption = 'Setup', Comment = 'ESP="Configuración"';
                ToolTip = 'Open the payroll import setup.', Comment = 'ESP="Abre la configuración de la importación de nóminas."';
                Image = Setup;
                RunObject = page "JMC Payroll Import Setup";
            }
        }
        area(Promoted)
        {
            actionref(ImportExcel_Promoted; ImportExcel) { }
            actionref(Setup_Promoted; Setup) { }
        }
    }
}
