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
            ToolTip = 'Specifies the unit used in this line''s posted sales. Quantities and allocations belong only to this item and unit.', Comment = 'ESP="Especifica la unidad utilizada en las ventas registradas de esta línea. Las cantidades y los repartos corresponden solo a este producto y unidad."';
        }
        field(7; "JMC Recipe BOM Cost"; Decimal)
        {
            Caption = 'Recipe BOM Cost', Comment = 'ESP="Coste receta LM"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the recipe cost per selected unit, entered manually or read from the current recipe by Calculate All Costs.', Comment = 'ESP="Especifica el coste de receta por unidad seleccionada, introducido manualmente o leído de la receta actual mediante Calcular todos los costes."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(8; "JMC Cost Value Type"; Enum "JMC Cost Value Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            ToolTip = 'Specifies whether amounts or percentages of recipe cost are entered. The other values are calculated.', Comment = 'ESP="Especifica si se introducen importes o porcentajes sobre el coste de receta. Los otros valores se calculan."';

            trigger OnValidate()
            var
                jmcNewValueType: Enum "JMC Cost Value Type";
            begin
                if "JMC Cost Value Type" <> xRec."JMC Cost Value Type" then begin
                    jmcNewValueType := "JMC Cost Value Type";
                    "JMC Cost Value Type" := xRec."JMC Cost Value Type";
                    RecalculateCosts();
                    "JMC Cost Value Type" := jmcNewValueType;
                end;
                RecalculateCosts();
            end;
        }
        field(9; "JMC Priority Level"; Integer)
        {
            Caption = 'Priority Level', Comment = 'ESP="Nivel de prioridad"';
            Editable = false;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 5;
            ToolTip = 'Specifies the item priority copied from its card when calculating. Configure the approved factor for levels 1 to 5.', Comment = 'ESP="Especifica la prioridad del producto copiada de su ficha al calcular. Configure el factor aprobado para los niveles del 1 al 5."';
        }
        field(10; "JMC Industrial Cost"; Decimal)
        {
            Caption = 'Industrial Cost', Comment = 'ESP="Coste industrial"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the industrial cost per selected unit. Enter it when the cost type is Amount.', Comment = 'ESP="Especifica el coste industrial por unidad seleccionada. Se introduce cuando el tipo de coste es Importe."';

            trigger OnValidate()
            begin
                TestField("JMC Cost Value Type", "JMC Cost Value Type"::Amount);
                RecalculateCosts();
            end;
        }
        field(11; "JMC Industrial Cost Pct."; Decimal)
        {
            Caption = 'Industrial Cost %', Comment = 'ESP="% CI"';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the industrial percentage of recipe cost. Enter it when the cost type is Percentage.', Comment = 'ESP="Especifica el porcentaje industrial sobre el coste de receta. Se introduce cuando el tipo de coste es Porcentaje."';

            trigger OnValidate()
            begin
                TestField("JMC Cost Value Type", "JMC Cost Value Type"::Percentage);
                RecalculateCosts();
            end;
        }
        field(12; "JMC Management Cost"; Decimal)
        {
            Caption = 'Full Management Cost', Comment = 'ESP="Coste completo de gestión"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the additional management cost per selected unit. Enter it when the cost type is Amount.', Comment = 'ESP="Especifica el coste de gestión adicional por unidad seleccionada. Se introduce cuando el tipo de coste es Importe."';

            trigger OnValidate()
            begin
                TestField("JMC Cost Value Type", "JMC Cost Value Type"::Amount);
                RecalculateCosts();
            end;
        }
        field(13; "JMC Management Cost Pct."; Decimal)
        {
            Caption = 'Management Cost %', Comment = 'ESP="% CG"';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the additional management percentage of recipe cost. Enter it when the cost type is Percentage.', Comment = 'ESP="Especifica el porcentaje de gestión adicional sobre el coste de receta. Se introduce cuando el tipo de coste es Porcentaje."';

            trigger OnValidate()
            begin
                TestField("JMC Cost Value Type", "JMC Cost Value Type"::Percentage);
                RecalculateCosts();
            end;
        }
        field(14; "JMC EXWORK Standard"; Decimal)
        {
            Caption = 'EXWORK Standard', Comment = 'ESP="EXWORK estándar"';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies recipe cost plus industrial cost plus additional management cost. It does not update the item standard cost.', Comment = 'ESP="Especifica el coste de receta más el industrial y la gestión adicional. No actualiza el coste estándar del producto."';
        }
        field(20; "JMC Net Sales Quantity"; Decimal)
        {
            Caption = 'Calculated Net Sales Quantity', Comment = 'ESP="Cantidad neta de venta calculada"';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies net quantities sold in this unit during the calculation period, using each posted conversion factor. Returns subtract and uninvoiced shipments are included.', Comment = 'ESP="Especifica las cantidades netas vendidas en esta unidad durante el periodo, usando cada factor de conversión registrado. Las devoluciones restan y se incluyen envíos sin facturar."';
        }
        field(21; "JMC Applied Priority Factor"; Decimal)
        {
            Caption = 'Applied Priority Factor', Comment = 'ESP="Factor de prioridad aplicado"';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(22; "JMC Assigned Industrial Cost"; Decimal)
        {
            Caption = 'Assigned Industrial Amount', Comment = 'ESP="Importe industrial asignado"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the allocation for this item and sales unit within this alternative method. Amounts are not repeated across units.', Comment = 'ESP="Especifica el reparto de este producto y unidad de venta dentro de este método alternativo. Los importes no se repiten entre unidades."';
        }
        field(23; "JMC Assigned Management Cost"; Decimal)
        {
            Caption = 'Assigned Management Amount', Comment = 'ESP="Importe de gestión asignado"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(24; "JMC Calculation Issue"; Text[250])
        {
            Caption = 'Calculation Issue', Comment = 'ESP="Incidencia del cálculo"';
            Editable = false;
            ToolTip = 'Explains why no allocation was calculated. Zero structure amounts on a line with an issue are not a valid zero cost.', Comment = 'ESP="Explica por qué no se ha calculado el reparto. Los importes de estructura a cero en una línea con incidencia no representan un coste cero válido."';
        }
        field(25; "JMC Allocation Eligible"; Boolean)
        {
            Caption = 'Eligible for Allocation', Comment = 'ESP="Apto para reparto"';
            Editable = false;
        }
        field(26; "JMC Net Sales Base Qty."; Decimal)
        {
            Caption = 'Net Sales Quantity (Base)', Comment = 'ESP="Cantidad neta de venta (base)"';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the net base quantity of sales posted in this line''s unit. Sales in other units of the same item are not included.', Comment = 'ESP="Especifica la cantidad base neta de las ventas registradas en la unidad de esta línea. No incluye ventas en otras unidades del mismo producto."';
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
    var
        jmcCostModelLine: Record "JMC Cost Model Line";
    begin
        TestField("JMC Model Code");
        TestField("JMC Item No.");
        if "JMC Line No." = 0 then begin
            jmcCostModelLine.LockTable();
            jmcCostModelLine.SetRange("JMC Model Code", "JMC Model Code");
            if jmcCostModelLine.FindLast() then
                "JMC Line No." := jmcCostModelLine."JMC Line No.";
            "JMC Line No." += 10000;
        end;
        RecalculateCosts();
        InvalidateCalculation("JMC Model Code");
    end;

    trigger OnModify()
    begin
        RecalculateCosts();
        InvalidateCalculation("JMC Model Code");
    end;

    trigger OnDelete()
    begin
        InvalidateCalculation("JMC Model Code");
    end;

    trigger OnRename()
    begin
        InvalidateCalculation(xRec."JMC Model Code");
        InvalidateCalculation("JMC Model Code");
    end;

    local procedure InvalidateCalculation(jmcModelCode: Code[20])
    var
        jmcCostModel: Record "JMC Cost Model";
    begin
        if jmcCostModel.Get(jmcModelCode) then
            if jmcCostModel."JMC Calculation Current" then begin
                jmcCostModel."JMC Calculation Current" := false;
                jmcCostModel.Modify(false);
            end;
    end;

    procedure RecalculateCosts()
    var
        jmcRecipeCostRequiredErr: Label 'Enter a nonzero recipe cost before entering industrial or management amounts, so their percentages can be calculated.', Comment = 'ESP="Introduzca un coste de receta distinto de cero antes de introducir importes industriales o de gestión para poder calcular sus porcentajes."';
    begin
        case "JMC Cost Value Type" of
            "JMC Cost Value Type"::Amount:
                begin
                    if "JMC Recipe BOM Cost" = 0 then begin
                        if ("JMC Industrial Cost" <> 0) or ("JMC Management Cost" <> 0) then
                            Error(jmcRecipeCostRequiredErr);
                        "JMC Industrial Cost Pct." := 0;
                        "JMC Management Cost Pct." := 0;
                    end else begin
                        "JMC Industrial Cost Pct." := Round("JMC Industrial Cost" / "JMC Recipe BOM Cost" * 100, 0.00001);
                        "JMC Management Cost Pct." := Round("JMC Management Cost" / "JMC Recipe BOM Cost" * 100, 0.00001);
                    end;
                end;
            "JMC Cost Value Type"::Percentage:
                begin
                    "JMC Industrial Cost" := Round("JMC Recipe BOM Cost" * "JMC Industrial Cost Pct." / 100, 0.00001);
                    "JMC Management Cost" := Round("JMC Recipe BOM Cost" * "JMC Management Cost Pct." / 100, 0.00001);
                end;
        end;
        "JMC EXWORK Standard" := "JMC Recipe BOM Cost" + "JMC Industrial Cost" + "JMC Management Cost";
    end;
}
