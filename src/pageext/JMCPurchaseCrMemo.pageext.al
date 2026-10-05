pageextension 53313 "JMC Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("JMC Related Incident No."; Rec."JMC Related Incident No.")
            {
                ApplicationArea = All;
                Caption = 'Related Incident', Comment = 'ESP="Incidencia relacionada"';

                trigger OnLookup(var Text: Text): Boolean
                var
                    Incident: Record "JMC Supplier Incident";
                    IncidentList: Page "JMC Supplier Incident List";
                begin
                    Incident.SetRange("JMC Vendor No.", Rec."Buy-from Vendor No.");
                    IncidentList.SetTableView(Incident);
                    IncidentList.LookupMode(true);
                    if IncidentList.RunModal() <> Action::LookupOK then
                        exit(true);

                    IncidentList.GetRecord(Incident);
                    Rec.Validate("JMC Related Incident No.", Incident."JMC No.");
                    exit(true);
                end;
            }
        }
    }
}