page 53306 "JMC Supplier Incident List"
{
    PageType = List;
    SourceTable = "JMC Supplier Incident";
    Caption = 'Incident List', Comment = 'ESP="Lista incidencias"';
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
            action("JMC Print Incidents")
            {
                ApplicationArea = All;
                Caption = 'Print Incidents', Comment = 'ESP="Imprimir incidencias"';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Incident: Record "JMC Supplier Incident";
                begin
                    Incident.Copy(Rec);
                    Report.Run(Report::"JMC Supplier Incident Report", true, false, Incident);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Attachments.Page.SetIncident(Rec);
    end;

}