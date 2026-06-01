pageextension 53103 "JMC G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("Account Category")
        {
            field("JMC CP Categories"; Rec."JMC CP Categories")
            {
                ApplicationArea = All;
                Caption = 'CP Categories', Comment = 'ESP="Categorías CP"';
            }
        }
    }
}
