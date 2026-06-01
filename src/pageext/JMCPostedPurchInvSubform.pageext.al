pageextension 53115 "JMC Pstd Purch Inv Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("JMC Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                Caption = 'Business Line', Comment = 'ESP="Línea negocio"';
                Visible = true;
            }
        }
    }
}
