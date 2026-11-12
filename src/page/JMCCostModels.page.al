page 53108 "JMC Cost Models"
{
    Caption = 'Cost Models', Comment = 'ESP="Modelos de costes"';
    PageType = List;
    SourceTable = "JMC Cost Model";
    CardPageId = "JMC Cost Model Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Models)
            {
                field("JMC Code"; Rec."JMC Code")
                {
                    ApplicationArea = All;
                }
                field("JMC Description"; Rec."JMC Description")
                {
                    ApplicationArea = All;
                }
                field("JMC Total Structure Cost"; Rec."JMC Total Structure Cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
