report 53141 "JMC Update Industry Dates"
{
    Caption = 'Update Industry Resource Assignment Dates', Comment = 'ESP="Actualizar Fechas Asignación Recursos Industria"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(ResourceAssignment; "JMC Resource Assignment")
        {
            trigger OnAfterGetRecord()
            var
                EventoRec: Record Evento;
            begin
                TotalRecords += 1;

                // If date fields are already calculated, skip
                if (ResourceAssignment."JMC Week No." <> 0) or (ResourceAssignment."JMC Day of Week" <> '') then begin
                    SkippedRecords += 1;
                    exit;
                end;

                // If Event Date is already filled, calculate date fields
                if ResourceAssignment."Event Date" <> 0D then begin
                    ResourceAssignment."JMC Week No." := Date2DWY(ResourceAssignment."Event Date", 2);
                    ResourceAssignment."JMC Day of Week" := GetSpanishDayName(ResourceAssignment."Event Date");
                    ResourceAssignment."JMC Month" := Date2DMY(ResourceAssignment."Event Date", 2);
                    ResourceAssignment."JMC Year" := Date2DMY(ResourceAssignment."Event Date", 3);
                    ResourceAssignment.Modify(false);
                    UpdatedRecords += 1;
                    exit;
                end;

                // If Event Date is not filled, try to get it from Event
                if ResourceAssignment."Event Code" <> '' then begin
                    if EventoRec.Get(ResourceAssignment."Event Code") then begin
                        ResourceAssignment."Event Date" := EventoRec."Fecha Evento";
                        ResourceAssignment."Event Time" := EventoRec."Hora Evento";

                        // Calculate date fields (Week, Day, Month, Year)
                        if ResourceAssignment."Event Date" <> 0D then begin
                            ResourceAssignment."JMC Week No." := Date2DWY(ResourceAssignment."Event Date", 2);
                            ResourceAssignment."JMC Day of Week" := GetSpanishDayName(ResourceAssignment."Event Date");
                            ResourceAssignment."JMC Month" := Date2DMY(ResourceAssignment."Event Date", 2);
                            ResourceAssignment."JMC Year" := Date2DMY(ResourceAssignment."Event Date", 3);
                        end;

                        ResourceAssignment.Modify(false);
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
