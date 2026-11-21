page 53108 "JMC Cost Priority Factors"
{
    Caption = 'Cost Priority Factors', Comment = 'ESP="Factores de prioridad de costes"';
    PageType = Worksheet;
    SourceTable = "JMC Cost Priority Factor";
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Factors)
            {
                field("JMC Priority Level"; Rec."JMC Priority Level")
                {
                    ApplicationArea = All;
                }
                field("JMC Allocation Pct."; Rec."JMC Allocation Pct.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RestoreDefaults)
            {
                Caption = 'Restore Default Percentages', Comment = 'ESP="Restaurar porcentajes predeterminados"';
                ToolTip = 'Sets priority 1 to 100 percent, 2 to 80 percent, 3 to 60 percent, 4 to 40 percent and 5 to 20 percent. The cost model must be calculated again to use them.', Comment = 'ESP="Establece la prioridad 1 al 100 %, la 2 al 80 %, la 3 al 60 %, la 4 al 40 % y la 5 al 20 %. Debe calcular de nuevo el modelo de costes para utilizarlos."';
                ApplicationArea = All;
                Image = Restore;

                trigger OnAction()
                var
                    jmcInstall: Codeunit "JMC Cost Priority Install";
                    jmcConfirmLbl: Label 'Replace the percentages of all five priorities with 100, 80, 60, 40 and 20 percent?', Comment = 'ESP="¿Sustituir los porcentajes de las cinco prioridades por el 100, 80, 60, 40 y 20 %?"';
                begin
                    if not Confirm(jmcConfirmLbl, false) then
                        exit;
                    jmcInstall.RestoreDefaultPercentages();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(RestoreDefaultsPromoted; RestoreDefaults)
            {
            }
        }
    }
}
