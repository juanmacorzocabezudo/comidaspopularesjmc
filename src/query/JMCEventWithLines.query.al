query 53102 "JMC Event with Lines"
{
    Caption = 'Eventos con Líneas', Comment = 'ESP="Eventos con Líneas"';
    QueryType = API;
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';
    APIVersion = 'v1.0';
    EntityName = 'eventWithLine';
    EntitySetName = 'eventsWithLines';

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
            dataitem(Lineas_Evento; "Lineas Evento")
            {
                DataItemLink = "Codigo Evento" = Evento."Codigo Evento";
                SqlJoinType = LeftOuterJoin;

                column(Cantidad_LineasEvento; Cantidad)
                {
                    Caption = 'Cantidad';
                }
                column(Descripcion_LineasEvento; Descripcion)
                {
                    Caption = 'Descripción';
                }
                column(Comentarios_LineasEvento; Comentarios)
                {
                    Caption = 'Comentarios';
                }
            }
        }
    }
}
