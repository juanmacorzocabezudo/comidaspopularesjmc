pageextension 53117 "JMC Resource Card" extends "Resource Card"
{
    layout
    {
        addafter(Type)
        {
            field("JMC Gestoría ID"; Rec."JMC Gestoría ID")
            {
                ApplicationArea = All;
                Caption = 'Gestoría ID', Comment = 'ESP="ID Gestoría"';
            }
            field("JMC Cost Type"; Rec."JMC Cost Type")
            {
                ApplicationArea = All;
                Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            }
        }
    }
}
