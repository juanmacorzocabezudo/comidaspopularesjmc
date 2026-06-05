pageextension 53116 "JMC Pstd Purch Cr M Subform" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("JMC Internal Notes"; Rec."JMC Internal Notes")
            {
                ApplicationArea = All;
                Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
            }
            field("JMC Received"; Rec."JMC Received")
            {
                ApplicationArea = All;
                Caption = 'Received', Comment = 'ESP="Recibido"';
            }
            field("JMC Recipe"; Rec."JMC Recipe")
            {
                ApplicationArea = All;
                Caption = 'Recipe', Comment = 'ESP="Receta"';
            }
        }
    }
}
