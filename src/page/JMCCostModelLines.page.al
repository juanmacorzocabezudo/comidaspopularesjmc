page 53124 "JMC Cost Model Lines"
{
    Caption = 'Products', Comment = 'ESP="Productos"';
    PageType = ListPart;
    SourceTable = "JMC Cost Model Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("JMC Allocation Method"; Rec."JMC Allocation Method")
                {
                    ApplicationArea = All;
                }
                field("JMC Item No."; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                }
                field("JMC Item Description"; Rec."JMC Item Description")
                {
                    ApplicationArea = All;
                }
                field("JMC Recipe BOM Cost"; Rec."JMC Recipe BOM Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Unit of Measure Code"; Rec."JMC Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("JMC Cost Value Type"; Rec."JMC Cost Value Type")
                {
                    ApplicationArea = All;
                }
                field("JMC Priority Level"; Rec."JMC Priority Level")
                {
                    ApplicationArea = All;
                }
                field("JMC Industrial Cost"; Rec."JMC Industrial Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Industrial Cost Pct."; Rec."JMC Industrial Cost Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC Management Cost"; Rec."JMC Management Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Management Cost Pct."; Rec."JMC Management Cost Pct.")
                {
                    ApplicationArea = All;
                }
                field("JMC EXWORK Standard"; Rec."JMC EXWORK Standard")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
