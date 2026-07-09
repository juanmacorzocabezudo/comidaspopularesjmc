query 53101 "JMC Event with Resources"
{
    Caption = 'Eventos con Recursos';
    QueryType = API;
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';
    APIVersion = 'v1.0';
    EntityName = 'eventWithResource';
    EntitySetName = 'eventsWithResources';

    elements
    {
        dataitem(Evento; Evento)
        {
            column(Codigo_Evento; "Codigo Evento")
            {
                Caption = 'Código Evento';
            }
            column(Estado; Estado)
            {
                Caption = 'Estado';
            }
            column(Descripcion; Descripcion)
            {
                Caption = 'Descripción';
            }
            column(Fecha_Evento; "Fecha Evento")
            {
                Caption = 'Fecha Evento';
            }
            column(Hora_Evento; "Hora Evento")
            {
                Caption = 'Hora Evento';
            }
            dataitem(Recursos_Evento; "Recursos Evento")
            {
                DataItemLink = "Codigo Evento" = Evento."Codigo Evento";
                SqlJoinType = LeftOuterJoin;

                column(Codigo_Recurso; "Codigo Recurso")
                {
                    Caption = 'Código Recurso';
                }
                column(Descripcion_Recurso; Descripcion)
                {
                    Caption = 'Descripción Recurso';
                }
                column(Tipo_Recurso; "Tipo Recurso")
                {
                    Caption = 'Tipo Recurso';
                }
                column(Cantidad; Cantidad)
                {
                    Caption = 'Cantidad';
                }
            }
        }
    }
}
