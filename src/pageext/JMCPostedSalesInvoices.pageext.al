pageextension 53127 "JMC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addlast(Reporting)
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
                    Customer: Record Customer;
                    JMCEmailReportMgt: Codeunit "JMC Email Report Mgt";
                    RecipientEmail: Text[80];
                begin
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    if Customer.Get(Rec."Sell-to Customer No.") then
                        RecipientEmail := Customer."E-Mail";

                    JMCEmailReportMgt.SendIndustryInvoice(SalesInvoiceHeader, Rec."No.", RecipientEmail);
                end;
            }
        }
    }
}
