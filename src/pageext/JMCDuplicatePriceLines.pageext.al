pageextension 53105 "JMC Duplicate Price Lines" extends "Duplicate Price Lines"
{
    layout
    {
        addafter(Description)
        {
            field(JMCFormat; CurrPriceListLine."JMC Format")
            {
                ApplicationArea = All;
                Caption = 'Format', Comment = 'ESP="Formato"';
                Editable = false;
                Visible = not IsSalesPrice;
                ToolTip = 'Specifies the format of the purchase price.', Comment = 'ESP="Especifica el formato del precio de compra."';
            }
        }
    }
}