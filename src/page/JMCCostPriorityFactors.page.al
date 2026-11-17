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
                field("JMC Factor"; Rec."JMC Factor")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
