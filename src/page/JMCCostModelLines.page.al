page 53124 "JMC Cost Model Lines"
{
    Caption = 'Products', Comment = 'ESP="Productos"';
    PageType = ListPart;
    SourceTable = "JMC Cost Model Line";
    SourceTableView = sorting("JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method");
    DelayedInsert = true;
    MultipleNewLines = true;
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("JMC Item No."; Rec."JMC Item No.")
                {
                    ApplicationArea = All;
                }
                field("JMC Item Description"; Rec."JMC Item Description")
                {
                    ApplicationArea = All;
                }
                field("JMC Allocation Eligible"; Rec."JMC Allocation Eligible")
                {
                    ApplicationArea = All;
                }
                field("JMC Calculation Issue"; Rec."JMC Calculation Issue")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = Rec."JMC Calculation Issue" <> '';
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

                    trigger OnValidate()
                    begin
                        jmcAmountEditable := Rec."JMC Cost Value Type" = Rec."JMC Cost Value Type"::Amount;
                        CurrPage.Update(false);
                    end;
                }
                field("JMC Priority Level"; Rec."JMC Priority Level")
                {
                    ApplicationArea = All;
                }
                field("JMC Industrial Cost"; Rec."JMC Industrial Cost")
                {
                    ApplicationArea = All;
                    Editable = jmcAmountEditable;
                }
                field("JMC Industrial Cost Pct."; Rec."JMC Industrial Cost Pct.")
                {
                    ApplicationArea = All;
                    Editable = not jmcAmountEditable;
                }
                field("JMC Management Cost"; Rec."JMC Management Cost")
                {
                    ApplicationArea = All;
                    Editable = jmcAmountEditable;
                }
                field("JMC Management Cost Pct."; Rec."JMC Management Cost Pct.")
                {
                    ApplicationArea = All;
                    Editable = not jmcAmountEditable;
                }
                field("JMC EXWORK Standard"; Rec."JMC EXWORK Standard")
                {
                    ApplicationArea = All;
                }
                field("JMC Net Sales Quantity"; Rec."JMC Net Sales Quantity")
                {
                    ApplicationArea = All;
                }
                field("JMC Net Sales Base Qty."; Rec."JMC Net Sales Base Qty.")
                {
                    ApplicationArea = All;
                }
                field("JMC Applied Priority Factor"; Rec."JMC Applied Priority Factor")
                {
                    ApplicationArea = All;
                }
                field("JMC Assigned Industrial Cost"; Rec."JMC Assigned Industrial Cost")
                {
                    ApplicationArea = All;
                }
                field("JMC Assigned Management Cost"; Rec."JMC Assigned Management Cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        jmcAmountEditable := Rec."JMC Cost Value Type" = Rec."JMC Cost Value Type"::Amount;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        jmcAmountEditable := Rec."JMC Cost Value Type" = Rec."JMC Cost Value Type"::Amount;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."JMC Line No." := 0;
        jmcAmountEditable := Rec."JMC Cost Value Type" = Rec."JMC Cost Value Type"::Amount;
    end;

    var
        jmcAmountEditable: Boolean;
}
