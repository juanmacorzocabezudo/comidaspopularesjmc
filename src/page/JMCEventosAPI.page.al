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
                field(timeSlot; Rec."Franja horaria")
                {
                    Caption = 'Time Slot', Comment = 'ESP="Franja horaria"';
                }
                field(customerCode; Rec."Codigo Cliente")
                {
                    Caption = 'Customer Code', Comment = 'ESP="Código Cliente"';
                }
                field(eventVariety; Rec."Variedad Evento")
                {
                    Caption = 'Event Variety', Comment = 'ESP="Variedad Evento"';
                }
                field(eventVarietyDescription; Rec."JMC Event Variety Description")
                {
                    Caption = 'Event Variety Description', Comment = 'ESP="Descripción Variedad Evento"';
                }
                field(contactPerson2; Rec."Persona de Contacto 2")
                {
                    Caption = 'Contact Person 2', Comment = 'ESP="Persona de Contacto 2"';
                }
                field(phone2; Rec."Telefono 2")
                {
                    Caption = 'Phone 2', Comment = 'ESP="Teléfono 2"';
                }
                field(email2; Rec."E-Mail 2")
                {
                    Caption = 'E-Mail 2', Comment = 'ESP="E-Mail 2"';
                }
                field(totalAdults; Rec."Total Adultos")
                {
                    Caption = 'Total Adults', Comment = 'ESP="Total Adultos"';
                }
                field(totalChildren; Rec."Total Ninos")
                {
                    Caption = 'Total Children', Comment = 'ESP="Total Niños"';
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
