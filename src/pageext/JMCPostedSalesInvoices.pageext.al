pageextension 53127 "JMC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addafter(Print)
        {
            action("JMC Print Invoice")
            {
                ApplicationArea = All;
                Caption = 'Print Catering Invoice', Comment = 'ESP="Imprimir factura Catering"';
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
                    Report.Run(Report::"JMC Sales Invoice Report", true, false, SalesInvoiceHeader);
                end;
            }
        }
    }
}
