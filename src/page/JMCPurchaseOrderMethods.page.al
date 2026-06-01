page 53123 "JMC Purchase Order Methods"
{
    Caption = 'Purchase Order Methods', Comment = 'ESP="Formas pedido"';
    PageType = List;
    SourceTable = "JMC Purchase Order Method";
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
