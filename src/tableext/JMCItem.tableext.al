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
        field(53103; "JMC Category Type"; Enum "JMC Category Type")
        {
            Caption = 'Category Type', Comment = 'ESP="Tipo categoría"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ClearCategoriesOfOtherType();
            end;
        }
        field(53104; "JMC Sub Item Category Code"; Code[20])
        {
            Caption = 'Item Subcategory Code', Comment = 'ESP="Sub familia producto"';
            DataClassification = CustomerContent;
            TableRelation = "Item Category" where("JMC Category Type" = field("JMC Category Type"));
        }
        field(53105; "JMC Item Category Name"; Text[100])
        {
            Caption = 'Item Category Name', Comment = 'ESP="Nombre familia"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category".Description where(Code = field("Item Category Code")));
            Editable = false;
        }
        field(53106; "JMC Item Subcategory Name"; Text[100])
        {
            Caption = 'Item Subcategory Name', Comment = 'ESP="Nombre sub familia"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category".Description where(Code = field("JMC Sub Item Category Code")));
            Editable = false;
        }
    }

    local procedure ClearCategoriesOfOtherType()
    begin
        if "Item Category Code" <> '' then
            if not CategoryHasType("Item Category Code") then
                Validate("Item Category Code", '');

        if "JMC Sub Item Category Code" <> '' then
            if not CategoryHasType("JMC Sub Item Category Code") then
                Validate("JMC Sub Item Category Code", '');
    end;

    local procedure CategoryHasType(CategoryCode: Code[20]): Boolean
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.SetRange(Code, CategoryCode);
        ItemCategory.SetRange("JMC Category Type", "JMC Category Type");
        exit(not ItemCategory.IsEmpty());
    end;
}
