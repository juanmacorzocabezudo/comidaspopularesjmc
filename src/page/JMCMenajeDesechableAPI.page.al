page 53118 "JMC Menaje Desechable API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Disposable Tableware', Comment = 'ESP="Menaje Desechable"';
    EntitySetCaption = 'Disposable Tablewares', Comment = 'ESP="Menaje Desechable"';
    EntityName = 'disposableTableware';
    EntitySetName = 'disposableTablewares';

    PageType = API;
    SourceTable = "Productos Evento";
    SourceTableView = where(Tipo = const(Menaje));
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
                field(codigoProducto; Rec."Codigo Producto")
                {
                    Caption = 'Product Code', Comment = 'ESP="Código Producto"';
                }
                field(producto; Rec.Producto)
                {
                    Caption = 'Product', Comment = 'ESP="Producto"';
                }
                field(descripcion; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(cantidad; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                }
                field(unidadMedida; Rec."Unidad de medida")
                {
                    Caption = 'Unit of Measure', Comment = 'ESP="Unidad de medida"';
                }
                field(costeUnitario; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                }
                field(costeTotal; Rec."Coste Total")
                {
                    Caption = 'Total Cost', Comment = 'ESP="Coste Total"';
                    Editable = false;
                }
                field(precio; Rec.Precio)
                {
                    Caption = 'Price', Comment = 'ESP="Precio"';
                    Editable = false;
                }
                field(precioPropuesto; Rec."Precio Propuesto")
                {
                    Caption = 'Proposed Price', Comment = 'ESP="Precio Propuesto"';
                    Editable = false;
                }
                field(precioReal; Rec."Precio Real")
                {
                    Caption = 'Real Price', Comment = 'ESP="Precio Real"';
                }
                field(importe; Rec.Importe)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(porcentajeIVA; Rec."% IVA")
                {
                    Caption = 'VAT %', Comment = 'ESP="% IVA"';
                    Editable = false;
                }
                field(importeIVAIncl; Rec."Importe IVA Incl.")
                {
                    Caption = 'Amount Incl. VAT', Comment = 'ESP="Importe IVA Incl."';
                    Editable = false;
                }
                field(comentarios; Rec.Comentarios)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                }
                field(tipoMargen; Rec."Tipo Margen")
                {
                    Caption = 'Margin Type', Comment = 'ESP="Tipo Margen"';
                }
                field(valorMargen; Rec."Valor Margen")
                {
                    Caption = 'Margin Value', Comment = 'ESP="Valor Margen"';
                }
                field(imprime; Rec.Imprime)
                {
                    Caption = 'Print', Comment = 'ESP="Imprime"';
                }
                field(imprimeCapitulo; Rec.ImprCapitulo)
                {
                    Caption = 'Print Chapter', Comment = 'ESP="Capítulo"';
                }
                field(descripcionCapitulo; Rec.DescripCapitulo)
                {
                    Caption = 'Chapter Description', Comment = 'ESP="Descripción Capítulo"';
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
