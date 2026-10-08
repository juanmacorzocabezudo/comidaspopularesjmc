tableextension 53102 "JMC Price List Line" extends "Price List Line"
{
    fields
    {
        field(53100; "JMC Format"; Text[100])
        {
            Caption = 'Format', Comment = 'ESP="Formato"';
            ToolTip = 'Specifies the format of the purchase price.', Comment = 'ESP="Especifica el formato del precio de compra."';
            DataClassification = CustomerContent;
        }
    }
}