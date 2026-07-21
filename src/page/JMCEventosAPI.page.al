page 53114 "JMC Eventos API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Event', Comment = 'ESP="Evento"';
    EntitySetCaption = 'Events', Comment = 'ESP="Eventos"';
    EntityName = 'event';
    EntitySetName = 'events';

    PageType = API;
    SourceTable = Evento;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id', Comment = 'ESP="Id"';
                    Editable = false;
                }
                field(eventCode; Rec."Codigo Evento")
                {
                    Caption = 'Event Code', Comment = 'ESP="Código Evento"';
                }
                field(description; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(status; Rec.Estado)
                {
                    Caption = 'Status', Comment = 'ESP="Estado"';
                }
                field(eventDate; Rec."Fecha Evento")
                {
                    Caption = 'Event Date', Comment = 'ESP="Fecha Evento"';
                }
                field(eventTime; Rec."Hora Evento")
                {
                    Caption = 'Event Time', Comment = 'ESP="Hora Evento"';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time', Comment = 'ESP="Fecha/hora última modificación"';
                    Editable = false;
                }
            }
        }
    }
}
