table 53102 "JMC Cost Model"
{
    Caption = 'Cost Model', Comment = 'ESP="Modelo de costes"';
    DataClassification = CustomerContent;
    LookupPageId = "JMC Cost Model Card";
    DrillDownPageId = "JMC Cost Model Card";

    fields
    {
        field(1; "JMC Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            Editable = false;
            NotBlank = true;
        }
        field(2; "JMC Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            ToolTip = 'Specifies the description of the cost model.', Comment = 'ESP="Especifica la descripción del modelo de costes."';
        }
        field(10; "JMC Total Structure Cost"; Decimal)
        {
            Caption = 'Total Structure Cost', Comment = 'ESP="Gasto de estructura total"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the net fixed structure cost read from configured G/L accounts for the calculation period. Variable costs are excluded.', Comment = 'ESP="Especifica el coste fijo neto de estructura obtenido de las cuentas contables configuradas para el periodo del cálculo. Se excluyen los costes variables."';

            trigger OnValidate()
            begin
                RecalculateAllocations();
            end;
        }
        field(11; "JMC Catering Structure Pct."; Decimal)
        {
            Caption = 'Catering Structure %', Comment = 'ESP="% estructura Catering"';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
            ToolTip = 'Specifies the catering share of actual production cost, calculated from the business line dimension of posted assembly outputs.', Comment = 'ESP="Especifica la proporción de Catering sobre el coste real de producción, calculada a partir de la dimensión de línea de negocio de las salidas de ensamblado registradas."';

            trigger OnValidate()
            begin
                RecalculateAllocations();
            end;
        }
        field(12; "JMC Industry Structure Pct."; Decimal)
        {
            Caption = 'Industry Structure %', Comment = 'ESP="% estructura Alimentación"';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
            ToolTip = 'Specifies the industry share of actual production cost, calculated from the business line dimension of posted assembly outputs.', Comment = 'ESP="Especifica la proporción de Alimentación sobre el coste real de producción, calculada a partir de la dimensión de línea de negocio de las salidas de ensamblado registradas."';

            trigger OnValidate()
            begin
                RecalculateAllocations();
            end;
        }
        field(13; "JMC Catering Allocation"; Decimal)
        {
            Caption = 'Catering Allocation', Comment = 'ESP="Reparto Catering"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the total structure cost multiplied by the catering percentage.', Comment = 'ESP="Especifica el gasto de estructura total multiplicado por el porcentaje de Catering."';
        }
        field(14; "JMC Industry Allocation"; Decimal)
        {
            Caption = 'Industry Allocation', Comment = 'ESP="Reparto Alimentación"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the remaining structure cost allocated to industry after rounding.', Comment = 'ESP="Especifica el gasto de estructura restante asignado a Alimentación tras el redondeo."';
        }
        field(20; "JMC Starting Date"; Date)
        {
            Caption = 'Calculation Starting Date', Comment = 'ESP="Fecha inicial del cálculo"';
            Editable = false;
        }
        field(21; "JMC Ending Date"; Date)
        {
            Caption = 'Calculation Ending Date', Comment = 'ESP="Fecha final del cálculo"';
            Editable = false;
        }
        field(22; "JMC Account Filter"; Text[250])
        {
            Caption = 'Calculation Account Filter', Comment = 'ESP="Filtro de cuentas del cálculo"';
            Editable = false;
        }
        field(23; "JMC Calculated At"; DateTime)
        {
            Caption = 'Calculated At', Comment = 'ESP="Fecha y hora del cálculo"';
            Editable = false;
        }
        field(24; "JMC Calculation Current"; Boolean)
        {
            Caption = 'Model Unchanged Since Calculation', Comment = 'ESP="Modelo sin cambios desde el cálculo"';
            Editable = false;
            ToolTip = 'Indicates that model inputs and priority factors have not changed. Later changes to ledger entries or recipes are not monitored; recalculate to refresh source data.', Comment = 'ESP="Indica que no han cambiado las entradas del modelo ni los factores. No se supervisan cambios posteriores en movimientos o recetas; recalcule para actualizar las fuentes."';
        }
        field(25; "JMC Fixed Industrial Fund"; Decimal)
        {
            Caption = 'Fixed Industrial Fund', Comment = 'ESP="Fondo industrial fijo"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(26; "JMC Variable Industrial Fund"; Decimal)
        {
            Caption = 'Variable Industrial Fund', Comment = 'ESP="Fondo industrial variable"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(27; "JMC Fixed Management Fund"; Decimal)
        {
            Caption = 'Fixed Management Fund', Comment = 'ESP="Fondo de gestión fijo"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(28; "JMC Variable Management Fund"; Decimal)
        {
            Caption = 'Variable Management Fund', Comment = 'ESP="Fondo de gestión variable"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(29; "JMC Sales Pending Industrial"; Decimal)
        {
            Caption = 'Sales: Unallocated Industrial', Comment = 'ESP="Ventas: industrial pendiente de reparto"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(30; "JMC Sales Pending Management"; Decimal)
        {
            Caption = 'Sales: Unallocated Management', Comment = 'ESP="Ventas: gestión pendiente de reparto"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(31; "JMC Recipe Pending Industrial"; Decimal)
        {
            Caption = 'Recipe: Unallocated Industrial', Comment = 'ESP="Receta: industrial pendiente de reparto"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(32; "JMC Recipe Pending Management"; Decimal)
        {
            Caption = 'Recipe: Unallocated Management', Comment = 'ESP="Receta: gestión pendiente de reparto"';
            AutoFormatType = 1;
            Editable = false;
        }
        field(33; "JMC Catering Production Cost"; Decimal)
        {
            Caption = 'Catering Production Cost', Comment = 'ESP="Coste de producción Catering"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the net actual cost of final assembly outputs in the period with LINEA = CATERING, including cost adjustments available when calculated.', Comment = 'ESP="Especifica el coste real neto de las salidas de ensamblado finales del periodo con LINEA = CATERING, incluidos los ajustes de coste disponibles al calcular."';
        }
        field(34; "JMC Industry Production Cost"; Decimal)
        {
            Caption = 'Industry Production Cost', Comment = 'ESP="Coste de producción Alimentación"';
            AutoFormatType = 1;
            Editable = false;
            ToolTip = 'Specifies the net actual cost of final assembly outputs in the period with LINEA = ALIMENTACION, including cost adjustments available when calculated.', Comment = 'ESP="Especifica el coste real neto de las salidas de ensamblado finales del periodo con LINEA = ALIMENTACION, incluidos los ajustes de coste disponibles al calcular."';
        }
        field(35; "JMC Production Dimension"; Code[20])
        {
            Caption = 'Production Business Dimension', Comment = 'ESP="Dimensión de línea de negocio de producción"';
            TableRelation = Dimension.Code;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        jmcExistingCostModel: Record "JMC Cost Model";
        jmcSingleModelErr: Label 'Only one cost model is allowed per company.', Comment = 'ESP="Solo se permite un modelo de costes por empresa."';
    begin
        TestField("JMC Code", 'GENERAL');
        jmcExistingCostModel.LockTable();
        if not jmcExistingCostModel.IsEmpty() then
            Error(jmcSingleModelErr);
        RecalculateAllocations();
    end;

    trigger OnDelete()
    var
        jmcCostModelLine: Record "JMC Cost Model Line";
    begin
        jmcCostModelLine.SetRange("JMC Model Code", "JMC Code");
        jmcCostModelLine.DeleteAll(true);
    end;

    trigger OnRename()
    var
        jmcCostModelLine: Record "JMC Cost Model Line";
        jmcRenameWithLinesErr: Label 'You cannot rename a cost model that has lines.', Comment = 'ESP="No se puede cambiar el código de un modelo de costes que tiene líneas."';
    begin
        TestField("JMC Code");
        jmcCostModelLine.SetRange("JMC Model Code", xRec."JMC Code");
        if not jmcCostModelLine.IsEmpty() then
            Error(jmcRenameWithLinesErr);
    end;

    procedure RecalculateAllocations()
    var
        jmcGLSetup: Record "General Ledger Setup";
        jmcProductionCost: Decimal;
    begin
        jmcGLSetup.Get();
        jmcGLSetup.TestField("Amount Rounding Precision");
        if "JMC Catering Production Cost" < 0 then
            FieldError("JMC Catering Production Cost");
        if "JMC Industry Production Cost" < 0 then
            FieldError("JMC Industry Production Cost");
        jmcProductionCost := "JMC Catering Production Cost" + "JMC Industry Production Cost";
        if jmcProductionCost = 0 then begin
            "JMC Catering Structure Pct." := 0;
            "JMC Industry Structure Pct." := 0;
            "JMC Catering Allocation" := 0;
            "JMC Industry Allocation" := 0;
            exit;
        end;
        "JMC Catering Structure Pct." := "JMC Catering Production Cost" / jmcProductionCost * 100;
        "JMC Industry Structure Pct." := 100 - "JMC Catering Structure Pct.";
        "JMC Catering Allocation" := Round("JMC Total Structure Cost" * "JMC Catering Structure Pct." / 100, jmcGLSetup."Amount Rounding Precision");
        "JMC Industry Allocation" := Round("JMC Total Structure Cost", jmcGLSetup."Amount Rounding Precision") - "JMC Catering Allocation";
    end;
}
