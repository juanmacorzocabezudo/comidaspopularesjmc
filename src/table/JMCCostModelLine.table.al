table 53103 "JMC Cost Model Line"
{
    Caption = 'Cost Model Line', Comment = 'ESP="Línea modelo de costes"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Model Code"; Code[20])
        {
            Caption = 'Model Code', Comment = 'ESP="Código modelo"';
            TableRelation = "JMC Cost Model"."JMC Code";
        }
        field(2; "JMC Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
        }
        field(3; "JMC Allocation Method"; Enum "JMC Cost Allocation Method")
        {
            Caption = 'Allocation Method', Comment = 'ESP="Método de reparto"';
            ToolTip = 'Specifies whether the line represents allocation against sales or recipe cost.', Comment = 'ESP="Especifica si la línea corresponde al reparto contra ventas o contra receta."';
        }
        field(4; "JMC Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item."No.";
            ToolTip = 'Specifies the item included in the cost model.', Comment = 'ESP="Especifica el producto incluido en el modelo de costes."';

            trigger OnValidate()
            var
                jmcItem: Record Item;
            begin
                if "JMC Item No." = '' then begin
                    Clear("JMC Item Description");
                    Clear("JMC Unit of Measure Code");
                end else begin
                    jmcItem.Get("JMC Item No.");
                    "JMC Item Description" := jmcItem.Description;
                    Validate("JMC Unit of Measure Code", jmcItem."Base Unit of Measure");
                end;
            end;
        }
        field(5; "JMC Item Description"; Text[100])
        {
            Caption = 'Item Description', Comment = 'ESP="Producto"';
            Editable = false;
            ToolTip = 'Specifies the item description copied when the item is selected.', Comment = 'ESP="Especifica la descripción copiada al seleccionar el producto."';
        }
        field(6; "JMC Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code', Comment = 'ESP="Unidad de medida"';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("JMC Item No."));
            ToolTip = 'Specifies the item unit of measure to which the manually entered costs apply. Changing it does not convert costs.', Comment = 'ESP="Especifica la unidad del producto a la que corresponden los costes introducidos. Cambiarla no convierte los costes."';
        }
        field(7; "JMC Recipe BOM Cost"; Decimal)
        {
            Caption = 'Recipe BOM Cost', Comment = 'ESP="Coste receta LM"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the recipe cost per selected unit of measure, entered manually.', Comment = 'ESP="Especifica el coste de receta por unidad de medida seleccionada, introducido manualmente."';
        }
        field(8; "JMC Cost Value Type"; Enum "JMC Cost Value Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            ToolTip = 'Specifies whether the cost is expressed as an amount or a percentage. No conversion is performed.', Comment = 'ESP="Especifica si el coste se expresa como importe o porcentaje. No se realiza ninguna conversión."';
        }
        field(9; "JMC Priority Level"; Integer)
        {
            Caption = 'Priority Level', Comment = 'ESP="Nivel de prioridad"';
            InitValue = 1;
            MinValue = 1;
            MaxValue = 5;
            ToolTip = 'Specifies the priority from 1 to 5. All lines start at 1. No redistribution is performed yet.', Comment = 'ESP="Especifica la prioridad del 1 al 5. Todas las líneas comienzan en 1. Todavía no se realiza ningún reparto."';
        }
        field(10; "JMC Industrial Cost"; Decimal)
        {
            Caption = 'Industrial Cost', Comment = 'ESP="Coste industrial"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the industrial cost amount per selected unit, entered manually.', Comment = 'ESP="Especifica el importe del coste industrial por unidad seleccionada, introducido manualmente."';
        }
        field(11; "JMC Industrial Cost Pct."; Decimal)
        {
            Caption = 'Industrial Cost %', Comment = 'ESP="% CI"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the industrial cost percentage entered manually.', Comment = 'ESP="Especifica el porcentaje de coste industrial introducido manualmente."';
        }
        field(12; "JMC Management Cost"; Decimal)
        {
            Caption = 'Full Management Cost', Comment = 'ESP="Coste completo de gestión"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the management cost amount per selected unit, entered manually.', Comment = 'ESP="Especifica el importe del coste de gestión por unidad seleccionada, introducido manualmente."';
        }
        field(13; "JMC Management Cost Pct."; Decimal)
        {
            Caption = 'Management Cost %', Comment = 'ESP="% CG"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the management cost percentage entered manually.', Comment = 'ESP="Especifica el porcentaje de coste de gestión introducido manualmente."';
        }
        field(14; "JMC EXWORK Standard"; Decimal)
        {
            Caption = 'EXWORK Standard', Comment = 'ESP="EXWORK estándar"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the EXWORK cost entered manually. It does not update the item standard cost.', Comment = 'ESP="Especifica el coste EXWORK introducido manualmente. No actualiza el coste estándar del producto."';
        }
    }

    keys
    {
        key(PK; "JMC Model Code", "JMC Line No.")
        {
            Clustered = true;
        }
        key(ItemMethod; "JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method")
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    begin
        TestField("JMC Model Code");
        TestField("JMC Item No.");
        TestField("JMC Unit of Measure Code");
    end;
}
