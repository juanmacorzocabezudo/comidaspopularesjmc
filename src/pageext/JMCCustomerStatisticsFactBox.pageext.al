pageextension 53103 "JMC Customer Statistics FB" extends "Customer Statistics FactBox"
{
    layout
    {
        addafter("Outstanding Invoices (LCY)")
        {
            field("JMC Pending Quotes"; PendingQuotesLCY)
            {
                ApplicationArea = All;
                Caption = 'Pending Quotes', Comment = 'ESP="Ofertas pendientes"';
                ToolTip = 'Specifies the total amount for pending sales quotes.', Comment = 'ESP="Especifica el importe total de ofertas de venta pendientes."';

                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
                    Page.Run(Page::"Sales Quotes", SalesHeader);
                end;
            }
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
        modify("Total (LCY)")
        {
            Visible = false;
        }
    }

    var
        CustomTotalLCY: Decimal;
        PendingQuotesLCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateCustomTotal();
        CalculatePendingQuotes();
    end;

    local procedure CalculateCustomTotal()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        QuoteAmount: Decimal;
        OrderAmount: Decimal;
        ShippedNotInvoicedAmount: Decimal;
        InvoiceAmount: Decimal;
        CreditMemoAmount: Decimal;
    begin
        CustomTotalLCY := 0;
        QuoteAmount := 0;
        OrderAmount := 0;
        ShippedNotInvoicedAmount := 0;
        InvoiceAmount := 0;
        CreditMemoAmount := 0;

        // Calculate: OFERTAS + PEDIDOS + ENVIADO NO FACTURADO + FACTURAS - ABONOS
        if Rec."No." = '' then
            exit;

        if not Customer.Get(Rec."No.") then
            exit;

        // Use standard flowfields from Customer
        Customer.CalcFields("Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        OrderAmount := Customer."Outstanding Orders (LCY)";
        ShippedNotInvoicedAmount := Customer."Shipped Not Invoiced (LCY)";
        InvoiceAmount := Customer."Outstanding Invoices (LCY)";

        // Add Quotes
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                QuoteAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        // Subtract pending Credit Memos (unposted)
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                CreditMemoAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        CustomTotalLCY := QuoteAmount + OrderAmount + ShippedNotInvoicedAmount + InvoiceAmount - CreditMemoAmount;
    end;

    local procedure CalculatePendingQuotes()
    var
        SalesHeader: Record "Sales Header";
    begin
        PendingQuotesLCY := 0;

        // Calculate pending quotes for the customer
        if Rec."No." = '' then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                PendingQuotesLCY += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;
    end;
}
