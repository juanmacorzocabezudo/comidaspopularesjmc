pageextension 53113 "JMC Purchase Order Subform" extends "Purchase Order Subform"
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
