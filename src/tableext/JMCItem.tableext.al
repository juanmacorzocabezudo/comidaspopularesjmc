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
        field(53103; "JMC Priority Level"; Integer)
        {
            Caption = 'Priority Level', Comment = 'ESP="Nivel de prioridad"';
            ToolTip = 'Specifies the item priority for structure allocation, from 1 to 5. The default is 1. Changes apply when model costs are recalculated.', Comment = 'ESP="Especifica la prioridad del producto para el reparto de estructura, del 1 al 5. El valor predeterminado es 1. Los cambios se aplican al recalcular los costes del modelo."';
            DataClassification = CustomerContent;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 5;
        }
    }
}
