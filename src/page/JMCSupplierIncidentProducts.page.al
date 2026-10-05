page 53322 "JMC Supplier Incident Products"
{
    PageType = ListPart;
    SourceTable = "JMC Supplier Incident Product";
    Caption = 'Incident Products', Comment = 'ESP="Productos de incidencia"';
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Products)
            {
                field("Source Line No."; Rec."JMC Source Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Item; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec."JMC Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec."JMC Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."JMC Lot No.") { ApplicationArea = All; }
                field(Observations; Rec."JMC Observations")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}