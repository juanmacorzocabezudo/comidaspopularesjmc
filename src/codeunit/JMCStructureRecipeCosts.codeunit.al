codeunit 53107 "JMC Structure Recipe Costs"
{
    trigger OnRun()
    var
        jmcEmail: Codeunit Email;
        jmcEmailMessage: Codeunit "Email Message";
        jmcBody: TextBuilder;
        jmcRecipients: List of [Text];
        jmcParts: List of [Text];
        jmcAddress: Text;
        jmcItem: Text;
        jmcSubjectLbl: Label 'Applied structure costs: %1', Comment = 'ESP="Costes de estructura aplicados: %1"';
        jmcBodyLbl: Label 'The structure cost C01 was changed for the following products:', Comment = 'ESP="Se ha modificado el coste de estructura C01 de los siguientes productos:"';
        jmcNoRecipientsErr: Label 'No notification email recipients were provided.', Comment = 'ESP="No se han indicado destinatarios para la notificación por email."';
        jmcSendErr: Label 'Business Central could not confirm that the email was sent. Check the email configuration and outbox.', Comment = 'ESP="Business Central no ha podido confirmar el envío del email. Revise la configuración de correo y la bandeja de salida."';
    begin
        jmcParts := JMCNotificationRecipients.Split(';');
        foreach jmcAddress in jmcParts do begin
            jmcAddress := DelChr(jmcAddress, '<>', ' ');
            if jmcAddress <> '' then
                jmcRecipients.Add(jmcAddress);
        end;
        if jmcRecipients.Count() = 0 then
            Error(jmcNoRecipientsErr);
        jmcBody.AppendLine(jmcBodyLbl);
        jmcBody.AppendLine();
        foreach jmcItem in JMCNotificationItems do
            jmcBody.AppendLine(jmcItem);
        jmcEmailMessage.Create(jmcRecipients, StrSubstNo(jmcSubjectLbl, JMCNotificationGroup), jmcBody.ToText(), false);
        if not jmcEmail.Send(jmcEmailMessage, Enum::"Email Scenario"::Default) then
            Error(jmcSendErr);
    end;

    procedure SetNotification(jmcRecipients: Text; jmcGroup: Text; jmcItems: List of [Text])
    begin
        JMCNotificationRecipients := jmcRecipients;
        JMCNotificationGroup := jmcGroup;
        JMCNotificationItems := jmcItems;
    end;

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

    procedure GetItemBusiness(jmcItemNo: Code[20]): Integer
    begin
        if CopyStr(jmcItemNo, 1, 3) = 'SER' then
            exit(2);
        case CopyStr(jmcItemNo, 1, 2) of
            'CA', 'MP', 'MA':
                exit(1);
            'PT', 'PI', 'PR':
                exit(2);
        end;
        exit(0);
    end;

    procedure GetBusinessItemFilter(jmcBusiness: Integer): Text
    var
        jmcBusinessErr: Label 'The selected business is not supported.', Comment = 'ESP="El negocio seleccionado no es compatible."';
    begin
        case jmcBusiness of
            1:
                exit('CA*|MP*|MA*');
            2:
                exit('PT*|PI*|PR*|SER*');
            else
                Error(jmcBusinessErr);
        end;
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyModel(jmcModelCode: Code[20]; var jmcApplied: Integer; var jmcSkipped: Integer)
    var
        jmcUnchanged: Integer;
    begin
        ApplyModelWithCounts(jmcModelCode, jmcApplied, jmcUnchanged, jmcSkipped);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyModelWithCounts(jmcModelCode: Code[20]; var jmcApplied: Integer; var jmcUnchanged: Integer; var jmcSkipped: Integer)
    begin
        ApplyModelForBusiness(jmcModelCode, Enum::"JMC Business Line Filter"::Both, jmcApplied, jmcUnchanged, jmcSkipped);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyModelForBusiness(jmcModelCode: Code[20]; jmcBusiness: Enum "JMC Business Line Filter"; var jmcApplied: Integer; var jmcUnchanged: Integer; var jmcSkipped: Integer)
    var
        jmcChangedItems: List of [Text];
    begin
        ApplyModelForBusinessWithItems(jmcModelCode, jmcBusiness, jmcApplied, jmcUnchanged, jmcSkipped, jmcChangedItems);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyModelForBusinessWithItems(jmcModelCode: Code[20]; jmcBusiness: Enum "JMC Business Line Filter"; var jmcApplied: Integer; var jmcUnchanged: Integer; var jmcSkipped: Integer; var jmcChangedItems: List of [Text])
    var
        jmcModel: Record "JMC Cost Model";
        jmcLine: Record "JMC Cost Model Line";
        jmcItem: Record Item;
        jmcItems: Dictionary of [Code[20], Boolean];
        jmcRecalculateErr: Label 'Calculate all costs again before applying the model. Each product must have one line in its current base unit.', Comment = 'ESP="Calcule todos los costes de nuevo antes de aplicar el modelo. Cada producto debe tener una línea en su unidad base actual."';
        jmcNoLinesErr: Label 'The model has no product lines to apply for the selected scope.', Comment = 'ESP="El modelo no tiene líneas de producto que aplicar para el ámbito seleccionado."';
        jmcBusinessErr: Label 'The selected business is not supported.', Comment = 'ESP="El negocio seleccionado no es compatible."';
    begin
        jmcApplied := 0;
        jmcUnchanged := 0;
        jmcSkipped := 0;
        Clear(jmcChangedItems);
        jmcModel.LockTable();
        jmcModel.Get(jmcModelCode);
        jmcModel.TestField("JMC Calculated At");
        if not jmcModel."JMC Personnel Sources Ready" then
            Error(jmcRecalculateErr);
        jmcLine.LockTable();
        jmcLine.SetRange("JMC Model Code", jmcModelCode);
        case jmcBusiness of
            jmcBusiness::Catering:
                jmcLine.SetFilter("JMC Item No.", GetBusinessItemFilter(1));
            jmcBusiness::Industry:
                jmcLine.SetFilter("JMC Item No.", GetBusinessItemFilter(2));
            jmcBusiness::Both:
                ;
            else
                Error(jmcBusinessErr);
        end;
        if not jmcLine.FindSet() then
            Error(jmcNoLinesErr);
        repeat
            jmcItem.Get(jmcLine."JMC Item No.");
            if (jmcLine."JMC Allocation Method" <> jmcLine."JMC Allocation Method"::Sales) or
               (jmcLine."JMC Unit of Measure Code" <> jmcItem."Base Unit of Measure") or
               jmcItems.ContainsKey(jmcLine."JMC Item No.")
            then
                Error(jmcRecalculateErr);
            jmcItems.Add(jmcLine."JMC Item No.", true);
        until jmcLine.Next() = 0;
        if jmcLine.FindSet() then
            repeat
                if not jmcLine."JMC Allocation Eligible" or (jmcLine."JMC Calculation Issue" <> '') then
                    jmcSkipped += 1
                else
                    if ApplyLineIfChanged(jmcLine) then begin
                        jmcChangedItems.Add(jmcLine."JMC Item No." + ' - ' + jmcLine."JMC Item Description");
                        jmcApplied += 1
                    end else
                        jmcUnchanged += 1;
            until jmcLine.Next() = 0;
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyLine(jmcLine: Record "JMC Cost Model Line")
    begin
        ApplyLineIfChanged(jmcLine);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    local procedure ApplyLineIfChanged(jmcLine: Record "JMC Cost Model Line"): Boolean
    var
        jmcCost: Record "BOM Aditional Cost";
        jmcItem: Record Item;
        jmcModel: Record "JMC Cost Model";
        jmcHistory: Record "JMC C01 Cost History";
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
        if jmcLine."JMC Cost Value Type" = jmcLine."JMC Cost Value Type"::Percentage then
            jmcValue := jmcLine."JMC Final Cost"
        else
            jmcValue := jmcLine.GetFinalExpenseAmount() / jmcUnitFactor;
        if jmcCost.Value = jmcValue then
            exit(false);
        if jmcLine."JMC Cost Value Type" = jmcLine."JMC Cost Value Type"::Amount then begin
            jmcSavedBaseRecipe := jmcLine."JMC Recipe BOM Cost" / jmcUnitFactor;
            if Abs(jmcAssemblyInfo.CalcItemCosteCalculado(jmcItem, true) - jmcSavedBaseRecipe) > 0.00001 then
                Error(jmcRecipeChangedErr, jmcItem."No.");
        end;
        jmcCost.Validate(Value, jmcValue);
        // Validate the cost, but do not require a change to the recipe status.
        jmcCost.Modify(false);
        jmcModel.Get(jmcLine."JMC Model Code");
        ClearFixedHistory(jmcItem."No.");
        jmcHistory.Init();
        jmcHistory."JMC Item No." := jmcItem."No.";
        jmcHistory."JMC Cost Value" := jmcCost.Value;
        jmcHistory."JMC Cost Type" := jmcLine."JMC Cost Value Type";
        jmcHistory."JMC Applied At" := CurrentDateTime();
        jmcHistory."JMC Applied By" := CopyStr(UserId(), 1, MaxStrLen(jmcHistory."JMC Applied By"));
        jmcHistory."JMC Model Code" := jmcLine."JMC Model Code";
        jmcHistory."JMC Starting Date" := jmcModel."JMC Starting Date";
        jmcHistory."JMC Ending Date" := jmcModel."JMC Ending Date";
        jmcHistory."JMC Base Unit" := jmcItem."Base Unit of Measure";
        jmcHistory."JMC Cost Fixed" := true;
        jmcHistory."JMC Fixed At" := jmcHistory."JMC Applied At";
        jmcHistory."JMC Fixed By" := jmcHistory."JMC Applied By";
        jmcHistory.Insert(true);
        exit(true);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure FixHistoryEntry(var jmcSelected: Record "JMC C01 Cost History")
    var
        jmcCost: Record "BOM Aditional Cost";
        jmcHistory: Record "JMC C01 Cost History";
        jmcItem: Record Item;
        jmcTypeChangedErr: Label 'The C01 cost type for item %1 differs from the history entry. The recipe has not been changed.', Comment = 'ESP="El tipo de coste C01 del producto %1 es distinto del movimiento histórico. No se ha cambiado la receta."';
        jmcAllCostsErr: Label 'C01 for item %1 applies to all costs. Disable that option in the recipe before applying the historical value.', Comment = 'ESP="C01 del producto %1 se aplica a todos los costes. Desactive esa opción en la receta antes de aplicar el valor histórico."';
        jmcUnitChangedErr: Label 'The base unit of item %1 has changed since this historical value was applied. The recipe has not been changed.', Comment = 'ESP="La unidad base del producto %1 ha cambiado desde que se aplicó este valor histórico. No se ha cambiado la receta."';
    begin
        jmcCost.LockTable();
        jmcCost.Get(jmcSelected."JMC Item No.", 0, 'C01');
        jmcHistory.LockTable();
        jmcHistory.Get(jmcSelected."JMC Entry No.");
        jmcItem.Get(jmcHistory."JMC Item No.");
        if (jmcCost."Type Coste" = jmcCost."Type Coste"::"%") <> (jmcHistory."JMC Cost Type" = jmcHistory."JMC Cost Type"::Percentage) then
            Error(jmcTypeChangedErr, jmcHistory."JMC Item No.");
        if jmcCost."Apply on all cost" then
            Error(jmcAllCostsErr, jmcHistory."JMC Item No.");
        if (jmcHistory."JMC Cost Type" = jmcHistory."JMC Cost Type"::Amount) and
           (jmcItem."Base Unit of Measure" <> jmcHistory."JMC Base Unit")
        then
            Error(jmcUnitChangedErr, jmcHistory."JMC Item No.");
        jmcCost.Validate(Value, jmcHistory."JMC Cost Value");
        jmcCost.Modify(false);
        ClearFixedHistory(jmcHistory."JMC Item No.");
        jmcSelected := jmcHistory;
        jmcSelected."JMC Cost Fixed" := true;
        jmcSelected."JMC Fixed At" := CurrentDateTime();
        jmcSelected."JMC Fixed By" := CopyStr(UserId(), 1, MaxStrLen(jmcSelected."JMC Fixed By"));
    end;

    local procedure ClearFixedHistory(jmcItemNo: Code[20])
    var
        jmcHistory: Record "JMC C01 Cost History";
    begin
        jmcHistory.LockTable();
        jmcHistory.SetRange("JMC Item No.", jmcItemNo);
        jmcHistory.SetRange("JMC Cost Fixed", true);
        jmcHistory.ModifyAll("JMC Cost Fixed", false);
    end;

    var
        JMCNotificationRecipients: Text;
        JMCNotificationGroup: Text;
        JMCNotificationItems: List of [Text];
}
