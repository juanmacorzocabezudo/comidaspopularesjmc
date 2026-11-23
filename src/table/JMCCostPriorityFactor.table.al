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
            ToolTip = 'Specifies the priority, from 1 (highest) to 5 (lowest). It matches the priority set on the item card.', Comment = 'ESP="Especifica la prioridad, de 1 (mayor) a 5 (menor). Coincide con la prioridad indicada en la ficha del producto."';
        }
        field(2; "JMC Factor"; Decimal)
        {
            Caption = 'Factor', Comment = 'ESP="Factor"';
            DecimalPlaces = 2 : 2;
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by the allocation percentage.';
            ObsoleteTag = '27.5.0.50';
        }
        field(3; "JMC Allocation Pct."; Decimal)
        {
            Caption = 'Allocation %', Comment = 'ESP="% de reparto"';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the percentage of cost allocation that products with this priority receive compared with priority 1. For example, 80 means that the product receives 80 percent of the share it would receive at 100 percent. Percentages must decrease as the priority number increases.', Comment = 'ESP="Especifica el porcentaje de reparto de costes que reciben los productos con esta prioridad respecto a la prioridad 1. Por ejemplo, 80 significa que el producto recibe el 80 % de la parte que recibiría con el 100 %. Los porcentajes deben disminuir al aumentar el número de prioridad."';
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
    end;

    trigger OnModify()
    begin
        CheckFactor();
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
        jmcInvalidFactorErr: Label 'Use priorities 1 to 5 and percentages above 0 and up to 100 that decrease as the priority number increases.', Comment = 'ESP="Utilice prioridades del 1 al 5 y porcentajes mayores que 0 y hasta 100 que disminuyan al aumentar el número de prioridad."';
    begin
        if ("JMC Priority Level" < 1) or ("JMC Priority Level" > 5) or ("JMC Allocation Pct." <= 0) or ("JMC Allocation Pct." > 100) then
            Error(jmcInvalidFactorErr);
        jmcOtherFactor.LockTable();
        jmcOtherFactor.SetFilter("JMC Allocation Pct.", '>0');
        jmcOtherFactor.SetFilter("JMC Priority Level", '<>%1', "JMC Priority Level");
        if jmcOtherFactor.FindSet() then
            repeat
                if ((jmcOtherFactor."JMC Priority Level" < "JMC Priority Level") and (jmcOtherFactor."JMC Allocation Pct." <= "JMC Allocation Pct.")) or
                   ((jmcOtherFactor."JMC Priority Level" > "JMC Priority Level") and (jmcOtherFactor."JMC Allocation Pct." >= "JMC Allocation Pct."))
                then
                    Error(jmcInvalidFactorErr);
            until jmcOtherFactor.Next() = 0;
    end;

    procedure InvalidateCalculation()
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
