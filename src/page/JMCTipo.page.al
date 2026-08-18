page 53132 "JMC Tipo"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Tipo;
    Caption = 'Tipo', Comment = 'ESP="Tipo"';
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Codigo; Rec.Codigo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code.', Comment = 'ESP="Especifica el código."';
                }
                field(Descripcion; Rec.Descripcion)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.', Comment = 'ESP="Especifica la descripción."';
                }
            }
        }
    }
}
