page 53155 "JMC Payroll Import"
{
    Caption = 'Payroll Import', Comment = 'ESP="Importación nóminas"';
    PageType = Document;
    SourceTable = "JMC Payroll Import Header";
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                Editable = PageEditable;

                field(No; Rec."JMC No.") { }
                field(Description; Rec."JMC Description") { }
                field(Status; Rec."JMC Status")
                {
                    StyleExpr = StatusStyle;
                }
                field(FileName; Rec."JMC File Name") { }
                field(ImportDateTime; Rec."JMC Import DateTime") { }
                field(ImportedBy; Rec."JMC Imported By") { }
                field(DateFrom; Rec."JMC Date From") { }
                field(DateTo; Rec."JMC Date To") { }
            }
            group(Totals)
            {
                Caption = 'Totals', Comment = 'ESP="Totales"';

                field(NoOfLines; Rec."JMC No. of Lines") { }
                field(NoOfErrors; Rec."JMC No. of Errors")
                {
                    Style = Unfavorable;
                    StyleExpr = HasErrors;
                }
                field(NoOfWarnings; Rec."JMC No. of Warnings")
                {
                    Style = Ambiguous;
                    StyleExpr = HasWarnings;
                }
                field(NoOfPending; Rec."JMC No. of Pending") { }
                field(TotalGross; Rec."JMC Total Gross") { }
                field(ExcelTotalGross; Rec."JMC Excel Total Gross") { }
                field(TotalCompanySS; Rec."JMC Total Company SS") { }
                field(ExcelTotalCompanySS; Rec."JMC Excel Total Company SS") { }
                field(TotalNetPay; Rec."JMC Total Net Pay") { }
                field(ExcelTotalNetPay; Rec."JMC Excel Total Net Pay") { }
                field(TotalsMismatch; Rec."JMC Totals Mismatch")
                {
                    Style = Unfavorable;
                    StyleExpr = HasTotalsMismatch;
                }
            }
            part(PayrollLines; "JMC Payroll Import Lines")
            {
                SubPageLink = "JMC Import No." = field("JMC No.");
                UpdatePropagation = Both;
                Editable = PageEditable;
            }
            part(PayrollEntries; "JMC Payroll Import Entries")
            {
                Provider = PayrollLines;
                SubPageLink = "JMC Import No." = field("JMC Import No."), "JMC Import Line No." = field("JMC Line No.");
                UpdatePropagation = Both;
                Editable = PageEditable;
            }
            group(Journal)
            {
                Caption = 'Journal', Comment = 'ESP="Diario"';

                field(JournalTemplateName; Rec."JMC Journal Template Name") { }
                field(JournalBatchName; Rec."JMC Journal Batch Name") { }
                field(FirstDocumentNo; Rec."JMC First Document No.") { }
                field(LastDocumentNo; Rec."JMC Last Document No.") { }
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
                ToolTip = 'Import the Excel file of the payroll provider. The current lines are replaced.', Comment = 'ESP="Importa el Excel de la asesoría. Se sustituyen las líneas actuales."';
                Image = ImportExcel;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    CurrPage.SaveRecord();
                    jmcPayrollImportMgt.ImportExcel(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ValidateImport)
            {
                Caption = 'Validate', Comment = 'ESP="Validar"';
                ToolTip = 'Create the proposed entry of the payrolls that do not have one and check all the payrolls. Existing proposed entries and manual changes are kept.', Comment = 'ESP="Crea la propuesta de asiento de las nóminas que no la tienen y comprueba todas las nóminas. Las propuestas existentes y los cambios manuales se mantienen."';
                Image = CheckList;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    CurrPage.SaveRecord();
                    jmcPayrollImportMgt.ValidateImport(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CreateJournal)
            {
                Caption = 'Create Journal', Comment = 'ESP="Crear diario"';
                ToolTip = 'Create one entry per payroll in the general journal. The lines are not posted.', Comment = 'ESP="Crea un asiento por nómina en el diario general. Las líneas no se registran."';
                Image = GeneralLedger;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    CurrPage.SaveRecord();
                    jmcPayrollImportMgt.CreateJournal(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(MarkProcessed)
            {
                Caption = 'Mark as Processed', Comment = 'ESP="Marcar como procesado"';
                ToolTip = 'Mark the payroll import as processed once the journal has been posted.', Comment = 'ESP="Marca la importación de nóminas como procesada una vez registrado el diario."';
                Image = Completed;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    jmcPayrollImportMgt.MarkProcessed(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ShowIssues)
            {
                Caption = 'Show Errors', Comment = 'ESP="Ver errores"';
                ToolTip = 'Show only the payrolls with errors or warnings.', Comment = 'ESP="Muestra solo las nóminas con errores o avisos."';
                Image = ErrorLog;

                trigger OnAction()
                begin
                    CurrPage.PayrollLines.Page.SetIssueFilter(true);
                end;
            }
            action(ShowAll)
            {
                Caption = 'Show All', Comment = 'ESP="Ver todas"';
                ToolTip = 'Show all the payrolls.', Comment = 'ESP="Muestra todas las nóminas."';
                Image = AllLines;

                trigger OnAction()
                begin
                    CurrPage.PayrollLines.Page.SetIssueFilter(false);
                end;
            }
        }
        area(Navigation)
        {
            action(OpenJournal)
            {
                Caption = 'Open Journal', Comment = 'ESP="Abrir diario"';
                ToolTip = 'Open the general journal with the created payroll entries.', Comment = 'ESP="Abre el diario general con los asientos de nómina creados."';
                Image = Journal;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    jmcPayrollImportMgt.OpenJournal(Rec);
                end;
            }
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
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(ImportExcel_Promoted; ImportExcel) { }
                actionref(ValidateImport_Promoted; ValidateImport) { }
                actionref(CreateJournal_Promoted; CreateJournal) { }
                actionref(OpenJournal_Promoted; OpenJournal) { }
                actionref(MarkProcessed_Promoted; MarkProcessed) { }
            }
            group(Category_Review)
            {
                Caption = 'Review', Comment = 'ESP="Revisar"';

                actionref(ShowIssues_Promoted; ShowIssues) { }
                actionref(ShowAll_Promoted; ShowAll) { }
            }
        }
    }

    var
        PageEditable: Boolean;
        HasErrors: Boolean;
        HasWarnings: Boolean;
        HasTotalsMismatch: Boolean;
        StatusStyle: Text;

    trigger OnAfterGetCurrRecord()
    begin
        PageEditable := Rec.IsEditable();
        Rec.CalcFields("JMC No. of Errors", "JMC No. of Warnings");
        HasErrors := Rec."JMC No. of Errors" <> 0;
        HasWarnings := Rec."JMC No. of Warnings" <> 0;
        HasTotalsMismatch := Rec."JMC Totals Mismatch";
        case Rec."JMC Status" of
            Rec."JMC Status"::Validated:
                StatusStyle := 'Favorable';
            Rec."JMC Status"::"Journal Created", Rec."JMC Status"::Processed:
                StatusStyle := 'Strong';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
