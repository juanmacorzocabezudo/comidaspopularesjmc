page 53102 "JMC Asignacion Recursos API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Event Resource Assignment', Comment = 'ESP="Asignación Recursos Evento"';
    EntitySetCaption = 'Event Resource Assignments', Comment = 'ESP="Asignaciones Recursos Evento"';
    EntityName = 'eventResourceAssignment';
    EntitySetName = 'eventResourceAssignments';

    PageType = API;
    SourceTable = "Asignacion Recursos Eventos";
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
                field(codigoEvento; Rec."Codigo Evento")
                {
                    Caption = 'Event Code', Comment = 'ESP="Código Evento"';
                }
                field(codigoRecurso; Rec."Codigo Recurso")
                {
                    Caption = 'Resource Code', Comment = 'ESP="Código Recurso"';
                }
                field(descripcion; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(cantidad; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                }
                field(costeUnitario; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                }
                field(tareaRealizada; Rec."Tarea Realizada")
                {
                    Caption = 'Task Performed', Comment = 'ESP="Tarea Realizada"';
                }
                field(comentarios; Rec.Comentarios)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                }
                field(tipo; Rec."JMC Tipo")
                {
                    Caption = 'Tipo', Comment = 'ESP="Tipo"';
                }
                field(fechaHoraUltimaModificacion; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time', Comment = 'ESP="Fecha/hora última modificación"';
                    Editable = false;
                }
                field(numeroLinea; Rec."Linea Recurso Evento")
                {
                    Caption = 'Line Number', Comment = 'ESP="Número Línea"';
                }
            }
        }
    }
}
