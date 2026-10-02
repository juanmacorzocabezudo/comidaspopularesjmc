page 53314 "JMC Vendor Incident FactBox"
{
    PageType = ListPart;
    SourceTable = "JMC Supplier Incident";
    Caption = 'Supplier Incidents', Comment = 'ESP="Incidencias de proveedor"';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Incidents)
            {
                field("No."; Rec."JMC No.") { ApplicationArea = All; }
                field(Date; Rec."JMC Date") { ApplicationArea = All; }
                field(Item; Rec."JMC Item No.") { ApplicationArea = All; }
                field("Detected By"; Rec."JMC Detected By") { ApplicationArea = All; }
                field("Credit Memo Registered"; Rec."JMC Credit Memo Registered") { ApplicationArea = All; }
            }
        }
    }
}