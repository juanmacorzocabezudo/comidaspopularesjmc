page 53121 "JMC Families"
{
    Caption = 'Families', Comment = 'ESP="Familias"';
    PageType = List;
    SourceTable = "JMC Family";
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
