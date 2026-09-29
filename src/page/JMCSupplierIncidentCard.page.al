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
                field("Detected By"; Rec."JMC Detected By") { ApplicationArea = All; }
                field("Recurring Incident"; Rec."JMC Recurring Incident") { ApplicationArea = All; }
            }
            part(ProductLines; "JMC Supplier Incident Products")
            {
                ApplicationArea = All;
                Caption = 'Products', Comment = 'ESP="Productos"';
                SubPageLink = "JMC Incident No." = field("JMC No.");
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
                field("Credit Memo Required"; Rec."JMC Credit Memo Required") { ApplicationArea = All; }
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

    actions
    {
        area(Processing)
        {
            action("JMC Add Products")
            {
                ApplicationArea = All;
                Caption = 'Add Products', Comment = 'ESP="Añadir productos"';
                ToolTip = 'Add products from the related source document.', Comment = 'ESP="Añade productos del documento de origen relacionado."';
                Image = New;

                trigger OnAction()
                var
                    IncidentMgt: Codeunit "JMC Supplier Incident Mgt";
                begin
                    IncidentMgt.AddProductsToIncident(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnsureLegacyProductLine();
        CurrPage.Attachments.Page.SetIncident(Rec);
    end;

    local procedure EnsureLegacyProductLine()
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
    begin
        if Rec."JMC Item No." = '' then
            exit;

        IncidentProduct.SetRange("JMC Incident No.", Rec."JMC No.");
        if not IncidentProduct.IsEmpty() then
            exit;

        IncidentProduct.Init();
        IncidentProduct."JMC Incident No." := Rec."JMC No.";
        IncidentProduct."JMC Line No." := 10000;
        IncidentProduct."JMC Source Line No." := Rec."JMC Source Line No.";
        IncidentProduct."JMC Item No." := Rec."JMC Item No.";
        IncidentProduct."JMC Item Description" := Rec."JMC Item Description";
        IncidentProduct.Insert(true);
    end;

}