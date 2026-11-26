pageextension 53131 "JMC General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addafter("G/L Account No.")
        {
            field("JMC Resource No."; Rec."JMC Resource No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
