pageextension 53300 "JMC Vendor List" extends "Vendor List"
{
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