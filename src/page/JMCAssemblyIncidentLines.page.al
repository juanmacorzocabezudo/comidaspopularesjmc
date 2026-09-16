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
            }
        }
    }
}