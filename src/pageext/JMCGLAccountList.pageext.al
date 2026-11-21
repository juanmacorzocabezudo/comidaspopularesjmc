pageextension 53129 "JMC Chart of Accounts" extends "Chart of Accounts"
{
    layout
    {
        addafter(Name)
        {
            field("JMC Cost Type"; Rec."JMC Cost Type")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies whether the account cost is fixed or variable.', Comment = 'ESP="Especifica si el coste de la cuenta es fijo o variable."';
            }
            field("JMC Cost Classification"; Rec."JMC Cost Classification")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Cost Classification', Comment = 'ESP="Clasificación del coste"';
                ToolTip = 'Specifies whether the account belongs to industrial manufacturing cost or full management cost.', Comment = 'ESP="Especifica si la cuenta corresponde al coste industrial de fabricación o al coste completo de gestión."';
            }
        }
    }
}
