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
                    Caption = 'Industry %', Comment = 'ESP="% Alimentación"';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                    MinValue = 0;
                    MaxValue = 100;
                    ToolTip = 'Specifies the percentage allocated to Industry. The Catering percentage is the remainder needed to total 100.', Comment = 'ESP="Especifica el porcentaje asignado a Alimentación. El porcentaje de Catering será el restante hasta sumar 100."';
                }
                field(JMCCateringPercentage; JMCCateringPercentage)
                {
                    Caption = 'Catering %', Comment = 'ESP="% Catering"';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                    MinValue = 0;
                    MaxValue = 100;
                    ToolTip = 'Specifies the percentage allocated to Catering. The Industry percentage is the remainder needed to total 100.', Comment = 'ESP="Especifica el porcentaje asignado a Catering. El porcentaje de Alimentación será el restante hasta sumar 100."';
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
