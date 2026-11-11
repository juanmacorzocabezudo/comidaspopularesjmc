pageextension 53110 "JMC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Customer Posting Group")
        {
            field("JMC Customer Type"; Rec."JMC Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                ToolTip = 'Specifies the customer type.', Comment = 'ESP="Especifica el tipo de cliente."';
            }
        }
    }
}