page 53306 "JMC Supplier Incident List"
{
    PageType = List;
    SourceTable = "JMC Supplier Incident";
    Caption = 'Supplier Incidents', Comment = 'ESP="Incidencias de proveedor"';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "JMC Supplier Incident Card";

    layout
    {
        area(Content)
        {
            repeater(Incidents)
            {
                field("No."; Rec."JMC No.") { ApplicationArea = All; }
                field(Date; Rec."JMC Date") { ApplicationArea = All; }
                field(Vendor; Rec."JMC Vendor No.") { ApplicationArea = All; }
                field("Source Document No."; Rec."JMC Source Document No.") { ApplicationArea = All; }
                field(Item; Rec."JMC Item No.") { ApplicationArea = All; }
                field("Detected By"; Rec."JMC Detected By") { ApplicationArea = All; }
                field(Recurring; Rec."JMC Recurring Incident") { ApplicationArea = All; }
                field("Credit Memo Registered"; Rec."JMC Credit Memo Registered") { ApplicationArea = All; }
            }
        }
    }
}