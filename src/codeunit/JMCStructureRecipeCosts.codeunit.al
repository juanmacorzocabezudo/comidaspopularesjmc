codeunit 53107 "JMC Structure Recipe Costs"
{
    procedure GetStructureCost(jmcItemNo: Code[20]; var jmcPercentage: Boolean; var jmcValue: Decimal): Boolean
    var
        jmcCost: Record "BOM Aditional Cost";
    begin
        if not jmcCost.Get(jmcItemNo, 0, 'C01') then
            exit(false);
        jmcPercentage := jmcCost."Type Coste" = jmcCost."Type Coste"::"%";
        jmcValue := jmcCost.Value;
        exit(true);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyLine(jmcLine: Record "JMC Cost Model Line")
    var
        jmcCost: Record "BOM Aditional Cost";
        jmcItem: Record Item;
        jmcAssemblyInfo: Codeunit AlxiaAssemblyInfoManagement;
        jmcValue: Decimal;
        jmcSavedBaseRecipe: Decimal;
        jmcUnitFactor: Decimal;
        jmcAllCostsErr: Label 'C01 for item %1 applies to all costs. Disable that option in the recipe before applying an expense based only on recipe cost.', Comment = 'ESP="C01 del producto %1 se aplica a todos los costes. Desactive esa opción en la receta antes de aplicar un gasto basado solo en el coste de receta."';
        jmcRecipeChangedErr: Label 'Recipe cost for item %1 has changed. Recalculate the model before applying final totals based on its saved recipe cost.', Comment = 'ESP="El coste de receta del producto %1 ha cambiado. Recalcule el modelo antes de aplicar totales finales basados en su coste de receta guardado."';
        jmcTypeChangedErr: Label 'The cost type of C01 for item %1 is different from the type of the model line. Calculate the model again before applying the final cost. The recipe has not been changed.', Comment = 'ESP="El tipo de coste de C01 del producto %1 es distinto del de la línea del modelo. Calcule de nuevo el modelo antes de aplicar el coste final. No se ha cambiado la receta."';
        jmcUnitFactorErr: Label 'The saved unit conversion is missing. Calculate all costs again before applying the final cost.', Comment = 'ESP="Falta la conversión de unidad guardada. Calcule todos los costes de nuevo antes de aplicar el coste final."';
    begin
        jmcCost.LockTable();
        jmcLine.LockTable();
        jmcLine.Get(jmcLine."JMC Model Code", jmcLine."JMC Line No.");
        jmcLine.TestManualTotals();
        jmcUnitFactor := jmcLine."JMC Production Unit Factor";
        if (jmcUnitFactor <= 0) and not jmcLine."JMC Production Inputs Ready" and
           (jmcLine."JMC Net Sales Quantity" > 0) and (jmcLine."JMC Net Sales Base Qty." > 0)
        then
            jmcUnitFactor := jmcLine."JMC Net Sales Base Qty." / jmcLine."JMC Net Sales Quantity";
        if jmcUnitFactor <= 0 then
            Error(jmcUnitFactorErr);
        jmcItem.Get(jmcLine."JMC Item No.");
        jmcItem.TestField(Blocked, false);
        jmcCost.Get(jmcLine."JMC Item No.", 0, 'C01');
        if (jmcCost."Type Coste" = jmcCost."Type Coste"::"%") <> (jmcLine."JMC Cost Value Type" = jmcLine."JMC Cost Value Type"::Percentage) then
            Error(jmcTypeChangedErr, jmcLine."JMC Item No.");
        if jmcCost."Apply on all cost" then
            Error(jmcAllCostsErr, jmcLine."JMC Item No.");
        if jmcLine."JMC Cost Value Type" = jmcLine."JMC Cost Value Type"::Percentage then begin
            jmcCost.Validate(Value, jmcLine."JMC Final Cost");
            jmcCost.Modify(true);
            exit;
        end;
        jmcSavedBaseRecipe := jmcLine."JMC Recipe BOM Cost" / jmcUnitFactor;
        if Abs(jmcAssemblyInfo.CalcItemCosteCalculado(jmcItem, true) - jmcSavedBaseRecipe) > 0.00001 then
            Error(jmcRecipeChangedErr, jmcItem."No.");
        jmcValue := jmcLine.GetFinalExpenseAmount() / jmcUnitFactor;
        jmcCost.Validate(Value, jmcValue);
        jmcCost.Modify(true);
    end;
}
