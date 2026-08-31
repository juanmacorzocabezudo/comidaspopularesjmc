report 53140 "JMC Update Catering Dates"
{
    Caption = 'Update Catering Resource Assignment Dates', Comment = 'ESP="Actualizar Fechas Asignación Recursos Catering"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(AsignacionRecursos; "Asignacion Recursos Eventos")
        {
            trigger OnAfterGetRecord()
            var
                EventoRec: Record Evento;
            begin
                TotalRecords += 1;

                // If JMC Fecha Evento is already filled, skip
                if AsignacionRecursos."JMC Fecha Evento" <> 0D then begin
                    SkippedRecords += 1;
                    exit;
                end;

                // Try to get date from Event
                if AsignacionRecursos."Codigo Evento" <> '' then begin
                    if EventoRec.Get(AsignacionRecursos."Codigo Evento") then begin
                        AsignacionRecursos."JMC Fecha Evento" := EventoRec."Fecha Evento";
                        AsignacionRecursos."JMC Hora Evento" := EventoRec."Hora Evento";

                        // Calculate date fields (Week, Day, Month, Year)
                        if AsignacionRecursos."JMC Fecha Evento" <> 0D then begin
                            AsignacionRecursos."JMC Week No." := Date2DWY(AsignacionRecursos."JMC Fecha Evento", 2);
                            AsignacionRecursos."JMC Day of Week" := GetSpanishDayName(AsignacionRecursos."JMC Fecha Evento");
                            AsignacionRecursos."JMC Month" := Date2DMY(AsignacionRecursos."JMC Fecha Evento", 2);
                            AsignacionRecursos."JMC Year" := Date2DMY(AsignacionRecursos."JMC Fecha Evento", 3);
                        end;

                        AsignacionRecursos.Modify(false);
                        UpdatedRecords += 1;
                    end else begin
                        // Event code exists but event not found
                        SkippedRecords += 1;
                    end;
                end else begin
                    // No event code
                    SkippedRecords += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message(StrSubstNo(CompletionMsg, TotalRecords, UpdatedRecords, SkippedRecords));
            end;
        }
    }

    var
        TotalRecords: Integer;
        UpdatedRecords: Integer;
        SkippedRecords: Integer;
        CompletionMsg: Label 'Process completed.\Total records: %1\Updated: %2\Skipped: %3', Comment = 'ESP="Proceso completado.\Total registros: %1\Actualizados: %2\Omitidos: %3"';

    local procedure GetSpanishDayName(DateValue: Date): Text[10]
    var
        DayOfWeek: Integer;
    begin
        DayOfWeek := Date2DWY(DateValue, 1);
        case DayOfWeek of
            1:
                exit('Lunes');
            2:
                exit('Martes');
            3:
                exit('Miércoles');
            4:
                exit('Jueves');
            5:
                exit('Viernes');
            6:
                exit('Sábado');
            7:
                exit('Domingo');
        end;
    end;
}
