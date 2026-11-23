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
            ToolTip = 'Identifies the calculation of this line. The model only has the calculation against products.', Comment = 'ESP="Identifica el cálculo de esta línea. El modelo solo dispone del cálculo contra productos."';
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
                "JMC Cost Value Type" := "JMC Cost Value Type"::Amount;
                RequireLineRecalculation();
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

            trigger OnValidate()
            begin
                if "JMC Unit of Measure Code" <> xRec."JMC Unit of Measure Code" then
                    RequireLineRecalculation();
            end;
        }
        field(7; "JMC Recipe BOM Cost"; Decimal)
        {
            Caption = 'Recipe BOM Cost', Comment = 'ESP="Coste receta LM"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies recipe cost per selected unit saved by Calculate All Costs. It is kept for reference and is not part of the structure totals.', Comment = 'ESP="Especifica el coste de receta por unidad seleccionada guardado al calcular todos los costes. Se conserva como referencia y no forma parte de los totales de estructura."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(8; "JMC Cost Value Type"; Enum "JMC Cost Value Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            Editable = false;
            InitValue = Amount;
            ToolTip = 'Shows the cost type of structure cost C01 in the recipe: Amount in euros or Percentage of the recipe cost. It is read from the recipe when the model is calculated and cannot be edited here. For Percentage, Total Cost, Final Manual Cost and Cost Difference are expressed as percentages.', Comment = 'ESP="Muestra el tipo de coste del coste de estructura C01 de la receta: Importe en euros o Porcentaje sobre el coste de receta. Se lee de la receta al calcular el modelo y no se puede editar aquí. Con Porcentaje, Total coste, Coste final manual y Diferencia de coste se expresan en porcentaje."';
        }
        field(9; "JMC Priority Level"; Integer)
        {
            Caption = 'Priority Level', Comment = 'ESP="Nivel de prioridad"';
            InitValue = 1;
            MinValue = 1;
            MaxValue = 5;
            Editable = false;
            ToolTip = 'Specifies the priority of the item, from 1 to 5, copied from the item card when the model is calculated. It cannot be edited here; change it on the item card.', Comment = 'ESP="Especifica la prioridad del producto, del 1 al 5, copiada de la ficha del producto al calcular el modelo. No se puede editar aquí; cámbiela en la ficha del producto."';

            trigger OnValidate()
            begin
                if ("JMC Priority Level" < 1) or ("JMC Priority Level" > 5) then
                    FieldError("JMC Priority Level");
            end;
        }
        field(10; "JMC Industrial Cost"; Decimal)
        {
            Caption = 'Industrial Cost', Comment = 'ESP="Coste industrial"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the original calculated industrial cost per selected unit, before final manual adjustments.', Comment = 'ESP="Especifica el coste industrial calculado original por unidad seleccionada, antes de los ajustes manuales finales."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(11; "JMC Industrial Cost Pct."; Decimal)
        {
            Caption = 'Industrial Cost %', Comment = 'ESP="% CI"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the original calculated industrial cost as a percentage of recipe cost.', Comment = 'ESP="Especifica el coste industrial calculado original como porcentaje del coste de receta."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(12; "JMC Management Cost"; Decimal)
        {
            Caption = 'Full Management Cost', Comment = 'ESP="Coste completo de gestión"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the original calculated additional management cost per selected unit, before final manual adjustments.', Comment = 'ESP="Especifica el coste de gestión adicional calculado original por unidad seleccionada, antes de los ajustes manuales finales."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(13; "JMC Management Cost Pct."; Decimal)
        {
            Caption = 'Management Cost %', Comment = 'ESP="% CG"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the original calculated additional management cost as a percentage of recipe cost.', Comment = 'ESP="Especifica el coste de gestión adicional calculado original como porcentaje del coste de receta."';

            trigger OnValidate()
            begin
                RecalculateCosts();
            end;
        }
        field(14; "JMC EXWORK Standard"; Decimal)
        {
            Caption = 'EXWORK Standard', Comment = 'ESP="EXWORK estándar"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies industrial cost plus additional management cost, without recipe cost. It does not update the item standard cost.', Comment = 'ESP="Especifica el coste industrial más la gestión adicional, sin incluir el coste de receta. No actualiza el coste estándar del producto."';
        }
        field(20; "JMC Net Sales Quantity"; Decimal)
        {
            Caption = 'Calculated Net Sales Quantity', Comment = 'ESP="Cantidad neta de venta calculada"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies net quantities sold in this unit during the calculation period, using each posted conversion factor. Returns subtract and uninvoiced shipments are included.', Comment = 'ESP="Especifica las cantidades netas vendidas en esta unidad durante el periodo, usando cada factor de conversión registrado. Las devoluciones restan y se incluyen envíos sin facturar."';
        }
        field(21; "JMC Applied Priority Factor"; Decimal)
        {
            Caption = 'Applied Priority Factor', Comment = 'ESP="Factor de prioridad aplicado"';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(22; "JMC Assigned Industrial Cost"; Decimal)
        {
            Caption = 'Assigned Industrial Amount', Comment = 'ESP="Importe industrial asignado"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the allocation for this item and sales unit in the calculation against products. Amounts are not repeated across units.', Comment = 'ESP="Especifica el reparto de este producto y unidad de venta en el cálculo contra productos. Los importes no se repiten entre unidades."';
        }
        field(23; "JMC Assigned Management Cost"; Decimal)
        {
            Caption = 'Assigned Management Amount', Comment = 'ESP="Importe de gestión asignado"';
            DecimalPlaces = 2 : 2;
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
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the net base quantity of sales posted in this line''s unit. Sales in other units of the same item are not included.', Comment = 'ESP="Especifica la cantidad base neta de las ventas registradas en la unidad de esta línea. No incluye ventas en otras unidades del mismo producto."';
        }
        field(28; "JMC Total Cost"; Decimal)
        {
            Caption = 'Total Cost', Comment = 'ESP="Total coste"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies calculated industrial cost plus full management cost, excluding recipe cost. For the Amount type it is in euros per line unit; for the Percentage type it is the sum of the industrial and management percentages of the recipe cost.', Comment = 'ESP="Especifica el coste industrial más el coste completo de gestión calculados, sin incluir la receta. Con el tipo Importe está en euros por unidad de la línea; con el tipo Porcentaje es la suma de los porcentajes industrial y de gestión sobre el coste de receta."';
        }
        field(30; "JMC Final Cost"; Decimal)
        {
            Caption = 'Final Manual Cost', Comment = 'ESP="Coste final manual"';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            ToolTip = 'Specifies the structure cost retained for this line. Calculate All Costs reads C01 from the recipe; Recalculate Costs keeps the manual value. Apply Final Cost to Recipe writes it to the recipe.', Comment = 'ESP="Especifica el coste de estructura que se mantiene para esta línea. Calcular todos los costes lee C01 de la receta; Recalcular costes conserva el valor manual. Aplicar coste final a receta lo escribe en la receta."';

            trigger OnValidate()
            begin
                TestManualTotals();
            end;
        }
        field(33; "JMC Cost Difference"; Decimal)
        {
            Caption = 'Cost Difference', Comment = 'ESP="Diferencia de coste"';
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Shows TOTAL COST minus Final Manual Cost. A positive value means the calculated cost is higher than the cost kept in the recipe. It is in euros per line unit for the Amount type and in percentage points for the Percentage type.', Comment = 'ESP="Muestra TOTAL COSTE menos Coste final manual. Un valor positivo indica que el coste calculado es mayor que el coste que se mantiene en la receta. Está en euros por unidad de la línea con el tipo Importe y en puntos porcentuales con el tipo Porcentaje."';
        }
        field(31; "JMC Manual Totals Ready"; Boolean)
        {
            Caption = 'Manual Totals Initialized', Comment = 'ESP="Totales manuales inicializados"';
            Editable = false;
        }
        field(32; "JMC Structure Totals Ready"; Boolean)
        {
            Caption = 'Structure-only Totals Initialized', Comment = 'ESP="Totales sin receta inicializados"';
            Editable = false;
        }
        field(34; "JMC Actual Production Qty."; Decimal)
        {
            Caption = 'Actual Production Quantity', Comment = 'ESP="Cantidad real fabricación"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "JMC Theoretical Production Qty."; Decimal)
        {
            Caption = 'Theoretical Production Quantity', Comment = 'ESP="Cantidad teórica fabricación"';
            ToolTip = 'Specifies the production quantity used when recalculating costs, in the unit of this line. Zero excludes the line from allocation.', Comment = 'ESP="Especifica la cantidad de fabricación utilizada al recalcular costes, en la unidad de esta línea. El cero excluye la línea del reparto."';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "JMC Theoretical Production Qty." <> xRec."JMC Theoretical Production Qty." then begin
                    "JMC Manual Totals Ready" := false;
                    "JMC Structure Totals Ready" := false;
                end;
            end;
        }
        field(36; "JMC Production Unit Factor"; Decimal)
        {
            Caption = 'Production Unit Factor', Comment = 'ESP="Factor de unidad de fabricación"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(37; "JMC Source Calculation Issue"; Text[250])
        {
            Caption = 'Source Calculation Issue', Comment = 'ESP="Incidencia del cálculo de origen"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(38; "JMC Production Inputs Ready"; Boolean)
        {
            Caption = 'Production Inputs Ready', Comment = 'ESP="Datos de fabricación preparados"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(39; "JMC Personnel Cost"; Decimal)
        {
            Caption = 'Personnel Cost', Comment = 'ESP="Coste de personal"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Shows fixed resource personnel cost per unit allocated to this product line.', Comment = 'ESP="Muestra el coste fijo de personal por unidad asignado a esta línea de producto."';
        }
        field(40; "JMC Personnel Cost Pct."; Decimal)
        {
            Caption = 'Personnel Cost %', Comment = 'ESP="% coste de personal"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Editable = false;
            ToolTip = 'Shows personnel cost as a percentage of the recipe cost for the same unit.', Comment = 'ESP="Muestra el coste de personal como porcentaje del coste de receta para la misma unidad."';
        }
        field(41; "JMC Assigned Personnel Cost"; Decimal)
        {
            Caption = 'Assigned Personnel Amount', Comment = 'ESP="Importe de personal asignado"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Shows the total fixed resource personnel amount allocated to this product and unit for the whole period.', Comment = 'ESP="Muestra el importe total de personal de recursos fijos asignado a este producto y unidad para todo el periodo."';
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
        if "JMC Manual Totals Ready" and "JMC Structure Totals Ready" then
            Validate("JMC Final Cost");
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
        jmcRecipeCostRequiredErr: Label 'Enter a nonzero recipe cost before entering industrial, management or personnel amounts, so their percentages can be calculated.', Comment = 'ESP="Introduzca un coste de receta distinto de cero antes de introducir importes industriales, de gestión o de personal para poder calcular sus porcentajes."';
    begin
        if "JMC Recipe BOM Cost" = 0 then begin
            if ("JMC Industrial Cost" <> 0) or ("JMC Management Cost" <> 0) or ("JMC Personnel Cost" <> 0) then
                Error(jmcRecipeCostRequiredErr);
            "JMC Industrial Cost Pct." := 0;
            "JMC Management Cost Pct." := 0;
            "JMC Personnel Cost Pct." := 0;
        end else begin
            "JMC Industrial Cost Pct." := "JMC Industrial Cost" / "JMC Recipe BOM Cost" * 100;
            "JMC Management Cost Pct." := "JMC Management Cost" / "JMC Recipe BOM Cost" * 100;
            "JMC Personnel Cost Pct." := "JMC Personnel Cost" / "JMC Recipe BOM Cost" * 100;
        end;
        if "JMC Cost Value Type" = "JMC Cost Value Type"::Percentage then
            "JMC Total Cost" := "JMC Industrial Cost Pct." + "JMC Management Cost Pct." + "JMC Personnel Cost Pct."
        else
            "JMC Total Cost" := "JMC Industrial Cost" + "JMC Management Cost" + "JMC Personnel Cost";
        "JMC EXWORK Standard" := "JMC Industrial Cost" + "JMC Management Cost" + "JMC Personnel Cost";
        if "JMC Manual Totals Ready" and "JMC Structure Totals Ready" then
            "JMC Cost Difference" := "JMC Total Cost" - "JMC Final Cost"
        else
            "JMC Cost Difference" := 0;
    end;

    procedure ResetFinalTotals()
    begin
        RecalculateCosts();
        "JMC Manual Totals Ready" := "JMC Allocation Eligible" and ("JMC Calculation Issue" = '');
        "JMC Structure Totals Ready" := "JMC Manual Totals Ready";
        RecalculateCosts();
    end;

    local procedure RequireLineRecalculation()
    var
        jmcChangedLbl: Label 'Recalculate the model after changing the item or unit.', Comment = 'ESP="Recalcule el modelo tras cambiar el producto o la unidad."';
    begin
        "JMC Manual Totals Ready" := false;
        "JMC Structure Totals Ready" := false;
        "JMC Allocation Eligible" := false;
        "JMC Calculation Issue" := jmcChangedLbl;
        "JMC Production Inputs Ready" := false;
    end;

    procedure TestManualTotals()
    var
        jmcRecalculateErr: Label 'Calculate this model again before editing, simulating or applying final totals for this line. The line must be eligible and have no calculation issue.', Comment = 'ESP="Calcule de nuevo este modelo antes de editar, simular o aplicar los totales finales de esta línea. Debe ser apta y no tener incidencias."';
    begin
        if not "JMC Manual Totals Ready" or not "JMC Structure Totals Ready" or not "JMC Allocation Eligible" or ("JMC Calculation Issue" <> '') then
            Error(jmcRecalculateErr);
        TestField("JMC Recipe BOM Cost");
        if "JMC Final Cost" < 0 then
            FieldError("JMC Final Cost");
    end;

    procedure GetFinalExpenseAmount(): Decimal
    begin
        TestManualTotals();
        // Euros per line unit; a percentage is applied to the saved recipe cost of the same unit.
        if "JMC Cost Value Type" = "JMC Cost Value Type"::Percentage then
            exit("JMC Final Cost" * "JMC Recipe BOM Cost" / 100);
        exit("JMC Final Cost");
    end;
}
