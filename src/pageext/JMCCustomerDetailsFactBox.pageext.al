pageextension 53124 "JMC Customer Details FB" extends "Customer Details FactBox"
{
    layout
    {
        modify(AvailableCreditLCY)
        {
            Visible = false;
        }
        addafter("Credit Limit (LCY)")
        {
            field("Avail Credit (LCY)"; JMCAvailableCreditLCY)
            {
                ApplicationArea = All;
                Caption = 'Crédito disponible (DL)';
                ToolTip = 'Especifica el crédito disponible calculado como: Límite de crédito - (Ofertas pendientes + Pedidos abiertos + Pedidos lanzados + Facturas pendientes + Facturas sin registrar).';
                Style = Attention;
                StyleExpr = JMCAvailableCreditLCY < 0;

                trigger OnDrillDown()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("Customer No.", Rec."No.");
                    Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                end;
            }
        }
    }

    var
        JMCAvailableCreditLCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateAvailableCredit();
    end;

    local procedure CalculateAvailableCredit()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        PendingQuotesAmount: Decimal;
        OpenOrdersAmount: Decimal;
        ReleasedOrdersAmount: Decimal;
        PendingInvoicesAmount: Decimal;
        UnpostedInvoicesAmount: Decimal;
        TotalDebt: Decimal;
    begin
        JMCAvailableCreditLCY := 0;

        if Rec."No." = '' then
            exit;

        if not Customer.Get(Rec."No.") then
            exit;

        // Calcular ofertas pendientes
        PendingQuotesAmount := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                PendingQuotesAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        // Calcular pedidos abiertos (no lanzados)
        OpenOrdersAmount := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                OpenOrdersAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        // Calcular pedidos lanzados (enviados no facturados)
        Customer.CalcFields("Shipped Not Invoiced (LCY)");
        ReleasedOrdersAmount := Customer."Shipped Not Invoiced (LCY)";

        // Calcular facturas pendientes (registradas no liquidadas)
        Customer.CalcFields("Balance (LCY)");
        PendingInvoicesAmount := Customer."Balance (LCY)";

        // Calcular facturas sin registrar
        Customer.CalcFields("Outstanding Invoices (LCY)");
        UnpostedInvoicesAmount := Customer."Outstanding Invoices (LCY)";

        // Total deuda = Ofertas + Pedidos abiertos + Pedidos lanzados + Facturas pendientes + Facturas sin registrar
        // NOTA: Los abonos pendientes NO se restan (solo son informativos hasta que se registren)
        TotalDebt := PendingQuotesAmount + OpenOrdersAmount + ReleasedOrdersAmount + PendingInvoicesAmount + UnpostedInvoicesAmount;

        // Crédito disponible = Límite de crédito - Total deuda
        JMCAvailableCreditLCY := Customer."Credit Limit (LCY)" - TotalDebt;
    end;
}
