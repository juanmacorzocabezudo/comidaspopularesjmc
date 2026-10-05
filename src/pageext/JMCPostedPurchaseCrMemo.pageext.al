pageextension 53320 "JMC Posted Purchase Cr. Memo" extends "Posted Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("JMC Related Incident No."; Rec."JMC Related Incident No.")
            {
                ApplicationArea = All;
                Caption = 'Related Incident', Comment = 'ESP="Incidencia relacionada"';
                Editable = false;
            }
        }
    }
}