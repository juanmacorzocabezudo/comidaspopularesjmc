pageextension 53103 "JMC Customer Statistics FB" extends "Customer Statistics FactBox"
{
    layout
    {
        addbefore("Outstanding Orders (LCY)")
        {
            field("JMC Pending Quotes"; PendingQuotesLCY)
            {
                ApplicationArea = All;
                Caption = 'Pending Quotes (LCY)', Comment = 'ESP="Ofertas pendientes (DL)"';
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
            field("JMC Open Sales Orders"; OpenSalesOrdersLCY)
            {
                ApplicationArea = All;
                Caption = 'Open Sales Orders (LCY)', Comment = 'ESP="Pedidos abiertos de venta (DL)"';
                ToolTip = 'Specifies the total amount for open (not released) sales orders.', Comment = 'ESP="Especifica el importe total de pedidos de venta abiertos (no lanzados)."';

                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                    Page.Run(Page::"Sales Order List", SalesHeader);
                end;
            }
            field("JMC Released Sales Orders"; ReleasedSalesOrdersLCY)
            {
                ApplicationArea = All;
                Caption = 'Released Sales Orders (LCY)', Comment = 'ESP="Pedidos de venta lanzados (DL)"';
                ToolTip = 'Specifies the total amount for released sales orders (shipped not invoiced).', Comment = 'ESP="Especifica el importe total de pedidos de venta lanzados (enviados no facturados)."';

                trigger OnDrillDown()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."No.") then begin
                        Customer.SetRange("No.", Rec."No.");
                        Customer.SetRange("Date Filter", 0D, WorkDate());
                        Page.Run(Page::"Customer Ledger Entries", Customer);
                    end;
                end;
            }
        }
        modify("Outstanding Orders (LCY)")
        {
            Visible = false;
        }
        modify("Shipped Not Invoiced (LCY)")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Outstanding Invoices (LCY)")
        {
            Visible = false;
        }
        addafter("Outstanding Invoices (LCY)")
        {
            field("JMC Pending Invoices"; PendingInvoicesLCY)
            {
                ApplicationArea = All;
                Caption = 'Pending Invoices (LCY)', Comment = 'ESP="Facturas pendientes (DL)"';
                ToolTip = 'Specifies the total amount for posted invoices not yet paid.', Comment = 'ESP="Especifica el importe total de facturas registradas pendientes de pago."';

                trigger OnDrillDown()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."No.") then begin
                        Customer.SetRange("No.", Rec."No.");
                        Page.Run(Page::"Customer Ledger Entries", Customer);
                    end;
                end;
            }
            field("JMC Unposted Invoices"; UnpostedInvoicesLCY)
            {
                ApplicationArea = All;
                Caption = 'Unposted Invoices (LCY)', Comment = 'ESP="Facturas sin registrar (DL)"';
                ToolTip = 'Specifies the total amount for unposted sales invoices.', Comment = 'ESP="Especifica el importe total de facturas de venta sin registrar."';

                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                    Page.Run(Page::"Sales Invoice List", SalesHeader);
                end;
            }
            field("JMC Pending Credit Memos"; PendingCreditMemosLCY)
            {
                ApplicationArea = All;
                Caption = 'Pending Credit Memos (LCY)', Comment = 'ESP="Notas de abonos pendientes (DL)"';
                ToolTip = 'Specifies the total amount for pending credit memos.', Comment = 'ESP="Especifica el importe total de notas de abono pendientes."';

                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    Page.Run(Page::"Sales Credit Memos", SalesHeader);
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
        OpenSalesOrdersLCY: Decimal;
        ReleasedSalesOrdersLCY: Decimal;
        PendingInvoicesLCY: Decimal;
        UnpostedInvoicesLCY: Decimal;
        PendingCreditMemosLCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculatePendingQuotes();
        CalculateOpenSalesOrders();
        CalculateReleasedSalesOrders();
        CalculatePendingInvoices();
        CalculateUnpostedInvoices();
        CalculatePendingCreditMemos();
        CalculateCustomTotal();
    end;

    local procedure CalculateCustomTotal()
    var
        SalesHeader: Record "Sales Header";
        QuoteAmount: Decimal;
    begin
        CustomTotalLCY := 0;
        QuoteAmount := 0;

        // Calculate: OFERTAS + PEDIDOS ABIERTOS + PEDIDOS LANZADOS + FACTURAS REGISTRADAS + FACTURAS SIN REGISTRAR
        // NOTA: Los abonos pendientes NO se restan del total (solo son informativos hasta que se registren)
        if Rec."No." = '' then
            exit;

        // Add Quotes
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                QuoteAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        CustomTotalLCY := QuoteAmount + OpenSalesOrdersLCY + ReleasedSalesOrdersLCY + PendingInvoicesLCY + UnpostedInvoicesLCY;
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

    local procedure CalculateOpenSalesOrders()
    var
        SalesHeader: Record "Sales Header";
    begin
        OpenSalesOrdersLCY := 0;

        // Calculate open (not released) sales orders for the customer
        if Rec."No." = '' then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                OpenSalesOrdersLCY += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;
    end;

    local procedure CalculateReleasedSalesOrders()
    var
        SalesHeader: Record "Sales Header";
    begin
        ReleasedSalesOrdersLCY := 0;

        // Calculate shipped not invoiced amount from sales orders
        if Rec."No." = '' then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Shipped Not Invoiced", true);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amt. Ship. Not Inv. (LCY)");
                ReleasedSalesOrdersLCY += SalesHeader."Amt. Ship. Not Inv. (LCY)";
            until SalesHeader.Next() = 0;
    end;

    local procedure CalculatePendingInvoices()
    var
        Customer: Record Customer;
    begin
        PendingInvoicesLCY := 0;

        // Calculate pending invoices (Balance) for the customer - posted invoices not yet paid
        if Rec."No." = '' then
            exit;

        if not Customer.Get(Rec."No.") then
            exit;

        Customer.CalcFields("Balance (LCY)");
        PendingInvoicesLCY := Customer."Balance (LCY)";
    end;

    local procedure CalculatePendingCreditMemos()
    var
        SalesHeader: Record "Sales Header";
    begin
        PendingCreditMemosLCY := 0;

        // Calculate pending credit memos for the customer
        if Rec."No." = '' then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                PendingCreditMemosLCY += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;
    end;

    local procedure CalculateUnpostedInvoices()
    var
        Customer: Record Customer;
    begin
        UnpostedInvoicesLCY := 0;

        // Calculate unposted invoices (Outstanding Invoices) for the customer
        if Rec."No." = '' then
            exit;

        if not Customer.Get(Rec."No.") then
            exit;

        Customer.CalcFields("Outstanding Invoices (LCY)");
        UnpostedInvoicesLCY := Customer."Outstanding Invoices (LCY)";
    end;
}
