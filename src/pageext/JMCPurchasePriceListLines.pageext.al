pageextension 53100 "JMC Purchase Price List Lines" extends "Purchase Price List Lines"
{
    layout
    {
        addafter(Description)
        {
            field(JMCFormat; Rec."JMC Format")
            {
                ApplicationArea = All;
                Caption = 'Format', Comment = 'ESP="Formato"';
                ToolTip = 'Specifies the format of the purchase price.', Comment = 'ESP="Especifica el formato del precio de compra."';
            }
        }
    }
}