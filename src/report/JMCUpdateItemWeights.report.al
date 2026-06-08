report 53101 "JMC Update Item Weights"
{
    Caption = 'Update Item Weights from Format', Comment = 'ESP="Actualizar pesos de productos desde formato"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Formato;

            trigger OnAfterGetRecord()
            var
                FormatoProducto: Record "Formato Producto";
                WeightExtractor: Codeunit "JMC Weight Extractor";
                ExtractedWeight: Decimal;
            begin
                // Skip if no format assigned
                if Item.Formato = '' then begin
                    SkippedCount += 1;
                    exit;
                end;

                // Try to find the format in Formato Producto table
                if not FormatoProducto.Get(Item.Formato) then begin
                    NotFoundCount += 1;
                    exit;
                end;

                // Extract weight from description
                ExtractedWeight := WeightExtractor.ExtractWeightInGrams(FormatoProducto.Descripcion);

                if ExtractedWeight > 0 then begin
                    Item."JMC Weight" := ExtractedWeight;
                    Item.Modify(true);
                    UpdatedCount += 1;
                end else begin
                    NoWeightCount += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message(ResultMsg, UpdatedCount, SkippedCount, NoWeightCount, NotFoundCount);
            end;
        }
    }

    var
        UpdatedCount: Integer;
        SkippedCount: Integer;
        NoWeightCount: Integer;
        NotFoundCount: Integer;
        ResultMsg: Label 'Process completed:\Updated: %1\Skipped (already has weight): %2\No weight found in description: %3\Format not found: %4', Comment = 'ESP="Proceso completado:\Actualizados: %1\Omitidos (ya tienen peso): %2\Sin peso en descripción: %3\Formato no encontrado: %4"';
}
