pageextension 53122 "JMC Item Card" extends "Item Card"
{
    layout
    {
        addafter(Formato)
        {
            field("JMC Weight"; Rec."JMC Weight")
            {
                ApplicationArea = All;
                Caption = 'Weight (Kg)', Comment = 'ESP="Peso (Kg)"';
                ToolTip = 'Specifies the weight of the item in kilograms.', Comment = 'ESP="Especifica el peso del producto en kilogramos."';
            }
        }
        modify("Last Direct Cost")
        {
            Visible = false;
        }
        addafter("Unit Cost")
        {
            field("JMC Last Direct Cost"; Rec."JMC Average Purchase Cost")
            {
                ApplicationArea = All;
                Caption = 'Last Direct Cost', Comment = 'ESP="Último coste directo"';
                ToolTip = 'Specifies the average purchase cost calculated from the last purchase invoice.', Comment = 'ESP="Especifica el coste medio de compra calculado de la última factura de compra."';

                trigger OnDrillDown()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    if Rec."JMC Last Purch. Invoice No." <> '' then begin
                        PurchInvHeader.Get(Rec."JMC Last Purch. Invoice No.");
                        Page.Run(Page::"Posted Purchase Invoice", PurchInvHeader);
                    end;
                end;
            }
            field("JMC Stock Unit Cost"; StockUnitCost)
            {
                ApplicationArea = All;
                Caption = 'Stock Unit Cost', Comment = 'ESP="Coste Unitario Existencias"';
                ToolTip = 'Specifies the unit cost calculated only from inventory entries with remaining quantity greater than zero.', Comment = 'ESP="Especifica el coste unitario calculado solo de movimientos de inventario con cantidad pendiente mayor que cero."';
                DecimalPlaces = 0 : 3;
                Editable = false;
                BlankZero = true;
            }
            field("JMC Last Year Unit Cost"; LastYearUnitCost)
            {
                ApplicationArea = All;
                Caption = 'Last Year Purchase Cost', Comment = 'ESP="Coste Compra Último Año"';
                ToolTip = 'Specifies the weighted average unit cost from purchases in the last year.', Comment = 'ESP="Especifica el coste unitario medio ponderado de las compras del último año."';
                DecimalPlaces = 0 : 3;
                Editable = false;
                BlankZero = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateStockUnitCost();
        CalculateLastYearUnitCost();
    end;

    local procedure CalculateStockUnitCost()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        TotalCost: Decimal;
        TotalQty: Decimal;
    begin
        Clear(StockUnitCost);

        ItemLedgerEntry.SetCurrentKey("Item No.", "Remaining Quantity");
        ItemLedgerEntry.SetRange("Item No.", Rec."No.");
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
        if ItemLedgerEntry.FindSet() then
            repeat
                TotalQty += ItemLedgerEntry."Remaining Quantity";

                // Sumar los costes de los value entries asociados
                ValueEntry.SetCurrentKey("Item Ledger Entry No.");
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                if ValueEntry.FindSet() then
                    repeat
                        TotalCost += ValueEntry."Cost Amount (Actual)";
                    until ValueEntry.Next() = 0;
            until ItemLedgerEntry.Next() = 0;

        if TotalQty <> 0 then
            StockUnitCost := TotalCost / TotalQty;
    end;

    local procedure CalculateLastYearUnitCost()
    var
        PurchInvLine: Record "Purch. Inv. Line";
        TotalCost: Decimal;
        TotalQty: Decimal;
        StartDate: Date;
    begin
        Clear(LastYearUnitCost);
        StartDate := CalcDate('<-1Y>', Today);

        // Calcular basándose en las facturas de compra registradas del último año
        PurchInvLine.SetCurrentKey("Pay-to Vendor No.", "Posting Date");
        PurchInvLine.SetRange("No.", Rec."No.");
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        PurchInvLine.SetRange("Posting Date", StartDate, Today);
        if PurchInvLine.FindSet() then
            repeat
                TotalCost += PurchInvLine."Direct Unit Cost" * PurchInvLine.Quantity;
                TotalQty += PurchInvLine.Quantity;
            until PurchInvLine.Next() = 0;

        if TotalQty <> 0 then
            LastYearUnitCost := TotalCost / TotalQty;
    end;

    var
        StockUnitCost: Decimal;
        LastYearUnitCost: Decimal;
}
