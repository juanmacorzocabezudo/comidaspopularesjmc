pageextension 53104 "JMC Chart of Accounts" extends "Chart of Accounts"
{
    layout
    {
        addafter("Account Category")
        {
            field("JMC CP Categories"; Rec."JMC CP Categories")
            {
                ApplicationArea = All;
                Caption = 'CP Categories', Comment = 'ESP="Categorías CP"';
                Visible = true;
            }
        }
    }
}
