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
}