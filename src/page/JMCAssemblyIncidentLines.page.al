page 53305 "JMC Assembly Incident Lines"
{
    PageType = List;
    SourceTable = "Assembly Line";
    SourceTableView = where(Type = const(Item));
    Caption = 'Select Component Line', Comment = 'ESP="Seleccionar línea de componente"';
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Vendor No."; ItemVendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.', Comment = 'ESP="Nº proveedor"';
                }
            }
        }
    }

    var
        Item: Record Item;
        ItemVendorNo: Code[20];

    trigger OnAfterGetRecord()
    begin
        Clear(ItemVendorNo);
        if Item.Get(Rec."No.") then
            ItemVendorNo := Item."Vendor No.";
    end;
}