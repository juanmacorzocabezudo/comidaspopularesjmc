pageextension 53114 "JMC Pstd Purch Rcpt Subform" extends "Posted Purchase Rcpt. Subform"
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
