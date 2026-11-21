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
            ToolTip = 'Specifies the priority of this item when structure costs are allocated, from 1 to 5. The default is 1. Each priority applies the percentage defined in Priority Factors, so priority 1 receives the full share and lower priorities receive a smaller one. The cost model copies this value when it is calculated.', Comment = 'ESP="Especifica la prioridad de este producto al repartir los costes de estructura, del 1 al 5. El valor predeterminado es 1. Cada prioridad aplica el porcentaje definido en Factores de prioridad: la 1 recibe el reparto completo y las siguientes, uno menor. El modelo de costes copia este valor al calcularse."';
            DataClassification = CustomerContent;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 5;
        }
    }
}
