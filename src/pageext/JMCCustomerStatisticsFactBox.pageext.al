pageextension 53103 "JMC Customer Statistics FB" extends "Customer Statistics FactBox"
{
    layout
    {
        modify("Total (LCY)")
        {
            Visible = false;
        }
        addafter("Total (LCY)")
        {
            field("JMC Custom Total (LCY)"; CustomTotalLCY)
            {
                ApplicationArea = All;
                Caption = 'Total (LCY)', Comment = 'ESP="Total (DL)"';
                ToolTip = 'Specifies the total amount for pending sales documents (quotes + orders + invoices - credit memos).', Comment = 'ESP="Especifica el importe total de documentos de venta pendientes (ofertas + pedidos + facturas - abonos)."';
                Style = Strong;
                StyleExpr = true;

                trigger OnDrillDown()
                begin
                    // Drill down to show pending sales documents
                end;
            }
        }
    }

    var
        CustomTotalLCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateCustomTotal();
    end;

    local procedure CalculateCustomTotal()
    var
        SalesHeader: Record "Sales Header";
    begin
        CustomTotalLCY := 0;

        // Calculate pending sales documents for the customer
        if Rec."No." = '' then
            exit;

        // Add Quotes + Orders + Invoices
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetFilter("Document Type", '%1|%2|%3',
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::Order,
            SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                CustomTotalLCY += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        // Subtract Credit Memos
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                CustomTotalLCY -= SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;
    end;
}
