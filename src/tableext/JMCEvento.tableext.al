tableextension 53100 "JMC Evento" extends Evento
{
    fields
    {
        field(53100; "JMC Event Variety Description"; Text[50])
        {
            Caption = 'Event Variety Description', Comment = 'ESP="Descripción Variedad Evento"';
            FieldClass = FlowField;
            CalcFormula = lookup("Variedad de Evento".Descripcion where(Codigo = field("Variedad Evento")));
            Editable = false;
        }
        field(53101; "JMC Estado Semaforo"; Integer)
        {
            Caption = 'Status Semaphore', Comment = 'ESP="Estado Semáforo"';
            Editable = false;
        }
    }

    procedure GetEstadoSemaforo(): Integer
    begin
        // Estado es un Option: Presupuesto=0, Aceptado=1, Rechazado=2, Anulado=3, Realizado=4, Archivado=5, EnProceso=6
        case Rec.Estado of
            0: // Presupuesto
                exit(0);
            1: // Aceptado
                exit(1);
            3: // Anulado
                exit(2);
            else
                exit(-1);
        end;
    end;
    /*
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

    procedure JMCChangeStatus()
    var
        StatusOptions: Text;
        SelectedStatus: Integer;
        QuestionLbl: Label 'Select the new status:', Comment = 'ESP="Seleccione el nuevo estado:"';
        SuccessLbl: Label 'Status changed successfully.', Comment = 'ESP="Estado cambiado correctamente."';
    begin
        // Build status options without "Archivado"
        StatusOptions := Format(Rec.Estado::Presupuesto) + ',' +
                         Format(Rec.Estado::Aceptado) + ',' +
                         Format(Rec.Estado::Rechazado) + ',' +
                         Format(Rec.Estado::Anulado) + ',' +
                         Format(Rec.Estado::Realizado);

        SelectedStatus := StrMenu(StatusOptions, 1, QuestionLbl);

        if SelectedStatus = 0 then
            exit;

        // Map selection to Estado enum (skipping Archivado)
        case SelectedStatus of
            1:
                Rec.Validate(Estado, Rec.Estado::Presupuesto);
            2:
                Rec.Validate(Estado, Rec.Estado::Aceptado);
            3:
                Rec.Validate(Estado, Rec.Estado::Rechazado);
            4:
                Rec.Validate(Estado, Rec.Estado::Anulado);
            5:
                Rec.Validate(Estado, Rec.Estado::Realizado);
        end;

        Rec.Modify(true);
        Message(SuccessLbl);
    end;*/
}
