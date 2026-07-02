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
        addafter("Unit Cost")
        {
            field("JMC Stock Unit Cost"; StockUnitCost)
            {
                ApplicationArea = All;
                Caption = 'Stock Unit Cost', Comment = 'ESP="Coste Unitario Existencias"';
                ToolTip = 'Specifies the unit cost calculated only from inventory entries with remaining quantity greater than zero.', Comment = 'ESP="Especifica el coste unitario calculado solo de movimientos de inventario con cantidad pendiente mayor que cero."';
                DecimalPlaces = 2 : 5;
                Editable = false;
                BlankZero = true;
            }
            field("JMC Last Year Unit Cost"; LastYearUnitCost)
            {
                ApplicationArea = All;
                Caption = 'Last Year Unit Cost', Comment = 'ESP="Coste Unitario Último Año"';
                ToolTip = 'Specifies the unit cost calculated from all inventory entries in the last year.', Comment = 'ESP="Especifica el coste unitario calculado de todos los movimientos de inventario del último año."';
                DecimalPlaces = 2 : 5;
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
        ValueEntry: Record "Value Entry";
        TotalCost: Decimal;
        TotalQty: Decimal;
        StartDate: Date;
    begin
        Clear(LastYearUnitCost);
        StartDate := CalcDate('<-1Y>', Today);

        ValueEntry.SetCurrentKey("Item No.", "Posting Date");
        ValueEntry.SetRange("Item No.", Rec."No.");
        ValueEntry.SetRange("Posting Date", StartDate, Today);
        ValueEntry.SetFilter("Item Ledger Entry Quantity", '<>0');
        if ValueEntry.FindSet() then
            repeat
                TotalCost += ValueEntry."Cost Amount (Actual)";
                TotalQty += ValueEntry."Item Ledger Entry Quantity";
            until ValueEntry.Next() = 0;

        if TotalQty <> 0 then
            LastYearUnitCost := TotalCost / TotalQty;
    end;

    var
        StockUnitCost: Decimal;
        LastYearUnitCost: Decimal;
}
