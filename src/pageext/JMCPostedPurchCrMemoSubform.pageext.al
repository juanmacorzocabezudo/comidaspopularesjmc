pageextension 53116 "JMC Pstd Purch Cr M Subform" extends "Posted Purch. Cr. Memo Subform"
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
