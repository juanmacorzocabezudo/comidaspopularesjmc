pageextension 53311 "JMC Assembly Order" extends "Assembly Order"
{
    actions
    {
        addlast(processing)
        {
            action("JMC Create Incident")
            {
                ApplicationArea = All;
                Caption = 'Create Incident', Comment = 'ESP="Crear incidencia"';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    IncidentMgt: Codeunit "JMC Supplier Incident Mgt";
                begin
                    IncidentMgt.CreateFromAssemblyOrder(Rec);
                end;
            }
        }
        addlast(navigation)
        {
            action("JMC View Incidents")
            {
                ApplicationArea = All;
                Caption = 'View Incidents', Comment = 'ESP="Ver incidencias"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Incident: Record "JMC Supplier Incident";
                begin
                    Incident.SetRange("JMC Source Type", Incident."JMC Source Type"::"Assembly Order");
                    Incident.SetRange("JMC Source Document No.", Rec."No.");
                    Page.Run(Page::"JMC Supplier Incident List", Incident);
                end;
            }
        }
    }
}