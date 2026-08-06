page 53115 "JMC Menu Especial API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Special Menu', Comment = 'ESP="Menú Especial"';
    EntitySetCaption = 'Special Menus', Comment = 'ESP="Menús Especiales"';
    EntityName = 'specialMenu';
    EntitySetName = 'specialMenus';

    PageType = API;
    SourceTable = "Lineas Evento";
    SourceTableView = where(Tipo = const(Otros));
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
                field(numeroLinea; Rec.Linea)
                {
                    Caption = 'Line No.', Comment = 'ESP="Nº Línea"';
                }
                field(tipo; Rec.Tipo)
                {
                    Caption = 'Type', Comment = 'ESP="Tipo"';
                    Editable = false;
                }
                field(numeroProducto; Rec."No.")
                {
                    Caption = 'Item No.', Comment = 'ESP="Código Producto"';
                }
                field(descripcion; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(cantidad; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                }
                field(precioUnitario; Rec."Precio Unitario")
                {
                    Caption = 'Unit Price', Comment = 'ESP="Precio Unitario"';
                }
                field(importe; Rec.Importe)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(costeUnitario; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                }
                field(costeTotal; Rec."Coste Total")
                {
                    Caption = 'Total Cost', Comment = 'ESP="Coste Total"';
                }
                field(fechaHoraUltimaModificacion; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time', Comment = 'ESP="Fecha/hora última modificación"';
                    Editable = false;
                }
            }
        }
    }
}
