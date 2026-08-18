pageextension 53128 "JMC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    actions
    {
        addafter(Print)
        {
            action("JMC Print Invoice")
            {
                ApplicationArea = All;
                Caption = 'Print Industry Invoice', Comment = 'ESP="Imprimir factura Industria"';
                ToolTip = 'Print the posted sales invoice using the JMC report format.', Comment = 'ESP="Imprimir la factura de venta registrada usando el formato de informe JMC."';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeader := Rec;
                    SalesInvoiceHeader.SetRecFilter();
                    Report.Run(Report::"Sales Invoice Industry Report", true, false, SalesInvoiceHeader);
                end;
            }
            action("JMC Print and Send Invoice")
            {
                ApplicationArea = All;
                Caption = 'Send Industry Invoice by Email', Comment = 'ESP="Enviar factura Industria por email"';
                ToolTip = 'Send the posted sales invoice by email using the Industry report format.', Comment = 'ESP="Enviar la factura de venta registrada por correo electrónico usando el formato de informe Industria."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    ReportSelections: Record "Report Selections";
                    SavedReportID: Integer;
                    SavedSequence: Code[10];
                begin
                    SalesInvoiceHeader := Rec;
                    SalesInvoiceHeader.SetRecFilter();

                    // Check if Industry report should be used and modify the report
                    ReportSelections.Reset();
                    ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                    ReportSelections.SetRange("JMC Use Industry Report", true);
                    if ReportSelections.FindFirst() then begin
                        // Save current values
                        SavedReportID := ReportSelections."Report ID";
                        SavedSequence := ReportSelections.Sequence;

                        // Change to Industry report
                        ReportSelections."Report ID" := Report::"Sales Invoice Industry Report";
                        ReportSelections.Modify();
                        Commit();
                    end;

                    // Use standard email method
                    SalesInvoiceHeader.EmailRecords(true);

                    // Restore original values
                    if SavedReportID <> 0 then begin
                        ReportSelections.Reset();
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                        ReportSelections.SetRange("Report ID", Report::"Sales Invoice Industry Report");
                        if ReportSelections.FindFirst() then begin
                            ReportSelections."Report ID" := SavedReportID;
                            ReportSelections.Modify();
                            Commit();
                        end;
                    end;
                end;
            }
        }
    }
}
