pageextension 53110 "JMC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Global Dimension 1 Code")
        {
            field("JMC Customer Type"; Rec."JMC Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                ToolTip = 'Specifies the customer type.', Comment = 'ESP="Especifica el tipo de cliente."';
                ShowMandatory = true;
            }
        }
        modify("Global Dimension 1 Code")
        {
            ShowMandatory = true;
        }
    }
}