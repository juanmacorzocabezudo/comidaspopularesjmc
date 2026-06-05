pageextension 53113 "JMC Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("JMC Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Business Line', Comment = 'ESP="Línea negocio"';
                Visible = true;
            }
            field("JMC Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
                Caption = 'Family', Comment = 'ESP="Familia"';
                Visible = true;
            }
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
                Caption = 'Recipe (Free Text)', Comment = 'ESP="Receta (Texto libre)"';
            }
        }
    }
}
