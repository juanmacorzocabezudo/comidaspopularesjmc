page 53120 "JMC Business Lines"
{
    Caption = 'Business Lines', Comment = 'ESP="Lineas de negocio"';
    PageType = List;
    SourceTable = "JMC Business Line";
    ApplicationArea = All;
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
