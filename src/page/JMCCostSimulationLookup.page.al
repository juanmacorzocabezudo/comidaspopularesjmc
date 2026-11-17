page 53127 "JMC Cost Simulation Lookup"
{
    Caption = 'Saved Products and Units', Comment = 'ESP="Productos y unidades guardados"';
    PageType = List;
    SourceTable = "JMC Cost Model Line";
    SourceTableTemporary = true;
    SourceTableView = sorting("JMC Model Code", "JMC Item No.", "JMC Unit of Measure Code", "JMC Allocation Method");
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field("JMC Unit of Measure Code"; Rec."JMC Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetLines(var jmcLines: Record "JMC Cost Model Line" temporary)
    begin
        Rec.Copy(jmcLines, true);
    end;
}
