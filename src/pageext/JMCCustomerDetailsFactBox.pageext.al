pageextension 53124 "JMC Customer Details FB" extends "Customer Details FactBox"
{
    layout
    {
        addlast(Content)
        {
            field("JMC Avail. Credit (LCY)"; AvailableCreditLCY)
            {
                ApplicationArea = All;
                Caption = 'Avail. Credit (LCY) - JMC', Comment = 'ESP="Crédito disponible (DL) - JMC"';
                ToolTip = 'Specifies the available credit calculated as: Credit Limit - (Open Orders + Released Orders + Pending Invoices + Unposted Invoices).', Comment = 'ESP="Especifica el crédito disponible calculado como: Límite de crédito - (Pedidos abiertos + Pedidos lanzados + Facturas pendientes + Facturas sin registrar)."';
                Style = Attention;
                StyleExpr = AvailableCreditLCY < 0;

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
        }
    }

    var
        AvailableCreditLCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateAvailableCredit();
    end;

    local procedure CalculateAvailableCredit()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        OpenOrdersAmount: Decimal;
        ReleasedOrdersAmount: Decimal;
        PendingInvoicesAmount: Decimal;
        UnpostedInvoicesAmount: Decimal;
        TotalDebt: Decimal;
    begin
        AvailableCreditLCY := 0;

        if Rec."No." = '' then
            exit;

        if not Customer.Get(Rec."No.") then
            exit;

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

        // Total deuda = Pedidos abiertos + Pedidos lanzados + Facturas pendientes + Facturas sin registrar
        // NOTA: Los abonos pendientes NO se restan (solo son informativos hasta que se registren)
        TotalDebt := OpenOrdersAmount + ReleasedOrdersAmount + PendingInvoicesAmount + UnpostedInvoicesAmount;

        // Crédito disponible = Límite de crédito - Total deuda
        AvailableCreditLCY := Customer."Credit Limit (LCY)" - TotalDebt;
    end;
}
