page 53122 "JMC Purchase Order Reasons"
{
    Caption = 'Purchase Order Reasons', Comment = 'ESP="Motivos pedido compra"';
    PageType = List;
    SourceTable = "JMC Purchase Order Reason";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec."JMC Code")
                {
                    Caption = 'Code', Comment = 'ESP="Código"';
                    ApplicationArea = All;
                }
                field(Description; Rec."JMC Description")
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                    ApplicationArea = All;
                }
            }
        }
    }
}
