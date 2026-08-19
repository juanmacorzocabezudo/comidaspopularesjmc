pageextension 53136 "JMC Asignacion Recursos Pag" extends "Asignacion Recursos Evento"
{
    layout
    {
        addafter(Descripcion)
        {
            field("JMC Tipo"; Rec."JMC Tipo")
            {
                ApplicationArea = All;
                Caption = 'Tipo';
                ToolTip = 'Specifies the type.', Comment = 'ESP="Especifica el tipo."';
            }
        }
    }
}
