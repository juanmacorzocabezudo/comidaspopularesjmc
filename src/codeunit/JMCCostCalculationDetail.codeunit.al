codeunit 53108 "JMC Cost Calculation Detail"
{
    Permissions = tabledata "JMC Cost Calculation Detail" = RIMD;

    procedure Initialize(jmcSelectedModelCode: Code[20])
    begin
        JMCBuffer.Reset();
        JMCBuffer.DeleteAll(false);
        JMCModelCode := jmcSelectedModelCode;
        JMCEntryNo := 0;
        Clear(JMCAccounting);
        Clear(JMCProduction);
        Clear(JMCAllocated);
        Clear(JMCPending);
    end;

    procedure InitializeSavedSources(jmcSelectedModelCode: Code[20])
    var
        jmcSaved: Record "JMC Cost Calculation Detail";
    begin
        Initialize(jmcSelectedModelCode);
        jmcSaved.SetRange("JMC Model Code", jmcSelectedModelCode);
        jmcSaved.SetFilter("JMC Detail Type", '%1|%2', jmcSaved."JMC Detail Type"::Accounting, jmcSaved."JMC Detail Type"::Production);
        if jmcSaved.FindSet() then
            repeat
                NewDetail();
                JMCBuffer.TransferFields(jmcSaved, false);
                JMCBuffer.Insert(false);
                if jmcSaved."JMC Detail Type" = jmcSaved."JMC Detail Type"::Accounting then
                    JMCAccounting[jmcSaved."JMC Classification".AsInteger()] += jmcSaved."JMC Source Amount"
                else
                    if jmcSaved."JMC Included" then
                        JMCProduction[BusinessIndex(jmcSaved."JMC Business")] += jmcSaved."JMC Source Amount";
            until jmcSaved.Next() = 0;
    end;

    procedure SavedLineCount(jmcModelCode: Code[20]): Integer
    var
        jmcSaved: Record "JMC Cost Calculation Detail";
    begin
        jmcSaved.SetRange("JMC Model Code", jmcModelCode);
        jmcSaved.SetRange("JMC Detail Type", jmcSaved."JMC Detail Type"::Allocation);
        jmcSaved.SetRange("JMC Classification", Enum::"JMC Cost Classification".FromInteger(1));
        exit(jmcSaved.Count());
    end;

    procedure HasSavedLine(jmcLine: Record "JMC Cost Model Line"): Boolean
    var
        jmcSaved: Record "JMC Cost Calculation Detail";
    begin
        jmcSaved.SetRange("JMC Model Code", jmcLine."JMC Model Code");
        jmcSaved.SetRange("JMC Detail Type", jmcSaved."JMC Detail Type"::Allocation);
        jmcSaved.SetRange("JMC Source Entry No.", jmcLine."JMC Line No.");
        jmcSaved.SetRange("JMC Item No.", jmcLine."JMC Item No.");
        jmcSaved.SetRange("JMC Unit Code", jmcLine."JMC Unit of Measure Code");
        exit(not jmcSaved.IsEmpty());
    end;

    procedure AddAccounting(jmcEntry: Record "G/L Entry"; jmcAccount: Record "G/L Account")
    begin
        NewDetail();
        JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::Accounting;
        JMCBuffer."JMC Source Entry No." := jmcEntry."Entry No.";
        JMCBuffer."JMC Posting Date" := jmcEntry."Posting Date";
        JMCBuffer."JMC Document No." := jmcEntry."Document No.";
        JMCBuffer."JMC Account No." := jmcAccount."No.";
        JMCBuffer."JMC Classification" := jmcAccount."JMC Cost Classification";
        JMCBuffer."JMC Description" := CopyStr(jmcAccount.Name + ': ' + jmcEntry.Description, 1, MaxStrLen(JMCBuffer."JMC Description"));
        JMCBuffer."JMC Source Amount" := jmcEntry.Amount;
        JMCBuffer."JMC Raw Result" := jmcEntry.Amount;
        JMCBuffer."JMC Result" := jmcEntry.Amount;
        JMCBuffer."JMC Included" := true;
        JMCBuffer.Insert(false);
        JMCAccounting[jmcAccount."JMC Cost Classification".AsInteger()] += jmcEntry.Amount;
    end;

    procedure AddProduction(jmcEntry: Record "Item Ledger Entry"; jmcBusiness: Code[20]; jmcIncluded: Boolean; jmcIssue: Text)
    begin
        NewDetail();
        JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::Production;
        JMCBuffer."JMC Source Entry No." := jmcEntry."Entry No.";
        JMCBuffer."JMC Posting Date" := jmcEntry."Posting Date";
        JMCBuffer."JMC Document No." := jmcEntry."Document No.";
        JMCBuffer."JMC Item No." := jmcEntry."Item No.";
        JMCBuffer."JMC Unit Code" := jmcEntry."Unit of Measure Code";
        JMCBuffer."JMC Description" := jmcEntry.Description;
        JMCBuffer."JMC Business" := jmcBusiness;
        JMCBuffer."JMC Source Amount" := jmcEntry."Cost Amount (Actual)";
        JMCBuffer."JMC Quantity" := jmcEntry.Quantity;
        JMCBuffer."JMC Included" := jmcIncluded;
        JMCBuffer."JMC Issue" := CopyStr(jmcIssue, 1, MaxStrLen(JMCBuffer."JMC Issue"));
        if jmcIncluded then begin
            JMCBuffer."JMC Raw Result" := jmcEntry."Cost Amount (Actual)";
            JMCBuffer."JMC Result" := jmcEntry."Cost Amount (Actual)";
            JMCProduction[BusinessIndex(jmcBusiness)] += jmcEntry."Cost Amount (Actual)";
        end;
        JMCBuffer.Insert(false);
    end;

    procedure AddAllocation(jmcLine: Record "JMC Cost Model Line"; jmcWeight: Decimal; jmcBase: Decimal; jmcIndustrialFund: Decimal; jmcManagementFund: Decimal; jmcBaseRecipeCost: Decimal)
    var
        jmcCategory: Integer;
        jmcFunds: array[2] of Decimal;
        jmcAmounts: array[2] of Decimal;
    begin
        jmcFunds[1] := jmcIndustrialFund;
        jmcFunds[2] := jmcManagementFund;
        jmcAmounts[1] := jmcLine."JMC Assigned Industrial Cost";
        jmcAmounts[2] := jmcLine."JMC Assigned Management Cost";
        for jmcCategory := 1 to 2 do begin
            NewDetail();
            JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::Allocation;
            JMCBuffer."JMC Source Entry No." := jmcLine."JMC Line No.";
            JMCBuffer."JMC Item No." := jmcLine."JMC Item No.";
            JMCBuffer."JMC Description" := jmcLine."JMC Item Description";
            JMCBuffer."JMC Unit Code" := jmcLine."JMC Unit of Measure Code";
            JMCBuffer."JMC Quantity" := jmcLine."JMC Theoretical Production Qty.";
            JMCBuffer."JMC Base Quantity" := jmcLine."JMC Theoretical Production Qty." * jmcLine."JMC Production Unit Factor";
            JMCBuffer."JMC Base Recipe Cost" := jmcBaseRecipeCost;
            JMCBuffer."JMC Method" := jmcLine."JMC Allocation Method";
            JMCBuffer."JMC Classification" := Enum::"JMC Cost Classification".FromInteger(jmcCategory);
            JMCBuffer."JMC Included" := jmcLine."JMC Allocation Eligible";
            JMCBuffer."JMC Issue" := jmcLine."JMC Calculation Issue";
            case CopyStr(jmcLine."JMC Item No.", 1, 2) of
                'CA':
                    JMCBuffer."JMC Business" := 'CATERING';
                'PT':
                    JMCBuffer."JMC Business" := 'ALIMENTACION';
            end;
            SetCalculation(jmcWeight, jmcBase, jmcFunds[jmcCategory], 'C * A / B', 0, jmcAmounts[jmcCategory]);
            if jmcBase > 0 then begin
                JMCBuffer."JMC Raw Result" := jmcFunds[jmcCategory] * jmcWeight / jmcBase;
                JMCBuffer."JMC Rounding Difference" := jmcAmounts[jmcCategory] - JMCBuffer."JMC Raw Result";
            end;
            JMCBuffer.Insert(false);
            if jmcLine."JMC Allocation Eligible" then
                JMCAllocated[BusinessIndex(JMCBuffer."JMC Business"), jmcCategory] += jmcAmounts[jmcCategory];
        end;
    end;

    procedure AddPending(jmcBusiness: Integer; jmcIndustrial: Decimal; jmcManagement: Decimal)
    var
        jmcCategory: Integer;
        jmcAmounts: array[2] of Decimal;
        jmcNoBaseLbl: Label 'The business has no positive eligible allocation base.', Comment = 'ESP="El negocio no tiene base positiva apta para repartir."';
    begin
        jmcAmounts[1] := jmcIndustrial;
        jmcAmounts[2] := jmcManagement;
        for jmcCategory := 1 to 2 do begin
            NewDetail();
            JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::Pending;
            JMCBuffer."JMC Business" := BusinessCode(jmcBusiness);
            JMCBuffer."JMC Method" := Enum::"JMC Cost Allocation Method"::Sales;
            JMCBuffer."JMC Classification" := Enum::"JMC Cost Classification".FromInteger(jmcCategory);
            JMCBuffer."JMC Issue" := jmcNoBaseLbl;
            JMCBuffer."JMC Included" := true;
            SetCalculation(jmcAmounts[jmcCategory], 0, 0, 'A', jmcAmounts[jmcCategory], jmcAmounts[jmcCategory]);
            JMCBuffer.Insert(false);
            JMCPending[jmcBusiness, jmcCategory] := jmcAmounts[jmcCategory];
        end;
    end;

    procedure AddUnitGroup(jmcBusiness: Integer; jmcUnitCode: Code[10]; jmcRecipeValue: Decimal; jmcBusinessBase: Decimal; jmcIndustrialFund: Decimal; jmcManagementFund: Decimal; jmcIndustrial: Decimal; jmcManagement: Decimal)
    var
        jmcCategory: Integer;
        jmcFunds: array[2] of Decimal;
        jmcAmounts: array[2] of Decimal;
    begin
        jmcFunds[1] := jmcIndustrialFund;
        jmcFunds[2] := jmcManagementFund;
        jmcAmounts[1] := jmcIndustrial;
        jmcAmounts[2] := jmcManagement;
        for jmcCategory := 1 to 2 do begin
            NewDetail();
            JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::"Unit Group";
            JMCBuffer."JMC Business" := BusinessCode(jmcBusiness);
            JMCBuffer."JMC Unit Code" := jmcUnitCode;
            JMCBuffer."JMC Method" := Enum::"JMC Cost Allocation Method"::Sales;
            JMCBuffer."JMC Classification" := Enum::"JMC Cost Classification".FromInteger(jmcCategory);
            JMCBuffer."JMC Included" := true;
            SetCalculation(jmcRecipeValue, jmcBusinessBase, jmcFunds[jmcCategory], 'C * A / B', jmcFunds[jmcCategory] * jmcRecipeValue / jmcBusinessBase, jmcAmounts[jmcCategory]);
            JMCBuffer.Insert(false);
        end;
    end;

    procedure AddBusinessFund(jmcBusiness: Integer; jmcCategory: Integer; jmcA: Decimal; jmcB: Decimal; jmcFormula: Text; jmcRaw: Decimal; jmcResult: Decimal)
    begin
        NewDetail();
        JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::"Business Fund";
        JMCBuffer."JMC Business" := BusinessCode(jmcBusiness);
        JMCBuffer."JMC Classification" := Enum::"JMC Cost Classification".FromInteger(jmcCategory);
        JMCBuffer."JMC Included" := true;
        SetCalculation(jmcA, jmcB, 0, jmcFormula, jmcRaw, jmcResult);
        JMCBuffer.Insert(false);
    end;

    procedure Save(jmcModel: Record "JMC Cost Model")
    var
        jmcDetail: Record "JMC Cost Calculation Detail";
        jmcCategory: Integer;
        jmcMismatchErr: Label 'The saved breakdown does not reconcile with the calculated model. The calculation has not been saved.', Comment = 'ESP="El desglose no concilia con el modelo calculado. El cálculo no se ha guardado."';
    begin
        jmcModel.TestField("JMC Code");
        if JMCModelCode <> jmcModel."JMC Code" then
            Error(jmcMismatchErr);
        if Differs(Round(JMCAccounting[1], 0.01), jmcModel."JMC Fixed Industrial Fund") or
           Differs(Round(JMCAccounting[2], 0.01), jmcModel."JMC Fixed Management Fund") or
           Differs(JMCProduction[1], jmcModel."JMC Catering Production Cost") or
           Differs(JMCProduction[2], jmcModel."JMC Industry Production Cost")
        then
            Error(jmcMismatchErr);
        for jmcCategory := 1 to 2 do
            if Differs(JMCAllocated[1, jmcCategory] + JMCAllocated[2, jmcCategory] +
                       JMCPending[1, jmcCategory] + JMCPending[2, jmcCategory], Round(JMCAccounting[jmcCategory], 0.01))
            then
                Error(jmcMismatchErr);
        AddSummaries(jmcModel);
        jmcDetail.LockTable();
        DeleteSaved(jmcModel."JMC Code");
        JMCBuffer.Reset();
        if JMCBuffer.FindSet() then
            repeat
                jmcDetail := JMCBuffer;
                jmcDetail."JMC Calculated At" := jmcModel."JMC Calculated At";
                jmcDetail."JMC Starting Date" := jmcModel."JMC Starting Date";
                jmcDetail."JMC Ending Date" := jmcModel."JMC Ending Date";
                jmcDetail."JMC Account Filter" := jmcModel."JMC Account Filter";
                jmcDetail.Insert(false);
            until JMCBuffer.Next() = 0;
        jmcDetail.Reset();
        jmcDetail.SetRange("JMC Model Code", jmcModel."JMC Code");
        jmcDetail.SetRange("JMC Detail Type", jmcDetail."JMC Detail Type"::Formula);
        if jmcDetail.Count() <> 12 then
            Error(jmcMismatchErr);
        DeleteSaved('');
    end;

    procedure DeleteSaved(jmcModelCode: Code[20])
    var
        jmcDetail: Record "JMC Cost Calculation Detail";
    begin
        jmcDetail.SetRange("JMC Model Code", jmcModelCode);
        jmcDetail.DeleteAll(false);
    end;

    local procedure AddSummaries(jmcModel: Record "JMC Cost Model")
    begin
        AddSummary(jmcModel.FieldNo("JMC Total Structure Cost"), jmcModel."JMC Fixed Industrial Fund", jmcModel."JMC Fixed Management Fund", 'A + B', jmcModel."JMC Fixed Industrial Fund" + jmcModel."JMC Fixed Management Fund", jmcModel."JMC Total Structure Cost");
        AddSummary(jmcModel.FieldNo("JMC Fixed Industrial Fund"), JMCAccounting[1], 0, 'A', JMCAccounting[1], jmcModel."JMC Fixed Industrial Fund");
        AddSummary(jmcModel.FieldNo("JMC Fixed Management Fund"), JMCAccounting[2], 0, 'A', JMCAccounting[2], jmcModel."JMC Fixed Management Fund");
        AddSummary(jmcModel.FieldNo("JMC Catering Production Cost"), JMCProduction[1], 0, 'A', JMCProduction[1], jmcModel."JMC Catering Production Cost");
        AddSummary(jmcModel.FieldNo("JMC Industry Production Cost"), JMCProduction[2], 0, 'A', JMCProduction[2], jmcModel."JMC Industry Production Cost");
        AddSummary(jmcModel.FieldNo("JMC Catering Structure Pct."), JMCProduction[1], JMCProduction[2], 'A / (A + B) * 100', jmcModel."JMC Catering Structure Pct.", jmcModel."JMC Catering Structure Pct.");
        AddSummary(jmcModel.FieldNo("JMC Industry Structure Pct."), jmcModel."JMC Catering Structure Pct.", 0, '100 - A', 100 - jmcModel."JMC Catering Structure Pct.", jmcModel."JMC Industry Structure Pct.");
        AddSummary(jmcModel.FieldNo("JMC Catering Allocation"), jmcModel."JMC Total Structure Cost", jmcModel."JMC Catering Structure Pct.", 'A * B / 100', jmcModel."JMC Total Structure Cost" * jmcModel."JMC Catering Structure Pct." / 100, jmcModel."JMC Catering Allocation");
        AddSummary(jmcModel.FieldNo("JMC Industry Allocation"), jmcModel."JMC Total Structure Cost", jmcModel."JMC Catering Allocation", 'A - B', jmcModel."JMC Total Structure Cost" - jmcModel."JMC Catering Allocation", jmcModel."JMC Industry Allocation");
        AddSummary(jmcModel.FieldNo("JMC Production Dimension"), JMCProduction[1], JMCProduction[2], 'LINEA: CATERING | ALIMENTACION', 0, 0);
        AddSummary(jmcModel.FieldNo("JMC Sales Pending Industrial"), JMCPending[1, 1], JMCPending[2, 1], 'A + B', JMCPending[1, 1] + JMCPending[2, 1], jmcModel."JMC Sales Pending Industrial");
        AddSummary(jmcModel.FieldNo("JMC Sales Pending Management"), JMCPending[1, 2], JMCPending[2, 2], 'A + B', JMCPending[1, 2] + JMCPending[2, 2], jmcModel."JMC Sales Pending Management");
    end;

    local procedure AddSummary(jmcFieldNo: Integer; jmcA: Decimal; jmcB: Decimal; jmcFormula: Text; jmcRaw: Decimal; jmcResult: Decimal)
    begin
        NewDetail();
        JMCBuffer."JMC Detail Type" := JMCBuffer."JMC Detail Type"::Formula;
        JMCBuffer."JMC Summary Field No." := jmcFieldNo;
        SetCalculation(jmcA, jmcB, 0, jmcFormula, jmcRaw, jmcResult);
        JMCBuffer.Insert(false);
    end;

    local procedure NewDetail()
    begin
        JMCEntryNo += 1;
        JMCBuffer.Init();
        JMCBuffer."JMC Model Code" := JMCModelCode;
        JMCBuffer."JMC Entry No." := JMCEntryNo;
    end;

    local procedure SetCalculation(jmcA: Decimal; jmcB: Decimal; jmcC: Decimal; jmcFormula: Text; jmcRaw: Decimal; jmcResult: Decimal)
    begin
        JMCBuffer."JMC Operand A" := jmcA;
        JMCBuffer."JMC Operand B" := jmcB;
        JMCBuffer."JMC Operand C" := jmcC;
        JMCBuffer."JMC Formula" := CopyStr(jmcFormula, 1, MaxStrLen(JMCBuffer."JMC Formula"));
        JMCBuffer."JMC Raw Result" := jmcRaw;
        JMCBuffer."JMC Result" := jmcResult;
        JMCBuffer."JMC Rounding Difference" := jmcResult - jmcRaw;
    end;

    local procedure Differs(jmcFirst: Decimal; jmcSecond: Decimal): Boolean
    begin
        // Amounts are already rounded to 0.01; the tolerance only guards the comparison.
        exit(Abs(jmcFirst - jmcSecond) > 0.000001);
    end;

    local procedure BusinessCode(jmcBusiness: Integer): Code[20]
    begin
        if jmcBusiness = 1 then
            exit('CATERING');
        if jmcBusiness = 2 then
            exit('ALIMENTACION');
        Error(JMCBusinessErr);
    end;

    local procedure BusinessIndex(jmcBusiness: Code[20]): Integer
    begin
        case jmcBusiness of
            'CATERING':
                exit(1);
            'ALIMENTACION':
                exit(2);
        end;
        Error(JMCBusinessErr);
    end;

    var
        JMCBuffer: Record "JMC Cost Calculation Detail" temporary;
        JMCModelCode: Code[20];
        JMCEntryNo: Integer;
        JMCAccounting: array[2] of Decimal;
        JMCProduction: array[2] of Decimal;
        JMCAllocated: array[2, 2] of Decimal;
        JMCPending: array[2, 2] of Decimal;
        JMCBusinessErr: Label 'The breakdown business must be CATERING or ALIMENTACION.', Comment = 'ESP="El negocio del desglose debe ser CATERING o ALIMENTACION."';
}
