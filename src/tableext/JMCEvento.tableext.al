tableextension 53100 "JMC Evento" extends Evento
{
    fields
    {
        modify(Estado)
        {
            trigger OnBeforeValidate()
            var
                ErrorLbl: Label 'Changing the status to Archived is not allowed', Comment = 'ESP="No se permite cambiar el estado a Archivado"';
            begin
                if Rec.Estado = Rec.Estado::Archivado then
                    Error(ErrorLbl);
            end;
        }
    }
}
