tableextension 53119 "JMC Lineas Evento" extends "Lineas Evento"
{
    fields
    {
        modify(ImprCapitulo)
        {
            trigger OnAfterValidate()
            begin
                if ImprCapitulo = 'NIÑOS' then
                    Validate(Tipo, Tipo::Niño);
            end;
        }
    }
}