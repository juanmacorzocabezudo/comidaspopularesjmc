tableextension 53116 "JMC Price List Header" extends "Price List Header"
{
    fields
    {
        modify(Status)
        {
            trigger OnBeforeValidate()
            var
                PriceListLine: Record "Price List Line";
                EmptyLinesErr: Label 'Cannot set status to Inactive because there are price list lines with empty product. Please delete or complete these lines first.', Comment = 'ESP="No se puede establecer el estado como Inactivo porque existen líneas de lista de precios con el producto vacío. Por favor, elimine o complete estas líneas primero."';
            begin
                // Only check when changing to Inactive
                if Rec.Status = Rec.Status::Inactive then begin
                    // Check if there are lines with empty Asset No. (product)
                    PriceListLine.SetRange("Price List Code", Rec.Code);
                    PriceListLine.SetRange("Asset No.", '');
                    if not PriceListLine.IsEmpty() then
                        Error(EmptyLinesErr);
                end;
            end;
        }
    }
}
