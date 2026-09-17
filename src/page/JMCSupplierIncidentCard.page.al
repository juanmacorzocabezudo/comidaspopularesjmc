page 53307 "JMC Supplier Incident Card"
{
    PageType = Card;
    SourceTable = "JMC Supplier Incident";
    Caption = 'Supplier Incident', Comment = 'ESP="Incidencia de proveedor"';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                field("No."; Rec."JMC No.") { ApplicationArea = All; Editable = false; }
                field("No. Series"; Rec."JMC No. Series") { ApplicationArea = All; }
                field(Date; Rec."JMC Date") { ApplicationArea = All; }
                field(Vendor; Rec."JMC Vendor No.") { ApplicationArea = All; }
                field("Vendor Name"; Rec."JMC Vendor Name") { ApplicationArea = All; }
                field("Source Type"; Rec."JMC Source Type") { ApplicationArea = All; }
                field("Source Document No."; Rec."JMC Source Document No.") { ApplicationArea = All; }
                field("Source Line No."; Rec."JMC Source Line No.") { ApplicationArea = All; }
                field(Item; Rec."JMC Item No.") { ApplicationArea = All; }
                field("Item Description"; Rec."JMC Item Description") { ApplicationArea = All; }
                field("Lot No."; Rec."JMC Lot No.") { ApplicationArea = All; }
                field("Detected By"; Rec."JMC Detected By") { ApplicationArea = All; }
                field("Recurring Incident"; Rec."JMC Recurring Incident") { ApplicationArea = All; }
                field("NC No."; Rec."JMC NC No.") { ApplicationArea = All; }
            }
            group(Details)
            {
                Caption = 'Details', Comment = 'ESP="Detalles"';
                field("Incident Description"; Rec."JMC Incident Description") { ApplicationArea = All; MultiLine = true; }
                field("Supplier Communication"; Rec."JMC Supplier Communication") { ApplicationArea = All; MultiLine = true; }
                field("Communication Date"; Rec."JMC Communication Date") { ApplicationArea = All; }
                field("Supplier Response"; Rec."JMC Supplier Response") { ApplicationArea = All; MultiLine = true; }
                field("Corrective Measures"; Rec."JMC Corrective Measures") { ApplicationArea = All; MultiLine = true; }
            }
            group(Closing)
            {
                Caption = 'Closing', Comment = 'ESP="Cierre"';
                field("Credit Memo Registered"; Rec."JMC Credit Memo Registered") { ApplicationArea = All; Editable = false; }
                field("Created By"; Rec."JMC Created By") { ApplicationArea = All; }
                field("Creation DateTime"; Rec."JMC Creation DateTime") { ApplicationArea = All; }
            }
        }
        area(FactBoxes)
        {
            part(Attachments; "JMC Incident Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments', Comment = 'ESP="Documentos adjuntos"';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Attachments.Page.SetIncident(Rec);
    end;

}