table 53104 "JMC Cost Priority Factor"
{
    Caption = 'Cost Priority Factor', Comment = 'ESP="Factor de prioridad de costes"';
    DataClassification = CustomerContent;
    LookupPageId = "JMC Cost Priority Factors";

    fields
    {
        field(1; "JMC Priority Level"; Integer)
        {
            Caption = 'Priority Level', Comment = 'ESP="Nivel de prioridad"';
            MinValue = 1;
            MaxValue = 5;
            ToolTip = 'Specifies the priority, from 1 (highest) to 5 (lowest).', Comment = 'ESP="Especifica la prioridad, de 1 (mayor) a 5 (menor)."';
        }
        field(2; "JMC Factor"; Decimal)
        {
            Caption = 'Factor', Comment = 'ESP="Factor"';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the approved positive weight. Factors must decrease as the priority number increases. No values are assigned automatically.', Comment = 'ESP="Especifica el peso positivo aprobado. Los factores deben disminuir al aumentar el número de prioridad. No se asignan valores automáticamente."';
        }
    }

    keys
    {
        key(PK; "JMC Priority Level")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CheckFactor();
        InvalidateCalculation();
    end;

    trigger OnModify()
    begin
        CheckFactor();
        InvalidateCalculation();
    end;

    trigger OnDelete()
    begin
        InvalidateCalculation();
    end;

    trigger OnRename()
    var
        jmcRenameErr: Label 'Delete and recreate the priority factor instead of renaming it.', Comment = 'ESP="Elimine y vuelva a crear el factor de prioridad en lugar de cambiar su nivel."';
    begin
        Error(jmcRenameErr);
    end;

    local procedure CheckFactor()
    var
        jmcOtherFactor: Record "JMC Cost Priority Factor";
        jmcInvalidFactorErr: Label 'Use priorities 1 to 5 and positive, strictly decreasing factors.', Comment = 'ESP="Utilice prioridades del 1 al 5 y factores positivos estrictamente decrecientes."';
    begin
        if ("JMC Priority Level" < 1) or ("JMC Priority Level" > 5) or ("JMC Factor" <= 0) then
            Error(jmcInvalidFactorErr);
        jmcOtherFactor.LockTable();
        if jmcOtherFactor.FindSet() then
            repeat
                if ((jmcOtherFactor."JMC Priority Level" < "JMC Priority Level") and (jmcOtherFactor."JMC Factor" <= "JMC Factor")) or
                   ((jmcOtherFactor."JMC Priority Level" > "JMC Priority Level") and (jmcOtherFactor."JMC Factor" >= "JMC Factor"))
                then
                    Error(jmcInvalidFactorErr);
            until jmcOtherFactor.Next() = 0;
    end;

    local procedure InvalidateCalculation()
    var
        jmcCostModel: Record "JMC Cost Model";
    begin
        jmcCostModel.SetRange("JMC Calculation Current", true);
        if jmcCostModel.FindSet(true) then
            repeat
                jmcCostModel."JMC Calculation Current" := false;
                jmcCostModel.Modify(false);
            until jmcCostModel.Next() = 0;
    end;
}
