pageextension 53122 "JMC Item Card" extends "Item Card"
{
    layout
    {
        addbefore("Item Category Code")
        {
            field("JMC Category Type"; Rec."JMC Category Type")
            {
                ApplicationArea = All;
                Caption = 'Category Type', Comment = 'ESP="Tipo categoría"';
                ToolTip = 'Specifies the category type of the item. It filters the available item categories and subcategories.', Comment = 'ESP="Especifica el tipo de categoría del producto. Filtra las familias y sub familias disponibles."';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
        // The standard control is replaced because a table extension cannot narrow the TableRelation of a base field.
        modify("Item Category Code")
        {
            Visible = false;
        }
        addafter("Item Category Code")
        {
            field("JMC Item Category Code"; JMCItemCategoryCode)
            {
                ApplicationArea = All;
                Caption = 'Item Category Code', Comment = 'ESP="Familia producto"';
                ToolTip = 'Specifies the item category. Only categories with the same category type as the item are offered.', Comment = 'ESP="Especifica la familia del producto. Solo se ofrecen categorías del mismo tipo que el producto."';
                TableRelation = "Item Category" where("JMC Category Type" = field("JMC Category Type"));

                trigger OnValidate()
                begin
                    Rec.Validate("Item Category Code", JMCItemCategoryCode);
                    CurrPage.ItemAttributesFactbox.Page.LoadItemAttributesData(Rec."No.");
                    CurrPage.Update(true);
                end;
            }
            field("JMC Item Category Name"; Rec."JMC Item Category Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the item category.', Comment = 'ESP="Especifica la descripción de la familia del producto."';
            }
            field("JMC Sub Item Category Code"; Rec."JMC Sub Item Category Code")
            {
                ApplicationArea = All;
                Caption = 'Item Subcategory Code', Comment = 'ESP="Sub familia producto"';
                ToolTip = 'Specifies the item subcategory. Only categories with the same category type as the item are offered.', Comment = 'ESP="Especifica la sub familia del producto. Solo se ofrecen categorías del mismo tipo que el producto."';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
            field("JMC Item Subcategory Name"; Rec."JMC Item Subcategory Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the item subcategory.', Comment = 'ESP="Especifica la descripción de la sub familia del producto."';
            }
        }
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
        JMCItemCategoryCode := Rec."Item Category Code";
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        JMCItemCategoryCode := '';
    end;

    var
        JMCItemCategoryCode: Code[20];
        StockUnitCost: Decimal;
        LastYearUnitCost: Decimal;
}
