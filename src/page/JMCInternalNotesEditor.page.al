page 53113 "JMC Internal Notes Editor"
{
    PageType = Card;
    Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
    SourceTable = "Purchase Line";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("JMC Internal Notes"; Rec."JMC Internal Notes")
                {
                    ApplicationArea = All;
                    Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
                    MultiLine = true;
                    ToolTip = 'Specifies internal notes for the purchase order line.', Comment = 'ESP="Especifica observaciones internas para la línea del pedido de compra."';
                }
            }
        }
    }
}
