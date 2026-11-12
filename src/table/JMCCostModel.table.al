table 53102 "JMC Cost Model"
{
    Caption = 'Cost Model', Comment = 'ESP="Modelo de costes"';
    DataClassification = CustomerContent;
    LookupPageId = "JMC Cost Models";
    DrillDownPageId = "JMC Cost Models";

    fields
    {
        field(1; "JMC Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            NotBlank = true;
            ToolTip = 'Specifies the manually assigned code of the cost model.', Comment = 'ESP="Especifica el código asignado manualmente al modelo de costes."';
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
            ToolTip = 'Specifies the total structure cost entered manually.', Comment = 'ESP="Especifica el gasto de estructura total introducido manualmente."';
        }
        field(11; "JMC Catering Structure Pct."; Decimal)
        {
            Caption = 'Catering Structure %', Comment = 'ESP="% estructura Catering"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the catering allocation percentage. No amounts are calculated automatically.', Comment = 'ESP="Especifica el porcentaje de reparto de Catering. No se calculan importes automáticamente."';
        }
        field(12; "JMC Industry Structure Pct."; Decimal)
        {
            Caption = 'Industry Structure %', Comment = 'ESP="% estructura Alimentación"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the industry allocation percentage entered manually.', Comment = 'ESP="Especifica el porcentaje de reparto de Alimentación introducido manualmente."';
        }
        field(13; "JMC Catering Allocation"; Decimal)
        {
            Caption = 'Catering Allocation', Comment = 'ESP="Reparto Catering"';
            AutoFormatType = 1;
            ToolTip = 'Specifies the structure cost allocated to catering manually.', Comment = 'ESP="Especifica el gasto de estructura asignado manualmente a Catering."';
        }
        field(14; "JMC Industry Allocation"; Decimal)
        {
            Caption = 'Industry Allocation', Comment = 'ESP="Reparto Alimentación"';
            AutoFormatType = 1;
            ToolTip = 'Specifies the structure cost allocated to industry manually.', Comment = 'ESP="Especifica el gasto de estructura asignado manualmente a Alimentación."';
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
    begin
        TestField("JMC Code");
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
}
