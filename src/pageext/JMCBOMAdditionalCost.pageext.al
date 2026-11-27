pageextension 53132 "JMC BOM Additional Cost" extends "CP BOM Aditional Cost"
{
    layout
    {
        addafter(CostValue)
        {
            field(JMCModelTotalCost; JMCModelTotalCost)
            {
                Caption = 'Model Total Cost', Comment = 'ESP="Total Coste Modelo"';
                ToolTip = 'Shows the last calculated model total cost for this product and its base unit. The value is an amount or a percentage according to the model line cost type. It does not include manual final cost changes.', Comment = 'ESP="Muestra el último total coste calculado en el modelo para este producto y su unidad base. El valor es un importe o un porcentaje según el tipo de coste de la línea del modelo. No incluye los cambios del coste final manual."';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        jmcModel: Record "JMC Cost Model";
        jmcLine: Record "JMC Cost Model Line";
        jmcItem: Record Item;
        jmcTotalCost: Decimal;
    begin
        Clear(JMCModelTotalCost);
        if (Rec."No. Cost" <> 'C01') or (Rec."BOM Version" <> 0) then
            exit;

        if jmcModel.Get('GENERAL') then
            if jmcModel."JMC Calculated At" <> 0DT then
                if jmcItem.Get(Rec."Item No") then begin
                    jmcLine.SetRange("JMC Model Code", jmcModel."JMC Code");
                    jmcLine.SetRange("JMC Item No.", jmcItem."No.");
                    jmcLine.SetRange("JMC Unit of Measure Code", jmcItem."Base Unit of Measure");
                    jmcLine.SetRange("JMC Allocation Method", jmcLine."JMC Allocation Method"::Sales);
                    if jmcLine.FindFirst() then
                        jmcTotalCost := jmcLine."JMC Total Cost";
                end;
        JMCModelTotalCost := Format(jmcTotalCost, 0, '<Precision,2:2><Standard Format,0>');
    end;

    var
        JMCModelTotalCost: Text;
}
