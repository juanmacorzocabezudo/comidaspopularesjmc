page 53304 "JMC Supplier Incident Lines"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where(Type = const(Item));
    Caption = 'Select Item Line', Comment = 'ESP="Seleccionar línea de producto"';
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
            }
        }
    }
}