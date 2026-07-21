page 53125 "JMC Menu Adulto API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Adult Menu', Comment = 'ESP="Menú Adulto"';
    EntitySetCaption = 'Adult Menus', Comment = 'ESP="Menús Adulto"';
    EntityName = 'adultMenu';
    EntitySetName = 'adultMenus';

    PageType = API;
    SourceTable = "Lineas Evento";
    SourceTableView = where(Tipo = const(Adulto));
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
                field(lineNo; Rec.Linea)
                {
                    Caption = 'Line No.', Comment = 'ESP="Nº Línea"';
                }
                field(type; Rec.Tipo)
                {
                    Caption = 'Type', Comment = 'ESP="Tipo"';
                    Editable = false;
                }
                field(itemNo; Rec."No.")
                {
                    Caption = 'Item No.', Comment = 'ESP="Código Producto"';
                }
                field(description; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(quantity; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                }
                field(unitPrice; Rec."Precio Unitario")
                {
                    Caption = 'Unit Price', Comment = 'ESP="Precio Unitario"';
                }
                field(lineAmount; Rec.Importe)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(unitCost; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                }
                field(totalCost; Rec."Coste Total")
                {
                    Caption = 'Total Cost', Comment = 'ESP="Coste Total"';
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
