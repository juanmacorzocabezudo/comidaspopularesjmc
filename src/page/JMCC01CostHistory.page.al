page 53137 "JMC C01 Cost History"
{
    Caption = 'Structure Cost History', Comment = 'ESP="Histórico costes de estructura"';
    PageType = List;
    SourceTable = "JMC C01 Cost History";
    SourceTableView = sorting("JMC Entry No.") order(descending);
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(History)
            {
                field("JMC Entry No."; Rec."JMC Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Item No."; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Cost Value"; Rec."JMC Cost Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Cost Type"; Rec."JMC Cost Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Base Unit"; Rec."JMC Base Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Cost Fixed"; Rec."JMC Cost Fixed")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
                field("JMC Applied At"; Rec."JMC Applied At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Applied By"; Rec."JMC Applied By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Model Code"; Rec."JMC Model Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Starting Date"; Rec."JMC Starting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Ending Date"; Rec."JMC Ending Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Fixed At"; Rec."JMC Fixed At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("JMC Fixed By"; Rec."JMC Fixed By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
