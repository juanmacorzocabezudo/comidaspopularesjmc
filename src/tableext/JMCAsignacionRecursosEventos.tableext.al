tableextension 53130 "JMC Asignacion Recursos" extends "Asignacion Recursos Eventos"
{
    fields
    {
        modify("Codigo Evento")
        {
            trigger OnBeforeValidate()
            var
                EventoRec: Record Evento;
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                // Allow blank event code - skip validation
                if Rec."Codigo Evento" = '' then begin
                    // Clear Tipo when event is cleared
                    Clear(Rec."JMC Tipo");
                    exit;
                end;

                // If event code is provided but doesn't exist, allow it anyway
                if not EventoRec.Get(Rec."Codigo Evento") then
                    exit;

                // Copy date and time from event
                Rec."JMC Fecha Evento" := EventoRec."Fecha Evento";
                Rec."JMC Hora Evento" := EventoRec."Hora Evento";

                // Fill Tipo from Sales & Receivables Setup
                if SalesSetup.Get() then
                    Rec."JMC Tipo" := SalesSetup."JMC Event Type Res. Assign.";
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

            trigger OnValidate()
            begin
                UpdateDateFields();
            end;
        }
        field(53105; "JMC Hora Evento"; Time)
        {
            Caption = 'Event Time', Comment = 'ESP="Hora Evento"';
            DataClassification = CustomerContent;
        }
        field(53106; "JMC Tipo"; Code[100])
        {
            Caption = 'Tipo';
            DataClassification = CustomerContent;
            TableRelation = Tipo;
        }
        field(53107; "JMC Week No."; Integer)
        {
            Caption = 'Week No.', Comment = 'ESP="Nº Semana"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(53108; "JMC Day of Week"; Text[10])
        {
            Caption = 'Day of Week', Comment = 'ESP="Día de la Semana"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(53109; "JMC Month"; Integer)
        {
            Caption = 'Month', Comment = 'ESP="Mes"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(53110; "JMC Year"; Integer)
        {
            Caption = 'Year', Comment = 'ESP="Año"';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "JMC Fecha Evento", "JMC Hora Evento")
        {
        }
    }

    local procedure UpdateDateFields()
    begin
        if Rec."JMC Fecha Evento" <> 0D then begin
            Rec."JMC Week No." := Date2DWY(Rec."JMC Fecha Evento", 2);
            Rec."JMC Day of Week" := GetSpanishDayName(Rec."JMC Fecha Evento");
            Rec."JMC Month" := Date2DMY(Rec."JMC Fecha Evento", 2);
            Rec."JMC Year" := Date2DMY(Rec."JMC Fecha Evento", 3);
        end else begin
            Clear(Rec."JMC Week No.");
            Clear(Rec."JMC Day of Week");
            Clear(Rec."JMC Month");
            Clear(Rec."JMC Year");
        end;
    end;

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
