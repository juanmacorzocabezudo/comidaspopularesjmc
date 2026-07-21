page 53121 "JMC Recursos Evento API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'events';

    EntityCaption = 'Event Resource', Comment = 'ESP="Recurso Evento"';
    EntitySetCaption = 'Event Resources', Comment = 'ESP="Recursos Evento"';
    EntityName = 'eventResource';
    EntitySetName = 'eventResources';

    PageType = API;
    SourceTable = "Recursos Evento";
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
                field(resourceCode; Rec."Codigo Recurso")
                {
                    Caption = 'Resource Code', Comment = 'ESP="Código Recurso"';
                }
                field(description; Rec.Descripcion)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(resourceType; Rec."Tipo Recurso")
                {
                    Caption = 'Resource Type', Comment = 'ESP="Tipo Recurso"';
                    Editable = false;
                }
                field(quantity; Rec.Cantidad)
                {
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                }
                field(unitOfMeasure; Rec."Unidad de medida")
                {
                    Caption = 'Unit of Measure', Comment = 'ESP="Unidad de medida"';
                }
                field(unitCost; Rec."Coste Unitario")
                {
                    Caption = 'Unit Cost', Comment = 'ESP="Coste Unitario"';
                }
                field(totalCost; Rec."Coste Total")
                {
                    Caption = 'Total Cost', Comment = 'ESP="Coste Total"';
                    Editable = false;
                }
                field(price; Rec.Precio)
                {
                    Caption = 'Price', Comment = 'ESP="Precio"';
                    Editable = false;
                }
                field(proposedPrice; Rec."Precio Propuesto")
                {
                    Caption = 'Proposed Price', Comment = 'ESP="Precio Propuesto"';
                    Editable = false;
                }
                field(realPrice; Rec."Precio Real")
                {
                    Caption = 'Real Price', Comment = 'ESP="Precio Real"';
                }
                field(amount; Rec.Importe)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(vatPercent; Rec."% IVA")
                {
                    Caption = 'VAT %', Comment = 'ESP="% IVA"';
                    Editable = false;
                }
                field(amountInclVAT; Rec."Importe IVA Incl.")
                {
                    Caption = 'Amount Incl. VAT', Comment = 'ESP="Importe IVA Incl."';
                    Editable = false;
                }
                field(priceInclVAT; Rec."Precio IVA Incl.")
                {
                    Caption = 'Price Incl. VAT', Comment = 'ESP="Precio IVA Incl."';
                    Editable = false;
                }
                field(comments; Rec.Comentarios)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                }
                field(marginType; Rec."Tipo Margen")
                {
                    Caption = 'Margin Type', Comment = 'ESP="Tipo Margen"';
                }
                field(marginValue; Rec."Valor Margen")
                {
                    Caption = 'Margin Value', Comment = 'ESP="Valor Margen"';
                }
                field(print; Rec.Imprime)
                {
                    Caption = 'Print', Comment = 'ESP="Imprime"';
                }
                field(printChapter; Rec.ImprCapitulo)
                {
                    Caption = 'Print Chapter', Comment = 'ESP="Capítulo"';
                }
                field(chapterDescription; Rec.DescripCapitulo)
                {
                    Caption = 'Chapter Description', Comment = 'ESP="Descripción Capítulo"';
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
