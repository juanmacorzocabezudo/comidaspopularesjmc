codeunit 53104 "JMC Cost Model Calculation"
{
    [CommitBehavior(CommitBehavior::Error)]
    procedure Calculate(jmcModelCode: Code[20]; jmcStartingDate: Date; jmcEndingDate: Date; jmcAccountFilter: Text[250])
    var
        jmcCostModel: Record "JMC Cost Model";
        jmcInvalidDatesErr: Label 'Enter a starting date and ending date in chronological order, without closing dates.', Comment = 'ESP="Introduzca fechas inicial y final en orden cronológico, sin fechas de cierre."';
    begin
        if (jmcStartingDate = 0D) or (jmcEndingDate = 0D) or (jmcStartingDate > jmcEndingDate) or
           (NormalDate(jmcStartingDate) <> jmcStartingDate) or (NormalDate(jmcEndingDate) <> jmcEndingDate)
        then
            Error(jmcInvalidDatesErr);
        ResetCalculation();
        JMCDetail.Initialize(jmcModelCode);
        jmcCostModel.LockTable();
        SynchronizeProducts(jmcModelCode, jmcStartingDate, jmcEndingDate);
        jmcCostModel.Get(jmcModelCode);
        ReadProductionCosts(jmcCostModel, jmcStartingDate, jmcEndingDate);
        ReadPersonnelCosts(jmcCostModel, jmcStartingDate, jmcEndingDate, jmcAccountFilter);
        ReadFunds(jmcCostModel, jmcStartingDate, jmcEndingDate, jmcAccountFilter);
        LoadLines(jmcModelCode);
        PrepareBases();
        AllocateFunds(jmcCostModel);
        SaveResults(jmcCostModel, jmcStartingDate, jmcEndingDate, jmcAccountFilter);
        JMCDetail.Save(jmcCostModel);
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure RecalculateProduction(jmcModelCode: Code[20])
    var
        jmcCostModel: Record "JMC Cost Model";
        jmcSnapshotErr: Label 'Calculate all costs again before recalculating production quantities. The saved calculation inputs are incomplete or a product line was changed.', Comment = 'ESP="Calcule todos los costes de nuevo antes de recalcular las cantidades de fabricación. Los datos guardados están incompletos o se ha modificado una línea de producto."';
    begin
        ResetCalculation();
        jmcCostModel.LockTable();
        jmcCostModel.Get(jmcModelCode);
        jmcCostModel.TestField("JMC Calculated At");
        if not jmcCostModel."JMC Personnel Sources Ready" then
            Error(jmcSnapshotErr);
        JMCDetail.InitializeSavedSources(jmcModelCode);
        LoadLines(jmcModelCode);
        JMCTempLines.Reset();
        if JMCDetail.SavedLineCount(jmcModelCode) <> JMCTempLines.Count() then
            Error(jmcSnapshotErr);
        if JMCTempLines.FindSet() then
            repeat
                if not JMCTempLines."JMC Production Inputs Ready" or not JMCDetail.HasSavedLine(JMCTempLines) then
                    Error(jmcSnapshotErr);
                JMCTempLines."JMC Calculation Issue" := JMCTempLines."JMC Source Calculation Issue";
                SetProductionEligibility();
                if JMCTempLines."JMC Allocation Eligible" then
                    if not JMCRecipeCosts.ContainsKey(JMCTempLines."JMC Item No.") then
                        JMCRecipeCosts.Add(JMCTempLines."JMC Item No.", JMCTempLines."JMC Recipe BOM Cost" / JMCTempLines."JMC Production Unit Factor");
                JMCTempLines.Modify(false);
            until JMCTempLines.Next() = 0;
        BuildBases();
        AllocateFunds(jmcCostModel);
        SaveResults(jmcCostModel, jmcCostModel."JMC Starting Date", jmcCostModel."JMC Ending Date", jmcCostModel."JMC Account Filter");
        JMCDetail.Save(jmcCostModel);
    end;

    local procedure ResetCalculation()
    begin
        JMCTempLines.Reset();
        JMCTempLines.DeleteAll(false);
        Clear(JMCRecipeCosts);
        Clear(JMCItemIssues);
        Clear(JMCProductionQuantities);
        Clear(JMCSalesBaseTotals);
        Clear(JMCBases);
        Clear(JMCBusinessQuantityBases);
        Clear(JMCSalesGroupRecipeBases);
        Clear(JMCSalesGroupQuantityBases);
        Clear(JMCSalesGroupKeys);
        Clear(JMCSalesGroupCounts);
        Clear(JMCPendingFunds);
    end;

    local procedure ReadProductionCosts(var jmcCostModel: Record "JMC Cost Model"; jmcStartingDate: Date; jmcEndingDate: Date)
    var
        jmcOutput: Record "Item Ledger Entry";
        jmcDimension: Record Dimension;
        jmcDimensionValue: Record "Dimension Value";
        jmcDimensionEntry: Record "Dimension Set Entry";
        jmcCateringCost: Decimal;
        jmcIndustryCost: Decimal;
        jmcBusiness: Code[20];
        jmcIncluded: Boolean;
        jmcIssue: Text[250];
        jmcMissingLineLbl: Label 'Excluded: production movement has no LINEA value.', Comment = 'ESP="Excluido: el movimiento de producción no tiene valor LINEA."';
        jmcZeroCostLbl: Label 'Excluded: actual production cost is zero.', Comment = 'ESP="Excluido: el coste real de producción es cero."';
        jmcUnknownBusinessErr: Label 'Assembly output entry %1 (item %2) has LINEA value %3, not CATERING or ALIMENTACION.', Comment = 'ESP="El movimiento de salida de ensamblado %1 (producto %2) tiene el valor LINEA %3, distinto de CATERING o ALIMENTACION."';
        jmcNegativeProductionErr: Label 'Net actual production cost for LINEA = %1 is negative (%2). Review assembly output reversals and cost adjustments for the period.', Comment = 'ESP="El coste real neto de producción para LINEA = %1 es negativo (%2). Revise las reversiones de salidas de ensamblado y los ajustes de coste del periodo."';
        jmcNoProductionErr: Label 'No positive net actual production cost was found for final assembly outputs (CA/PT) in this period. Business percentages cannot be calculated.', Comment = 'ESP="No se ha encontrado coste real neto de producción positivo de salidas de ensamblado finales (CA/PT) en este periodo. No pueden calcularse los porcentajes por negocio."';
    begin
        jmcDimension.Get('LINEA');
        jmcDimensionValue.Get('LINEA', 'CATERING');
        jmcDimensionValue.TestField("Dimension Value Type", jmcDimensionValue."Dimension Value Type"::Standard);
        jmcDimensionValue.Get('LINEA', 'ALIMENTACION');
        jmcDimensionValue.TestField("Dimension Value Type", jmcDimensionValue."Dimension Value Type"::Standard);
        jmcOutput.SetRange("Entry Type", jmcOutput."Entry Type"::"Assembly Output");
        jmcOutput.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
        jmcOutput.SetAutoCalcFields("Cost Amount (Actual)");
        if jmcOutput.FindSet() then
            repeat
                if JMCProductionQuantities.ContainsKey(jmcOutput."Item No.") then
                    JMCProductionQuantities.Set(jmcOutput."Item No.", JMCProductionQuantities.Get(jmcOutput."Item No.") + jmcOutput.Quantity)
                else
                    JMCProductionQuantities.Add(jmcOutput."Item No.", jmcOutput.Quantity);
                // Final outputs already include the cost of intermediate recipes.
                case CopyStr(jmcOutput."Item No.", 1, 2) of
                    'CA', 'PT':
                        begin
                            Clear(jmcBusiness);
                            Clear(jmcIssue);
                            jmcIncluded := false;
                            if jmcDimensionEntry.Get(jmcOutput."Dimension Set ID", 'LINEA') then
                                jmcBusiness := jmcDimensionEntry."Dimension Value Code";
                            if jmcOutput."Cost Amount (Actual)" = 0 then
                                jmcIssue := jmcZeroCostLbl
                            else
                                case jmcBusiness of
                                    'CATERING':
                                        begin
                                            jmcCateringCost += jmcOutput."Cost Amount (Actual)";
                                            jmcIncluded := true;
                                        end;
                                    'ALIMENTACION':
                                        begin
                                            jmcIndustryCost += jmcOutput."Cost Amount (Actual)";
                                            jmcIncluded := true;
                                        end;
                                    '':
                                        jmcIssue := jmcMissingLineLbl;
                                    else
                                        Error(jmcUnknownBusinessErr, jmcOutput."Entry No.", jmcOutput."Item No.", jmcBusiness);
                                end;
                            JMCDetail.AddProduction(jmcOutput, jmcBusiness, jmcIncluded, jmcIssue);
                        end;
                end;
            until jmcOutput.Next() = 0;
        if jmcCateringCost < 0 then
            Error(jmcNegativeProductionErr, 'CATERING', jmcCateringCost);
        if jmcIndustryCost < 0 then
            Error(jmcNegativeProductionErr, 'ALIMENTACION', jmcIndustryCost);
        if jmcCateringCost + jmcIndustryCost = 0 then
            Error(jmcNoProductionErr);
        jmcCostModel."JMC Catering Production Cost" := jmcCateringCost;
        jmcCostModel."JMC Industry Production Cost" := jmcIndustryCost;
        jmcCostModel."JMC Production Dimension" := 'LINEA';
        jmcCostModel.RecalculateAllocations();
    end;

    local procedure ReadFunds(var jmcCostModel: Record "JMC Cost Model"; jmcStartingDate: Date; jmcEndingDate: Date; jmcAccountFilter: Text[250])
    var
        jmcAccount: Record "G/L Account";
        jmcEntry: Record "G/L Entry";
        jmcFunds: array[2] of Decimal;
        jmcClassification: Integer;
        jmcHasEntries: Boolean;
        jmcPartialErr: Label 'Account %1 has only one cost category filled in. Complete both fields or clear both before calculating.', Comment = 'ESP="La cuenta %1 solo tiene una categoría de coste informada. Complete ambos campos o vacíe ambos antes de calcular."';
        jmcNoEntriesErr: Label 'No non-closing ledger entries were found for configured fixed-cost accounts in this period and account filter.', Comment = 'ESP="No se han encontrado movimientos contables sin cierre de cuentas configuradas de coste fijo para este periodo y filtro."';
        jmcNegativeErr: Label 'The amount for cost type %1 and classification %2 is negative (%3). Review accounts, signs and period; credits are not converted to expenses.', Comment = 'ESP="El importe del tipo de coste %1 y clasificación %2 es negativo (%3). Revise cuentas, signos y periodo; los abonos no se convierten en gastos."';
    begin
        if jmcAccountFilter <> '' then
            jmcAccount.SetFilter("No.", jmcAccountFilter);
        jmcAccount.SetFilter("JMC Cost Type", '%1|%2', jmcAccount."JMC Cost Type"::Fixed, jmcAccount."JMC Cost Type"::" ");
        if jmcAccount.FindSet() then
            repeat
                if (jmcAccount."JMC Cost Type" <> jmcAccount."JMC Cost Type"::" ") or
                   (jmcAccount."JMC Cost Classification" <> jmcAccount."JMC Cost Classification"::" ")
                then begin
                    jmcClassification := jmcAccount."JMC Cost Classification".AsInteger();
                    jmcEntry.SetRange("G/L Account No.", jmcAccount."No.");
                    jmcEntry.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
                    jmcEntry.SetLoadFields(Amount, "Posting Date", "Document No.", Description, "JMC Resource No.");
                    if jmcEntry.FindSet() then
                        repeat
                            if (jmcEntry."Posting Date" = NormalDate(jmcEntry."Posting Date")) and
                               (jmcEntry."JMC Resource No." = '')
                            then begin
                                if (jmcAccount."JMC Cost Type" = jmcAccount."JMC Cost Type"::" ") or
                                   (jmcAccount."JMC Cost Classification" = jmcAccount."JMC Cost Classification"::" ")
                                then
                                    Error(jmcPartialErr, jmcAccount."No.");
                                jmcFunds[jmcClassification] += jmcEntry.Amount;
                                jmcHasEntries := true;
                                JMCDetail.AddAccounting(jmcEntry, jmcAccount);
                            end;
                        until jmcEntry.Next() = 0;
                end;
            until jmcAccount.Next() = 0;
        if not jmcHasEntries and (jmcCostModel."JMC Fixed Resource Cost" = 0) and
           (jmcCostModel."JMC Catering Direct Personnel" = 0) and (jmcCostModel."JMC Industry Direct Personnel" = 0)
        then
            Error(jmcNoEntriesErr);
        for jmcClassification := 1 to 2 do begin
            if jmcFunds[jmcClassification] < 0 then
                Error(jmcNegativeErr, Enum::"JMC Cost Type"::Fixed, Enum::"JMC Cost Classification".FromInteger(jmcClassification), jmcFunds[jmcClassification]);
            jmcFunds[jmcClassification] := RoundAmount(jmcFunds[jmcClassification]);
        end;
        jmcCostModel."JMC Fixed Industrial Fund" := jmcFunds[1];
        jmcCostModel."JMC Variable Industrial Fund" := 0;
        jmcCostModel."JMC Fixed Management Fund" := jmcFunds[2];
        jmcCostModel."JMC Variable Management Fund" := 0;
        jmcCostModel.Validate("JMC Total Structure Cost", jmcFunds[1] + jmcFunds[2]);
    end;

    local procedure ReadPersonnelCosts(var jmcCostModel: Record "JMC Cost Model"; jmcStartingDate: Date; jmcEndingDate: Date; jmcAccountFilter: Text[250])
    var
        jmcEntry: Record "G/L Entry";
        jmcAccount: Record "G/L Account";
        jmcResource: Record Resource;
        jmcFixed: Decimal;
        jmcDirect: array[2] of Decimal;
        jmcNegativeCostErr: Label 'Net personnel cost is negative for %1 (%2). Review the source expenses and period.', Comment = 'ESP="El coste neto de personal es negativo para %1 (%2). Revise los gastos de origen y el periodo."';
    begin
        jmcEntry.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
        jmcEntry.SetFilter("JMC Resource No.", '<>%1', '');
        if jmcAccountFilter <> '' then
            jmcEntry.SetFilter("G/L Account No.", jmcAccountFilter);
        if jmcEntry.FindSet() then
            repeat
                jmcAccount.Get(jmcEntry."G/L Account No.");
                if (jmcEntry."Posting Date" = NormalDate(jmcEntry."Posting Date")) and
                   (jmcAccount."Income/Balance" = jmcAccount."Income/Balance"::"Income Statement")
                then begin
                    jmcResource.Get(jmcEntry."JMC Resource No.");
                    jmcResource.TestField("JMC Cost Type");
                    if jmcResource."JMC Cost Type" = jmcResource."JMC Cost Type"::Fixed then begin
                        jmcFixed += jmcEntry.Amount;
                        JMCDetail.AddPersonnelSource(Database::"G/L Entry", jmcEntry."Entry No.", jmcEntry."Posting Date", jmcEntry."Document No.", jmcResource."No.", jmcEntry.Description, '', jmcEntry.Amount, 0);
                    end;
                end;
            until jmcEntry.Next() = 0;
        ReadAssemblyPersonnel(jmcStartingDate, jmcEndingDate, jmcDirect);
        ReadEventPersonnel(jmcStartingDate, jmcEndingDate, jmcDirect);
        if jmcFixed < 0 then
            Error(jmcNegativeCostErr, jmcCostModel.FieldCaption("JMC Fixed Resource Cost"), jmcFixed);
        if jmcDirect[1] < 0 then
            Error(jmcNegativeCostErr, 'CATERING', jmcDirect[1]);
        if jmcDirect[2] < 0 then
            Error(jmcNegativeCostErr, 'ALIMENTACION', jmcDirect[2]);
        jmcCostModel."JMC Fixed Resource Cost" := RoundAmount(jmcFixed);
        jmcCostModel."JMC Catering Direct Personnel" := RoundAmount(jmcDirect[1]);
        jmcCostModel."JMC Industry Direct Personnel" := RoundAmount(jmcDirect[2]);
        jmcCostModel."JMC Personnel Sources Ready" := true;
    end;

    local procedure ReadAssemblyPersonnel(jmcStartingDate: Date; jmcEndingDate: Date; var jmcDirect: array[2] of Decimal)
    var
        jmcHeader: Record "Assembly Header";
        jmcLine: Record "Assembly Line";
        jmcPostedHeader: Record "Posted Assembly Header";
        jmcPostedLine: Record "Posted Assembly Line";
        jmcResource: Record Resource;
        jmcAmount: Decimal;
    begin
        jmcPostedHeader.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
        jmcPostedHeader.SetRange(Reversed, false);
        if jmcPostedHeader.FindSet() then
            repeat
                jmcPostedLine.SetRange("Document No.", jmcPostedHeader."No.");
                jmcPostedLine.SetRange(Type, jmcPostedLine.Type::Resource);
                if jmcPostedLine.FindSet() then
                    repeat
                        jmcResource.Get(jmcPostedLine."No.");
                        jmcResource.TestField("JMC Cost Type");
                        if (jmcResource."JMC Cost Type" <> jmcResource."JMC Cost Type"::Fixed) and (jmcPostedLine."Cost Amount" <> 0) then begin
                            jmcDirect[2] += jmcPostedLine."Cost Amount";
                            JMCDetail.AddPersonnelSource(Database::"Posted Assembly Line", jmcPostedLine."Line No.", jmcPostedHeader."Posting Date", jmcPostedHeader."No.", jmcResource."No.", jmcPostedLine.Description, 'ALIMENTACION', jmcPostedLine."Cost Amount", jmcPostedLine.Quantity);
                        end;
                    until jmcPostedLine.Next() = 0;
            until jmcPostedHeader.Next() = 0;
        jmcHeader.SetRange("Document Type", jmcHeader."Document Type"::Order);
        jmcHeader.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
        if jmcHeader.FindSet() then
            repeat
                jmcLine.SetRange("Document Type", jmcHeader."Document Type");
                jmcLine.SetRange("Document No.", jmcHeader."No.");
                jmcLine.SetRange(Type, jmcLine.Type::Resource);
                if jmcLine.FindSet() then
                    repeat
                        jmcResource.Get(jmcLine."No.");
                        jmcResource.TestField("JMC Cost Type");
                        jmcAmount := jmcLine."Remaining Quantity" * jmcLine."Unit Cost";
                        if (jmcResource."JMC Cost Type" <> jmcResource."JMC Cost Type"::Fixed) and (jmcAmount <> 0) then begin
                            jmcDirect[2] += jmcAmount;
                            JMCDetail.AddPersonnelSource(Database::"Assembly Line", jmcLine."Line No.", jmcHeader."Posting Date", jmcHeader."No.", jmcResource."No.", jmcLine.Description, 'ALIMENTACION', jmcAmount, jmcLine."Remaining Quantity");
                        end;
                    until jmcLine.Next() = 0;
            until jmcHeader.Next() = 0;
    end;

    local procedure ReadEventPersonnel(jmcStartingDate: Date; jmcEndingDate: Date; var jmcDirect: array[2] of Decimal)
    var
        jmcEvent: Record Evento;
        jmcAssignment: Record "Asignacion Recursos Eventos";
        jmcResource: Record Resource;
        jmcAmount: Decimal;
    begin
        jmcEvent.SetRange("Fecha Evento", jmcStartingDate, jmcEndingDate);
        jmcEvent.SetFilter(Estado, '<>%1&<>%2&<>%3', jmcEvent.Estado::Presupuesto, jmcEvent.Estado::Rechazado, jmcEvent.Estado::Anulado);
        if jmcEvent.FindSet() then
            repeat
                jmcAssignment.SetRange("Codigo Evento", jmcEvent."Codigo Evento");
                if jmcAssignment.FindSet() then
                    repeat
                        jmcResource.Get(jmcAssignment."Codigo Recurso");
                        jmcResource.TestField("JMC Cost Type");
                        jmcAmount := jmcAssignment.Cantidad * jmcAssignment."Coste Unitario";
                        if (jmcResource."JMC Cost Type" <> jmcResource."JMC Cost Type"::Fixed) and (jmcAmount <> 0) then begin
                            jmcDirect[1] += jmcAmount;
                            JMCDetail.AddPersonnelSource(Database::"Asignacion Recursos Eventos", jmcAssignment."Linea Recurso Evento", jmcEvent."Fecha Evento", jmcEvent."Codigo Evento", jmcResource."No.", jmcAssignment.Descripcion, 'CATERING', jmcAmount, jmcAssignment.Cantidad);
                        end;
                    until jmcAssignment.Next() = 0;
            until jmcEvent.Next() = 0;
    end;

    local procedure LoadLines(jmcModelCode: Code[20])
    var
        jmcLine: Record "JMC Cost Model Line";
        jmcNoItemsErr: Label 'There are no unblocked items to include in the cost model.', Comment = 'ESP="No hay productos no bloqueados para incluir en el modelo de costes."';
    begin
        jmcLine.LockTable();
        jmcLine.SetRange("JMC Model Code", jmcModelCode);
        if not jmcLine.FindSet() then
            Error(jmcNoItemsErr);
        repeat
            JMCTempLines := jmcLine;
            JMCTempLines.Insert(false);
        until jmcLine.Next() = 0;
    end;

    [CommitBehavior(CommitBehavior::Error)]
    local procedure SynchronizeProducts(jmcModelCode: Code[20]; jmcStartingDate: Date; jmcEndingDate: Date)
    var
        jmcModel: Record "JMC Cost Model";
        jmcLine: Record "JMC Cost Model Line";
        jmcItem: Record Item;
        jmcLastLineNo: Integer;
        jmcMethod: Enum "JMC Cost Allocation Method";
    begin
        ReadSalesQuantities(jmcStartingDate, jmcEndingDate);
        jmcModel.LockTable();
        jmcModel.Get(jmcModelCode);
        jmcLine.LockTable();
        jmcLine.SetRange("JMC Model Code", jmcModelCode);
        // Removes rows of the retired recipe calculation; the model only calculates against products.
        jmcLine.SetFilter("JMC Allocation Method", '<>%1', jmcMethod::Sales);
        jmcLine.DeleteAll(true);
        jmcLine.SetRange("JMC Allocation Method");
        if jmcLine.FindSet(true) then
            repeat
                if not jmcItem.Get(jmcLine."JMC Item No.") then
                    jmcLine.Delete(true)
                else
                    if jmcItem.Blocked then
                        jmcLine.Delete(true);
            until jmcLine.Next() = 0;
        if jmcLine.FindLast() then
            jmcLastLineNo := jmcLine."JMC Line No.";
        if jmcLine.FindSet(true) then
            repeat
                jmcItem.Get(jmcLine."JMC Item No.");
                if jmcLine."JMC Unit of Measure Code" <> jmcItem."Base Unit of Measure" then
                    jmcLine.Delete(true);
            until jmcLine.Next() = 0;
        jmcItem.SetRange(Blocked, false);
        if jmcItem.FindSet() then
            repeat
                EnsureLine(jmcModelCode, jmcItem, jmcItem."Base Unit of Measure", jmcMethod::Sales, jmcLastLineNo);
            until jmcItem.Next() = 0;
    end;

    local procedure ReadSalesQuantities(jmcStartingDate: Date; jmcEndingDate: Date)
    var
        jmcEntry: Record "Item Ledger Entry";
    begin
        jmcEntry.SetRange("Entry Type", jmcEntry."Entry Type"::Sale);
        jmcEntry.SetRange("Posting Date", jmcStartingDate, jmcEndingDate);
        jmcEntry.SetFilter(Quantity, '<>%1', 0);
        jmcEntry.SetLoadFields("Item No.", Quantity);
        if jmcEntry.FindSet() then
            repeat
                if JMCSalesBaseTotals.ContainsKey(jmcEntry."Item No.") then
                    JMCSalesBaseTotals.Set(jmcEntry."Item No.", JMCSalesBaseTotals.Get(jmcEntry."Item No.") - jmcEntry.Quantity)
                else
                    JMCSalesBaseTotals.Add(jmcEntry."Item No.", -jmcEntry.Quantity);
            until jmcEntry.Next() = 0;
    end;

    local procedure EnsureLine(jmcModelCode: Code[20]; jmcItem: Record Item; jmcUnitCode: Code[10]; jmcMethod: Enum "JMC Cost Allocation Method"; var jmcLastLineNo: Integer)
    var
        jmcLine: Record "JMC Cost Model Line";
    begin
        jmcLine.SetRange("JMC Model Code", jmcModelCode);
        jmcLine.SetRange("JMC Item No.", jmcItem."No.");
        jmcLine.SetRange("JMC Allocation Method", jmcMethod);
        jmcLine.SetRange("JMC Unit of Measure Code", jmcUnitCode);
        if not jmcLine.IsEmpty() then
            exit;
        jmcLine.Reset();
        jmcLine.Init();
        jmcLastLineNo += 10000;
        jmcLine."JMC Model Code" := jmcModelCode;
        jmcLine."JMC Line No." := jmcLastLineNo;
        jmcLine."JMC Item No." := jmcItem."No.";
        jmcLine."JMC Item Description" := jmcItem.Description;
        jmcLine."JMC Unit of Measure Code" := jmcUnitCode;
        jmcLine."JMC Allocation Method" := jmcMethod;
        jmcLine.Insert(true);
    end;

    local procedure PrepareBases()
    begin
        JMCTempLines.Reset();
        JMCTempLines.FindSet();
        repeat
            PrepareLine();
            JMCTempLines."JMC Source Calculation Issue" := JMCTempLines."JMC Calculation Issue";
            JMCTempLines."JMC Production Inputs Ready" := true;
            SetProductionEligibility();
            JMCTempLines.Modify(false);
        until JMCTempLines.Next() = 0;
        BuildBases();
    end;

    local procedure PrepareLine()
    var
        jmcItem: Record Item;
        jmcStructureRecipes: Codeunit "JMC Structure Recipe Costs";
        jmcStructurePercentage: Boolean;
        jmcStructureValue: Decimal;
        jmcNegativeC01Lbl: Label 'The recipe structure cost C01 cannot be negative.', Comment = 'ESP="El coste de estructura C01 de la receta no puede ser negativo."';
        jmcMissingC01Lbl: Label 'The recipe is missing structure cost C01.', Comment = 'ESP="Falta el coste de estructura C01 en la receta."';
        jmcBusinessIssueLbl: Label 'The item''s business could not be identified.', Comment = 'ESP="No se ha podido identificar el negocio del producto."';
        jmcUnitIssueLbl: Label 'Review the item quantities and unit of measure.', Comment = 'ESP="Revise las cantidades y la unidad de medida del producto."';
    begin
        Clear(JMCTempLines."JMC Calculation Issue");
        JMCTempLines."JMC Allocation Eligible" := false;
        JMCTempLines."JMC Recipe BOM Cost" := 0;
        JMCTempLines."JMC Net Sales Quantity" := 0;
        JMCTempLines."JMC Net Sales Base Qty." := 0;
        JMCTempLines."JMC Applied Priority Factor" := 0;
        JMCTempLines."JMC Assigned Industrial Cost" := 0;
        JMCTempLines."JMC Assigned Management Cost" := 0;
        JMCTempLines."JMC Assigned Personnel Cost" := 0;
        JMCTempLines."JMC Industrial Cost" := 0;
        JMCTempLines."JMC Management Cost" := 0;
        JMCTempLines."JMC Personnel Cost" := 0;
        JMCTempLines."JMC Cost Value Type" := JMCTempLines."JMC Cost Value Type"::Amount;
        JMCTempLines."JMC Final Cost" := 0;
        JMCTempLines."JMC Cost Difference" := 0;
        JMCTempLines."JMC Manual Totals Ready" := false;
        JMCTempLines."JMC Structure Totals Ready" := false;
        jmcItem.Get(JMCTempLines."JMC Item No.");
        JMCTempLines."JMC Item Description" := jmcItem.Description;
        JMCTempLines."JMC Actual Production Qty." := 0;
        JMCTempLines."JMC Theoretical Production Qty." := 0;
        JMCTempLines."JMC Production Unit Factor" := 1;
        if JMCSalesBaseTotals.ContainsKey(jmcItem."No.") then begin
            JMCTempLines."JMC Net Sales Quantity" := JMCSalesBaseTotals.Get(jmcItem."No.");
            JMCTempLines."JMC Net Sales Base Qty." := JMCTempLines."JMC Net Sales Quantity";
        end;
        if JMCProductionQuantities.ContainsKey(jmcItem."No.") then
            JMCTempLines."JMC Actual Production Qty." := JMCProductionQuantities.Get(jmcItem."No.");
        JMCTempLines."JMC Theoretical Production Qty." := JMCTempLines."JMC Actual Production Qty.";
        if not jmcStructureRecipes.GetStructureCost(jmcItem."No.", jmcStructurePercentage, jmcStructureValue) then begin
            JMCTempLines."JMC Calculation Issue" := jmcMissingC01Lbl;
            exit;
        end;
        if jmcStructurePercentage then
            JMCTempLines."JMC Cost Value Type" := JMCTempLines."JMC Cost Value Type"::Percentage;
        if jmcStructureValue < 0 then begin
            JMCTempLines."JMC Calculation Issue" := jmcNegativeC01Lbl;
            exit;
        end;
        if not JMCRecipeCosts.ContainsKey(jmcItem."No.") then
            ReadItemRecipe(jmcItem);
        if JMCTempLines."JMC Unit of Measure Code" = jmcItem."Base Unit of Measure" then
            JMCTempLines."JMC Recipe BOM Cost" := JMCRecipeCosts.Get(jmcItem."No.");
        if (JMCTempLines."JMC Unit of Measure Code" = '') or (JMCTempLines."JMC Production Unit Factor" <= 0) then begin
            JMCTempLines."JMC Calculation Issue" := jmcUnitIssueLbl;
            exit;
        end;
        JMCTempLines."JMC Recipe BOM Cost" := JMCRecipeCosts.Get(jmcItem."No.") * JMCTempLines."JMC Production Unit Factor";
        if jmcStructureRecipes.GetItemBusiness(jmcItem."No.") = 0 then begin
            JMCTempLines."JMC Calculation Issue" := jmcBusinessIssueLbl;
            exit;
        end;
        if JMCItemIssues.Get(jmcItem."No.") <> '' then begin
            JMCTempLines."JMC Calculation Issue" := JMCItemIssues.Get(jmcItem."No.");
            exit;
        end;
        // The final manual cost is the one set in recipe cost C01, per line unit when it is an amount.
        if jmcStructurePercentage then
            JMCTempLines."JMC Final Cost" := jmcStructureValue
        else
            JMCTempLines."JMC Final Cost" := jmcStructureValue * JMCTempLines."JMC Production Unit Factor";
        JMCTempLines."JMC Allocation Eligible" := true;
    end;

    local procedure SetProductionEligibility()
    var
        jmcNoProductionLbl: Label 'Production quantity must be positive to allocate costs.', Comment = 'ESP="La cantidad de fabricación debe ser positiva para repartir costes."';
    begin
        JMCTempLines."JMC Assigned Industrial Cost" := 0;
        JMCTempLines."JMC Assigned Management Cost" := 0;
        JMCTempLines."JMC Assigned Personnel Cost" := 0;
        JMCTempLines."JMC Industrial Cost" := 0;
        JMCTempLines."JMC Management Cost" := 0;
        JMCTempLines."JMC Personnel Cost" := 0;
        JMCTempLines."JMC Allocation Eligible" := JMCTempLines."JMC Calculation Issue" = '';
        if JMCTempLines."JMC Allocation Eligible" and (JMCTempLines."JMC Theoretical Production Qty." <= 0) then begin
            JMCTempLines."JMC Calculation Issue" := jmcNoProductionLbl;
            JMCTempLines."JMC Allocation Eligible" := false;
        end;
    end;

    local procedure BuildBases()
    var
        jmcBusiness: Integer;
        jmcGroupKey: Text;
        jmcRecipeValue: Decimal;
    begin
        JMCTempLines.Reset();
        JMCTempLines.FindSet();
        repeat
            if JMCTempLines."JMC Allocation Eligible" then begin
                jmcBusiness := BusinessIndex(JMCTempLines."JMC Item No.");
                jmcRecipeValue := JMCTempLines."JMC Theoretical Production Qty." * JMCTempLines."JMC Recipe BOM Cost";
                jmcGroupKey := SalesGroupKey(jmcBusiness, JMCTempLines."JMC Unit of Measure Code");
                if not JMCSalesGroupRecipeBases.ContainsKey(jmcGroupKey) then begin
                    JMCSalesGroupRecipeBases.Add(jmcGroupKey, 0);
                    JMCSalesGroupQuantityBases.Add(jmcGroupKey, 0);
                    JMCSalesGroupKeys.Add(jmcGroupKey);
                    JMCSalesGroupCounts[jmcBusiness] += 1;
                end;
                JMCSalesGroupRecipeBases.Set(jmcGroupKey, JMCSalesGroupRecipeBases.Get(jmcGroupKey) + jmcRecipeValue);
                JMCSalesGroupQuantityBases.Set(jmcGroupKey, JMCSalesGroupQuantityBases.Get(jmcGroupKey) + JMCTempLines."JMC Theoretical Production Qty.");
                JMCBases[jmcBusiness] += jmcRecipeValue;
                JMCBusinessQuantityBases[jmcBusiness] += JMCTempLines."JMC Theoretical Production Qty." * JMCTempLines."JMC Production Unit Factor";
            end;
        until JMCTempLines.Next() = 0;
    end;

    local procedure ReadItemRecipe(var jmcItem: Record Item)
    var
        jmcRecipeCost: Decimal;
        jmcIssue: Text[250];
    begin
        jmcRecipeCost := ReadRecipeCost(jmcItem, jmcIssue);
        JMCRecipeCosts.Add(jmcItem."No.", jmcRecipeCost);
        JMCItemIssues.Add(jmcItem."No.", jmcIssue);
    end;

    local procedure ReadRecipeCost(var jmcItem: Record Item; var jmcIssue: Text[250]): Decimal
    var
        jmcBOM: Record "BOM Component";
        jmcUnit: Record "Item Unit of Measure";
        jmcComponent: Record Item;
        jmcResource: Record Resource;
        jmcAssemblyInfo: Codeunit AlxiaAssemblyInfoManagement;
        jmcRecipeCost: Decimal;
        jmcRecipeErr: Label 'The recipe for item %1 does not have a valid cost.', Comment = 'ESP="La receta del producto %1 no tiene un coste válido."';
        jmcBaseIssueLbl: Label 'Review the item base unit of measure.', Comment = 'ESP="Revise la unidad de medida base del producto."';
        jmcBOMIssueLbl: Label 'Review recipe component %1.', Comment = 'ESP="Revise el componente %1 de la receta."';
    begin
        if not jmcUnit.Get(jmcItem."No.", jmcItem."Base Unit of Measure") then begin
            jmcIssue := jmcBaseIssueLbl;
            exit(0);
        end;
        if (jmcItem."Base Unit of Measure" = '') or (jmcUnit."Qty. per Unit of Measure" <> 1) then begin
            jmcIssue := jmcBaseIssueLbl;
            exit(0);
        end;
        jmcBOM.SetRange("Parent Item No.", jmcItem."No.");
        jmcBOM.SetRange(Maquila, false);
        if jmcBOM.FindSet() then
            repeat
                case jmcBOM.Type of
                    jmcBOM.Type::Item:
                        begin
                            if not jmcComponent.Get(jmcBOM."No.") then begin
                                jmcIssue := StrSubstNo(jmcBOMIssueLbl, jmcBOM."No.");
                                exit(0);
                            end;
                            if not jmcUnit.Get(jmcBOM."No.", jmcBOM."Unit of Measure Code") then begin
                                jmcIssue := StrSubstNo(jmcBOMIssueLbl, jmcBOM."No.");
                                exit(0);
                            end;
                            if (jmcBOM."Unit of Measure Code" = '') or (jmcUnit."Qty. per Unit of Measure" <= 0) then begin
                                jmcIssue := StrSubstNo(jmcBOMIssueLbl, jmcBOM."No.");
                                exit(0);
                            end;
                        end;
                    jmcBOM.Type::Resource:
                        if not jmcResource.Get(jmcBOM."No.") then begin
                            jmcIssue := StrSubstNo(jmcBOMIssueLbl, jmcBOM."No.");
                            exit(0);
                        end;
                end;
            until jmcBOM.Next() = 0;
        jmcRecipeCost := jmcAssemblyInfo.CalcItemCosteCalculado(jmcItem, true);
        if jmcRecipeCost <= 0 then begin
            jmcIssue := StrSubstNo(jmcRecipeErr, jmcItem."No.");
            exit(0);
        end;
        exit(jmcRecipeCost);
    end;

    local procedure AllocateFunds(var jmcCostModel: Record "JMC Cost Model")
    var
        jmcFunds: array[2, 2] of Decimal;
        jmcRemaining: array[2, 2] of Decimal;
        jmcTotalIndustrial: Decimal;
        jmcTotalManagement: Decimal;
        jmcIndustrial: Decimal;
        jmcManagement: Decimal;
        jmcKey: Text;
        jmcBusiness: Integer;
    begin
        jmcTotalIndustrial := jmcCostModel."JMC Fixed Industrial Fund";
        jmcTotalManagement := jmcCostModel."JMC Fixed Management Fund";
        jmcFunds[1, 1] := RoundAmount(jmcTotalIndustrial * jmcCostModel."JMC Catering Structure Pct." / 100);
        jmcFunds[2, 1] := jmcTotalIndustrial - jmcFunds[1, 1];
        // Keep the category split consistent with the header's rounded business totals.
        jmcFunds[1, 2] := jmcCostModel."JMC Catering Allocation" - jmcFunds[1, 1];
        jmcFunds[2, 2] := jmcTotalManagement - jmcFunds[1, 2];
        JMCDetail.AddBusinessFund(1, 1, jmcTotalIndustrial, jmcCostModel."JMC Catering Structure Pct.", 'A * B / 100', jmcTotalIndustrial * jmcCostModel."JMC Catering Structure Pct." / 100, jmcFunds[1, 1]);
        JMCDetail.AddBusinessFund(2, 1, jmcTotalIndustrial, jmcFunds[1, 1], 'A - B', jmcFunds[2, 1], jmcFunds[2, 1]);
        JMCDetail.AddBusinessFund(1, 2, jmcCostModel."JMC Catering Allocation", jmcFunds[1, 1], 'A - B', jmcFunds[1, 2], jmcFunds[1, 2]);
        JMCDetail.AddBusinessFund(2, 2, jmcTotalManagement, jmcFunds[1, 2], 'A - B', jmcFunds[2, 2], jmcFunds[2, 2]);
        for jmcBusiness := 1 to 2 do begin
            if JMCBases[jmcBusiness] <= 0 then begin
                JMCDetail.AddPending(jmcBusiness, jmcFunds[jmcBusiness, 1], jmcFunds[jmcBusiness, 2]);
                JMCPendingFunds[1] += jmcFunds[jmcBusiness, 1];
                JMCPendingFunds[2] += jmcFunds[jmcBusiness, 2];
            end;
            jmcRemaining[jmcBusiness, 1] := jmcFunds[jmcBusiness, 1];
            jmcRemaining[jmcBusiness, 2] := jmcFunds[jmcBusiness, 2];
        end;
        foreach jmcKey in JMCSalesGroupKeys do begin
            if CopyStr(jmcKey, 1, 1) = '1' then
                jmcBusiness := 1
            else
                jmcBusiness := 2;
            if JMCSalesGroupCounts[jmcBusiness] = 1 then begin
                jmcIndustrial := jmcRemaining[jmcBusiness, 1];
                jmcManagement := jmcRemaining[jmcBusiness, 2];
            end else begin
                jmcIndustrial := RoundAmount(jmcFunds[jmcBusiness, 1] * JMCSalesGroupRecipeBases.Get(jmcKey) / JMCBases[jmcBusiness]);
                jmcManagement := RoundAmount(jmcFunds[jmcBusiness, 2] * JMCSalesGroupRecipeBases.Get(jmcKey) / JMCBases[jmcBusiness]);
                jmcIndustrial := Minimum(jmcIndustrial, jmcRemaining[jmcBusiness, 1]);
                jmcManagement := Minimum(jmcManagement, jmcRemaining[jmcBusiness, 2]);
            end;
            JMCDetail.AddUnitGroup(jmcBusiness, CopyStr(jmcKey, 3, 10), JMCSalesGroupRecipeBases.Get(jmcKey), JMCBases[jmcBusiness], jmcFunds[jmcBusiness, 1], jmcFunds[jmcBusiness, 2], jmcIndustrial, jmcManagement);
            AllocateLines(jmcBusiness, CopyStr(jmcKey, 3, 10), jmcIndustrial, jmcManagement);
            jmcRemaining[jmcBusiness, 1] -= jmcIndustrial;
            jmcRemaining[jmcBusiness, 2] -= jmcManagement;
            JMCSalesGroupCounts[jmcBusiness] -= 1;
        end;
        jmcCostModel."JMC Sales Pending Industrial" := JMCPendingFunds[1];
        jmcCostModel."JMC Sales Pending Management" := JMCPendingFunds[2];
        AllocateResourceCosts(jmcCostModel);
    end;

    local procedure AllocateResourceCosts(var jmcCostModel: Record "JMC Cost Model")
    var
        jmcResourceFunds: array[2] of Decimal;
        jmcBusiness: Integer;
        jmcPending: Decimal;
    begin
        jmcCostModel."JMC Catering Resource Pct." := jmcCostModel."JMC Catering Structure Pct.";
        jmcCostModel."JMC Industry Resource Pct." := jmcCostModel."JMC Industry Structure Pct.";
        jmcResourceFunds[1] := RoundAmount(jmcCostModel."JMC Fixed Resource Cost" * jmcCostModel."JMC Catering Structure Pct." / 100);
        jmcResourceFunds[2] := jmcCostModel."JMC Fixed Resource Cost" - jmcResourceFunds[1];
        jmcResourceFunds[1] += jmcCostModel."JMC Catering Direct Personnel";
        jmcResourceFunds[2] += jmcCostModel."JMC Industry Direct Personnel";
        jmcCostModel."JMC Catering Resource Allocation" := jmcResourceFunds[1];
        jmcCostModel."JMC Industry Resource Allocation" := jmcResourceFunds[2];
        jmcCostModel."JMC Resource Cost Pending" := 0;
        JMCDetail.AddPersonnelBusinessFund(1, jmcCostModel."JMC Fixed Resource Cost", jmcCostModel."JMC Catering Structure Pct.", jmcCostModel."JMC Catering Direct Personnel", jmcResourceFunds[1]);
        JMCDetail.AddPersonnelBusinessFund(2, jmcCostModel."JMC Fixed Resource Cost", jmcCostModel."JMC Catering Structure Pct.", jmcCostModel."JMC Industry Direct Personnel", jmcResourceFunds[2]);
        for jmcBusiness := 1 to 2 do
            if jmcResourceFunds[jmcBusiness] <> 0 then
                if JMCBusinessQuantityBases[jmcBusiness] > 0 then
                    AllocateResourceLines(jmcBusiness, jmcResourceFunds[jmcBusiness])
                else begin
                    jmcPending += jmcResourceFunds[jmcBusiness];
                    JMCDetail.AddResourcePending(jmcBusiness, jmcResourceFunds[jmcBusiness]);
                end;
        jmcCostModel."JMC Resource Cost Pending" := jmcPending;
    end;

    local procedure AllocateResourceLines(jmcBusiness: Integer; jmcResourceFund: Decimal)
    var
        jmcRemaining: Decimal;
        jmcWeight: Decimal;
        jmcAssigned: Decimal;
        jmcCount: Integer;
    begin
        JMCTempLines.Reset();
        JMCTempLines.SetRange("JMC Allocation Eligible", true);
        JMCTempLines.SetRange("JMC Allocation Method", JMCTempLines."JMC Allocation Method"::Sales);
        JMCTempLines.SetFilter("JMC Item No.", JMCStructureRecipes.GetBusinessItemFilter(jmcBusiness));
        jmcCount := JMCTempLines.Count();
        jmcRemaining := jmcResourceFund;
        if JMCTempLines.FindSet() then
            repeat
                jmcWeight := JMCTempLines."JMC Theoretical Production Qty." * JMCTempLines."JMC Production Unit Factor";
                if jmcCount = 1 then
                    jmcAssigned := jmcRemaining
                else begin
                    jmcAssigned := RoundAmount(jmcResourceFund * jmcWeight / JMCBusinessQuantityBases[jmcBusiness]);
                    jmcAssigned := Minimum(jmcAssigned, jmcRemaining);
                end;
                JMCTempLines."JMC Assigned Personnel Cost" := jmcAssigned;
                JMCTempLines."JMC Personnel Cost" := jmcAssigned / JMCTempLines."JMC Theoretical Production Qty.";
                JMCDetail.AddResourceAllocation(JMCTempLines, jmcBusiness, jmcWeight, JMCBusinessQuantityBases[jmcBusiness], jmcResourceFund, jmcAssigned);
                JMCTempLines.Modify(false);
                jmcRemaining -= jmcAssigned;
                jmcCount -= 1;
            until JMCTempLines.Next() = 0;
    end;

    local procedure AllocateLines(jmcBusiness: Integer; jmcUnitCode: Code[10]; jmcIndustrialFund: Decimal; jmcManagementFund: Decimal)
    var
        jmcBase: Decimal;
        jmcWeight: Decimal;
        jmcRemainingIndustrial: Decimal;
        jmcRemainingManagement: Decimal;
        jmcIndustrial: Decimal;
        jmcManagement: Decimal;
        jmcCount: Integer;
    begin
        JMCTempLines.Reset();
        JMCTempLines.SetRange("JMC Allocation Eligible", true);
        JMCTempLines.SetRange("JMC Allocation Method", JMCTempLines."JMC Allocation Method"::Sales);
        JMCTempLines.SetFilter("JMC Item No.", JMCStructureRecipes.GetBusinessItemFilter(jmcBusiness));
        JMCTempLines.SetRange("JMC Unit of Measure Code", jmcUnitCode);
        jmcBase := JMCSalesGroupQuantityBases.Get(SalesGroupKey(jmcBusiness, jmcUnitCode));
        jmcCount := JMCTempLines.Count();
        jmcRemainingIndustrial := jmcIndustrialFund;
        jmcRemainingManagement := jmcManagementFund;
        if JMCTempLines.FindSet() then
            repeat
                jmcWeight := JMCTempLines."JMC Theoretical Production Qty.";
                if jmcCount = 1 then begin
                    jmcIndustrial := jmcRemainingIndustrial;
                    jmcManagement := jmcRemainingManagement;
                end else begin
                    jmcIndustrial := RoundAmount(jmcIndustrialFund * jmcWeight / jmcBase);
                    jmcManagement := RoundAmount(jmcManagementFund * jmcWeight / jmcBase);
                    jmcIndustrial := Minimum(jmcIndustrial, jmcRemainingIndustrial);
                    jmcManagement := Minimum(jmcManagement, jmcRemainingManagement);
                end;
                JMCTempLines."JMC Assigned Industrial Cost" := jmcIndustrial;
                JMCTempLines."JMC Assigned Management Cost" := jmcManagement;
                JMCTempLines."JMC Industrial Cost" := jmcIndustrial / JMCTempLines."JMC Theoretical Production Qty.";
                JMCTempLines."JMC Management Cost" := jmcManagement / JMCTempLines."JMC Theoretical Production Qty.";
                JMCDetail.AddAllocation(JMCTempLines, jmcWeight, jmcBase, jmcIndustrialFund, jmcManagementFund, JMCRecipeCosts.Get(JMCTempLines."JMC Item No."));
                JMCTempLines.Modify(false);
                jmcRemainingIndustrial -= jmcIndustrial;
                jmcRemainingManagement -= jmcManagement;
                jmcCount -= 1;
            until JMCTempLines.Next() = 0;
    end;

    local procedure RoundAmount(jmcAmount: Decimal): Decimal
    begin
        exit(Round(jmcAmount, 0.01));
    end;

    local procedure SalesGroupKey(jmcBusiness: Integer; jmcUnitCode: Code[10]): Text
    begin
        exit(Format(jmcBusiness, 0, 9) + ':' + jmcUnitCode);
    end;

    local procedure SaveResults(var jmcCostModel: Record "JMC Cost Model"; jmcStartingDate: Date; jmcEndingDate: Date; jmcAccountFilter: Text[250])
    var
        jmcLine: Record "JMC Cost Model Line";
    begin
        jmcCostModel."JMC Calculation Current" := false;
        jmcCostModel.Modify(false);
        JMCTempLines.Reset();
        if JMCTempLines.FindSet() then
            repeat
                if not JMCTempLines."JMC Allocation Eligible" then
                    JMCDetail.AddAllocation(JMCTempLines, 0, 0, 0, 0, 0);
                JMCTempLines.ResetFinalTotals();
                if jmcLine.Get(JMCTempLines."JMC Model Code", JMCTempLines."JMC Line No.") then begin
                    jmcLine.TransferFields(JMCTempLines, false);
                    jmcLine.Modify(true);
                end else begin
                    jmcLine.Init();
                    jmcLine.TransferFields(JMCTempLines);
                    jmcLine.Insert(true);
                end;
            until JMCTempLines.Next() = 0;
        jmcCostModel."JMC Starting Date" := jmcStartingDate;
        jmcCostModel."JMC Ending Date" := jmcEndingDate;
        jmcCostModel."JMC Account Filter" := jmcAccountFilter;
        jmcCostModel."JMC Calculated At" := CurrentDateTime();
        jmcCostModel."JMC Calculation Current" := true;
        jmcCostModel.Modify(false);
    end;

    local procedure BusinessIndex(jmcItemNo: Code[20]): Integer
    var
        jmcBusinessErr: Label 'Item %1 is not identified as CA, MP or MA (Catering), or PT, PI, PR or SER (Industry). Review the model scope; no business is assigned by default.', Comment = 'ESP="El producto %1 no se identifica como CA, MP o MA (Catering), ni PT, PI, PR o SER (Alimentación). Revise los productos del modelo; no se asigna un negocio por defecto."';
    begin
        if JMCStructureRecipes.GetItemBusiness(jmcItemNo) = 0 then
            Error(jmcBusinessErr, jmcItemNo);
        exit(JMCStructureRecipes.GetItemBusiness(jmcItemNo));
    end;

    local procedure Minimum(jmcFirst: Decimal; jmcSecond: Decimal): Decimal
    begin
        if jmcFirst < jmcSecond then
            exit(jmcFirst);
        exit(jmcSecond);
    end;

    var
        JMCTempLines: Record "JMC Cost Model Line" temporary;
        JMCDetail: Codeunit "JMC Cost Calculation Detail";
        JMCStructureRecipes: Codeunit "JMC Structure Recipe Costs";
        JMCRecipeCosts: Dictionary of [Code[20], Decimal];
        JMCItemIssues: Dictionary of [Code[20], Text];
        JMCProductionQuantities: Dictionary of [Code[20], Decimal];
        JMCSalesBaseTotals: Dictionary of [Code[20], Decimal];
        JMCBases: array[2] of Decimal;
        JMCBusinessQuantityBases: array[2] of Decimal;
        JMCSalesGroupRecipeBases: Dictionary of [Text, Decimal];
        JMCSalesGroupQuantityBases: Dictionary of [Text, Decimal];
        JMCSalesGroupKeys: List of [Text];
        JMCSalesGroupCounts: array[2] of Integer;
        JMCPendingFunds: array[2] of Decimal;
}
