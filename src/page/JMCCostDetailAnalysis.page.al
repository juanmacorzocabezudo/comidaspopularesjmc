page 53129 "JMC Cost Detail Analysis"
{
    Caption = 'Saved Breakdown Lines', Comment = 'ESP="Líneas del desglose guardado"';
    PageType = List;
    AnalysisModeEnabled = true;
    SourceTable = "JMC Cost Calculation Detail";
    SourceTableTemporary = true;
    DataCaptionExpression = JMCMetricCaption;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(JMCDetails)
            {
                field("JMC Detail Type"; Rec."JMC Detail Type") { ApplicationArea = All; }
                field("JMC Source Entry No."; Rec."JMC Source Entry No.") { ApplicationArea = All; }
                field("JMC Posting Date"; Rec."JMC Posting Date") { ApplicationArea = All; }
                field("JMC Document No."; Rec."JMC Document No.") { ApplicationArea = All; }
                field("JMC Account No."; Rec."JMC Account No.") { ApplicationArea = All; }
                field("JMC Item No."; Rec."JMC Item No.") { ApplicationArea = All; }
                field("JMC Description"; Rec."JMC Description") { ApplicationArea = All; }
                field("JMC Classification"; Rec."JMC Classification") { ApplicationArea = All; }
                field("JMC Unit Code"; Rec."JMC Unit Code") { ApplicationArea = All; }
                field("JMC Quantity"; Rec."JMC Quantity") { ApplicationArea = All; }
                field("JMC Base Quantity"; Rec."JMC Base Quantity") { ApplicationArea = All; Visible = JMCAllocation; }
                field("JMC Base Recipe Cost"; Rec."JMC Base Recipe Cost") { ApplicationArea = All; Visible = false; }
                field("JMC Included"; Rec."JMC Included") { ApplicationArea = All; }
                field("JMC Source Amount"; Rec."JMC Source Amount") { ApplicationArea = All; }
                field("JMC Formula"; Rec."JMC Formula") { ApplicationArea = All; }
                field("JMC Operand A"; Rec."JMC Operand A") { ApplicationArea = All; }
                field("JMC Operand B"; Rec."JMC Operand B") { ApplicationArea = All; }
                field("JMC Operand C"; Rec."JMC Operand C") { ApplicationArea = All; }
                field("JMC Result"; Rec."JMC Result") { ApplicationArea = All; }
                field("JMC Issue"; Rec."JMC Issue") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    var
        jmcOpenFromDetailErr: Label 'Open this list using Analyze Lines from a saved calculation breakdown.', Comment = 'ESP="Abra esta lista con Analizar líneas desde un desglose guardado del cálculo."';
    begin
        if not JMCInitialized then
            Error(jmcOpenFromDetailErr);
    end;

    procedure SetLines(var jmcDetails: Record "JMC Cost Calculation Detail" temporary; jmcMetric: Text; jmcShowAllocation: Boolean)
    begin
        Rec.Copy(jmcDetails, true);
        JMCMetricCaption := jmcMetric;
        JMCAllocation := jmcShowAllocation;
        JMCInitialized := true;
    end;

    var
        JMCMetricCaption: Text;
        JMCAllocation: Boolean;
        JMCInitialized: Boolean;
}
