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
        jmcAllCostsErr: Label 'C01 for item %1 applies to all costs. Disable that option in the recipe before applying an expense based only on recipe cost.', Comment = 'ESP="C01 del producto %1 se aplica a todos los costes. Desactive esa opción en la receta antes de aplicar un gasto basado solo en el coste de receta."';
        jmcRecipeChangedErr: Label 'Recipe cost for item %1 has changed. Recalculate the model before applying final totals based on its saved recipe cost.', Comment = 'ESP="El coste de receta del producto %1 ha cambiado. Recalcule el modelo antes de aplicar totales finales basados en su coste de receta guardado."';
        jmcTypeChangedErr: Label 'The cost type of C01 for item %1 is different from the type of the model line. Calculate the model again before applying the final cost. The recipe has not been changed.', Comment = 'ESP="El tipo de coste de C01 del producto %1 es distinto del de la línea del modelo. Calcule de nuevo el modelo antes de aplicar el coste final. No se ha cambiado la receta."';
    begin
        jmcCost.LockTable();
        jmcLine.LockTable();
        jmcLine.Get(jmcLine."JMC Model Code", jmcLine."JMC Line No.");
        jmcLine.TestManualTotals();
        jmcLine.TestField("JMC Net Sales Quantity");
        jmcLine.TestField("JMC Net Sales Base Qty.");
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
        jmcSavedBaseRecipe := jmcLine."JMC Recipe BOM Cost" * jmcLine."JMC Net Sales Quantity" / jmcLine."JMC Net Sales Base Qty.";
        if Abs(jmcAssemblyInfo.CalcItemCosteCalculado(jmcItem, true) - jmcSavedBaseRecipe) > 0.00001 then
            Error(jmcRecipeChangedErr, jmcItem."No.");
        jmcValue := jmcLine.GetFinalExpenseAmount() * jmcLine."JMC Net Sales Quantity" / jmcLine."JMC Net Sales Base Qty.";
        jmcCost.Validate(Value, jmcValue);
        jmcCost.Modify(true);
    end;
}
