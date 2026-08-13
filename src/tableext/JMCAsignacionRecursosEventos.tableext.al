tableextension 53130 "JMC Asignacion Recursos" extends "Asignacion Recursos Eventos"
{
    fields
    {
        modify("Codigo Evento")
        {
            trigger OnBeforeValidate()
            var
                EventoRec: Record Evento;
            begin
                // Allow blank event code - skip validation
                if Rec."Codigo Evento" = '' then
                    exit;

                // If event code is provided but doesn't exist, allow it anyway
                if not EventoRec.Get(Rec."Codigo Evento") then
                    exit;

                // Copy date and time from event
                Rec."JMC Fecha Evento" := EventoRec."Fecha Evento";
                Rec."JMC Hora Evento" := EventoRec."Hora Evento";
            end;
        }
        field(53100; "JMC Event Date"; Date)
        {
            Caption = 'Event Date', Comment = 'ESP="Fecha Evento"';
            FieldClass = FlowField;
            CalcFormula = lookup(Evento."Fecha Evento" where("Codigo Evento" = field("Codigo Evento")));
            Editable = false;
        }
        field(53101; "JMC Event Time"; Time)
        {
            Caption = 'Event Time', Comment = 'ESP="Hora Evento"';
            FieldClass = FlowField;
            CalcFormula = lookup(Evento."Hora Evento" where("Codigo Evento" = field("Codigo Evento")));
            Editable = false;
        }
        field(53102; "JMC Event Description"; Text[2048])
        {
            Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
            FieldClass = FlowField;
            CalcFormula = lookup(Evento.Descripcion where("Codigo Evento" = field("Codigo Evento")));
            Editable = false;
        }
        field(53103; "JMC Business Line"; Enum "JMC Business Line")
        {
            Caption = 'Business Line', Comment = 'ESP="Línea de Negocio"';
            DataClassification = CustomerContent;
        }
        field(53104; "JMC Fecha Evento"; Date)
        {
            Caption = 'Event Date', Comment = 'ESP="Fecha Evento"';
            DataClassification = CustomerContent;
        }
        field(53105; "JMC Hora Evento"; Time)
        {
            Caption = 'Event Time', Comment = 'ESP="Hora Evento"';
            DataClassification = CustomerContent;
        }
    }
}
