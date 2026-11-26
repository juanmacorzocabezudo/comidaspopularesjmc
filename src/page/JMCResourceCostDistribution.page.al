page 53130 "JMC Resource Cost Distribution"
{
    Caption = 'Resource Cost Distribution', Comment = 'ESP="Distribución del coste de personal"';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Percentages)
            {
                Caption = 'Fixed Resource Personnel Cost', Comment = 'ESP="Coste fijo de personal"';

                field(JMCIndustryPercentage; JMCIndustryPercentage)
                {
                    Editable = false;
                    Caption = 'Industry %', Comment = 'ESP="% Alimentación"';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                    MinValue = 0;
                    MaxValue = 100;
                    ToolTip = 'Shows the Industry structure percentage used for fixed personnel cost.', Comment = 'ESP="Muestra el porcentaje de estructura de Alimentación utilizado para el coste fijo de personal."';
                }
                field(JMCCateringPercentage; JMCCateringPercentage)
                {
                    Editable = false;
                    Caption = 'Catering %', Comment = 'ESP="% Catering"';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                    MinValue = 0;
                    MaxValue = 100;
                    ToolTip = 'Shows the Catering structure percentage used for fixed personnel cost.', Comment = 'ESP="Muestra el porcentaje de estructura de Catering utilizado para el coste fijo de personal."';
                }
            }
        }
    }

    procedure SetPercentages(jmcIndustryPct: Decimal; jmcCateringPct: Decimal)
    begin
        JMCIndustryPercentage := jmcIndustryPct;
        JMCCateringPercentage := jmcCateringPct;
    end;

    procedure GetPercentages(var jmcIndustryPct: Decimal; var jmcCateringPct: Decimal)
    begin
        jmcIndustryPct := JMCIndustryPercentage;
        jmcCateringPct := JMCCateringPercentage;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        jmcInvalidPctErr: Label 'Industry and Catering percentages must add up to 100.', Comment = 'ESP="Los porcentajes de Alimentación y Catering deben sumar 100."';
    begin
        if CloseAction = Action::OK then
            if Round(JMCIndustryPercentage + JMCCateringPercentage, 0.01) <> 100 then
                Error(jmcInvalidPctErr);
        exit(true);
    end;

    var
        JMCIndustryPercentage: Decimal;
        JMCCateringPercentage: Decimal;
}
