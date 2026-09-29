page 53323 "JMC Incident Tracking Lots"
{
    PageType = List;
    SourceTable = "Reservation Entry";
    SourceTableView = sorting("Entry No.") where("Lot No." = filter(<> ''));
    Caption = 'Select Tracked Lot', Comment = 'ESP="Seleccionar lote de seguimiento"';
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lots)
            {
                field("Lot No."; Rec."Lot No.") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
            }
        }
    }
}