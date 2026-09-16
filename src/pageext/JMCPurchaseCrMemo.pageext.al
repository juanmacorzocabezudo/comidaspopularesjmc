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
            }
        }
    }
}