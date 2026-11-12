page 53109 "JMC Cost Model Card"
{
    Caption = 'Cost Model', Comment = 'ESP="Modelo de costes"';
    PageType = Document;
    SourceTable = "JMC Cost Model";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("JMC Code"; Rec."JMC Code")
                {
                    ApplicationArea = All;
                }
                field("JMC Description"; Rec."JMC Description")
                {
                    ApplicationArea = All;
                }
            }
            group(Structure)
            {
                Caption = 'Structure Allocation', Comment = 'ESP="Reparto de estructura"';

                field("JMC Total Structure Cost"; Rec."JMC Total Structure Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Catering Structure Pct."; Rec."JMC Catering Structure Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC Industry Structure Pct."; Rec."JMC Industry Structure Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC Catering Allocation"; Rec."JMC Catering Allocation")
                {
                    ApplicationArea = All;
                }
                field("JMC Industry Allocation"; Rec."JMC Industry Allocation")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "JMC Cost Model Lines")
            {
                ApplicationArea = All;
                SubPageLink = "JMC Model Code" = field("JMC Code");
            }
        }
    }
}
