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
        field(53101; "JMC Average Purchase Cost"; Decimal)
        {
            Caption = 'Last Direct Cost', Comment = 'ESP="Último coste directo"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            MinValue = 0;
            BlankZero = true;
            Editable = false;
        }
        field(53102; "JMC Last Purch. Invoice No."; Code[20])
        {
            Caption = 'Last Purchase Invoice No.', Comment = 'ESP="Nº última factura compra"';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
    }
}
