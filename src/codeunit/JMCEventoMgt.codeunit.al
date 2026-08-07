codeunit 53101 "JMC Evento Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::Evento, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvento(var Rec: Record Evento; RunTrigger: Boolean)
    begin
        UpdateEstadoSemaforo(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Evento, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvento(var Rec: Record Evento; var xRec: Record Evento; RunTrigger: Boolean)
    begin
        if Rec.Estado <> xRec.Estado then
            UpdateEstadoSemaforo(Rec);
    end;

    local procedure UpdateEstadoSemaforo(var RecEvento: Record Evento)
    var
        EstadoSemaforo: Integer;
    begin
        // Estado es un Option: Presupuesto=0, Aceptado=1, Rechazado=2, Anulado=3, Realizado=4, Archivado=5, EnProceso=6
        case RecEvento.Estado of
            0: // Presupuesto
                EstadoSemaforo := 0;
            1: // Aceptado
                EstadoSemaforo := 1;
            3: // Anulado
                EstadoSemaforo := 2;
            else
                EstadoSemaforo := -1;
        end;

        if RecEvento."JMC Estado Semaforo" <> EstadoSemaforo then begin
            RecEvento."JMC Estado Semaforo" := EstadoSemaforo;
            RecEvento.Modify();
        end;
    end;
}
