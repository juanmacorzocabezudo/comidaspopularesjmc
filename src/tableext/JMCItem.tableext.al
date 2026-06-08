tableextension 53115 "JMC Item" extends Item
{
    fields
    {
        field(53100; "JMC Weight"; Decimal)
        {
            Caption = 'Weight', Comment = 'ESP="Peso"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            BlankZero = true;
        }
    }
}
