pageextension 53315 "JMC Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part("JMC Supplier Incidents"; "JMC Vendor Incident FactBox")
            {
                ApplicationArea = All;
                Caption = 'Supplier Incidents', Comment = 'ESP="Incidencias de proveedor"';
                SubPageLink = "JMC Vendor No." = field("No.");
            }
        }
    }

    actions
    {
        addafter("Ven&dor")
        {
            action("JMC View Supplier Incidents")
            {
                ApplicationArea = All;
                Caption = 'View Incidents', Comment = 'ESP="Ver incidencias"';
                Image = Navigate;

                trigger OnAction()
                var
                    Incident: Record "JMC Supplier Incident";
                begin
                    Incident.SetRange("JMC Vendor No.", Rec."No.");
                    Page.Run(Page::"JMC Supplier Incident List", Incident);
                end;
            }
        }
    }
}