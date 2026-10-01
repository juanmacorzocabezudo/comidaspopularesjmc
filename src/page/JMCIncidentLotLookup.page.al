page 53103 "JMC Incident Lot Lookup"
{
    PageType = List;
    SourceTable = "Lot No. Information";
    SourceTableTemporary = true;
    Caption = 'Lots', Comment = 'ESP="Lotes"';
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Lots)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetLots(var TempLotNoInfo: Record "Lot No. Information" temporary)
    begin
        Rec.Copy(TempLotNoInfo, true);
    end;
}
