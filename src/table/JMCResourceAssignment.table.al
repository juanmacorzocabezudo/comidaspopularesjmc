table 53116 "JMC Resource Assignment"
{
    DataClassification = CustomerContent;
    Caption = 'Resource Assignment', Comment = 'ESP="Asignación de Recursos"';
    TableType = Normal;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº Mov."';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Source Table"; Option)
        {
            Caption = 'Source Table', Comment = 'ESP="Tabla Origen"';
            OptionMembers = "Catering","Industry";
            OptionCaption = 'Catering,Industry', Comment = 'ESP="Catering,Industria"';
            DataClassification = CustomerContent;
        }
        field(10; "Event Code"; Code[20])
        {
            Caption = 'Event Code', Comment = 'ESP="Código Evento"';
            TableRelation = Evento;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EventRec: Record Evento;
            begin
                if "Event Code" <> '' then begin
                    if EventRec.Get("Event Code") then begin
                        // Copy date and time from event
                        "Event Date" := EventRec."Fecha Evento";
                        "Event Time" := EventRec."Hora Evento";
                        CalcFields("Event Description");
                    end;
                end else begin
                    Clear("Event Date");
                    Clear("Event Time");
                    Clear("Event Description");
                end;
            end;
        }
        field(11; "Event Date"; Date)
        {
            Caption = 'Event Date', Comment = 'ESP="Fecha Evento"';
            DataClassification = CustomerContent;
        }
        field(12; "Event Time"; Time)
        {
            Caption = 'Event Time', Comment = 'ESP="Hora Evento"';
            DataClassification = CustomerContent;
        }
        field(13; "Event Description"; Text[2048])
        {
            Caption = 'Event Description', Comment = 'ESP="Descripción Evento"';
            FieldClass = FlowField;
            CalcFormula = lookup(Evento.Descripcion where("Codigo Evento" = field("Event Code")));
            Editable = false;
        }
        field(20; "Event Resource Line No."; Integer)
        {
            Caption = 'Event Resource Line No.', Comment = 'ESP="Nº Línea Recurso Evento"';
            TableRelation = "Recursos Evento".Linea where("Codigo Evento" = field("Event Code"));
            DataClassification = CustomerContent;
        }
        field(30; "Resource Code"; Code[20])
        {
            Caption = 'Resource Code', Comment = 'ESP="Código Recurso"';
            TableRelation = Resource;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ResourceRec: Record Resource;
            begin
                if "Resource Code" <> '' then begin
                    ResourceRec.Get("Resource Code");
                    "Unit of Measure" := ResourceRec."Base Unit of Measure";
                    "Unit Cost" := ResourceRec."Unit Cost";
                    Description := ResourceRec.Name;
                end else begin
                    Description := '';
                    "Unit of Measure" := '';
                    "Unit Cost" := 0;
                end;
            end;
        }
        field(31; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(41; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure', Comment = 'ESP="Unidad de Medida"';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(42; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
            DataClassification = CustomerContent;
        }
        field(50; "Task Performed"; Code[10])
        {
            Caption = 'Task Performed', Comment = 'ESP="Tarea Realizada"';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(51; Comments; Text[250])
        {
            Caption = 'Comments', Comment = 'ESP="Comentarios"';
            DataClassification = CustomerContent;
        }
        field(60; "Business Line"; Enum "JMC Business Line")
        {
            Caption = 'Business Line', Comment = 'ESP="Línea de Negocio"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Event Code", "Resource Code")
        {
        }
        key(Key3; "Business Line", "Event Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Event Code", "Resource Code", Description)
        {
        }
    }
}
