codeunit 53100 "JMC Events"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Account Category", 'OnGetBalanceOnAfterGetTotaling', '', false, false)]
    local procedure OnGetBalanceOnAfterGetTotaling(var GLAccountCategory: Record "G/L Account Category"; TotalingStr: Text; var Balance: Decimal; var IsHandled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        CorrectedTotaling: Text;
    begin
        if not TotalingStr.EndsWith('|') then
            exit;

        // Fix the truncated filter by removing trailing pipe
        CorrectedTotaling := TotalingStr.TrimEnd('|');

        // Calculate balance with corrected filter
        GLEntry.SetFilter("G/L Account No.", CorrectedTotaling);
        GLEntry.CalcSums(Amount);
        Balance += GLEntry.Amount;

        // Prevent standard code from executing with broken filter
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        PurchHeader: Record "Purchase Header";
    begin
        if Rec.IsTemporary() then
            exit;

        // Get header and copy custom fields to the line
        if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."JMC Purchase Order Reason Code" := PurchHeader."JMC Purchase Order Reason Code";
            Rec."JMC Purchase Order Method Code" := PurchHeader."JMC Purchase Order Method Code";
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Type', false, false)]
    local procedure OnAfterValidateTypePurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchHeader: Record "Purchase Header";
    begin
        if Rec.IsTemporary() then
            exit;

        // Reapply custom fields after Type validation (Type validation can reset fields)
        if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if Rec."JMC Purchase Order Reason Code" = '' then
                Rec."JMC Purchase Order Reason Code" := PurchHeader."JMC Purchase Order Reason Code";
            if Rec."JMC Purchase Order Method Code" = '' then
                Rec."JMC Purchase Order Method Code" := PurchHeader."JMC Purchase Order Method Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'JMC Purchase Order Reason Code', false, false)]
    local procedure OnAfterValidateReasonCodePurchHeader(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        PurchLine: Record "Purchase Line";
    begin
        if Rec.IsTemporary() then
            exit;

        // Propagate reason code to all lines when header field is validated
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindSet(true) then
            repeat
                if PurchLine."JMC Purchase Order Reason Code" <> Rec."JMC Purchase Order Reason Code" then begin
                    PurchLine."JMC Purchase Order Reason Code" := Rec."JMC Purchase Order Reason Code";
                    PurchLine.Modify(true);
                end;
            until PurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'JMC Purchase Order Method Code', false, false)]
    local procedure OnAfterValidateMethodCodePurchHeader(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        PurchLine: Record "Purchase Line";
    begin
        if Rec.IsTemporary() then
            exit;

        // Propagate method code to all lines when header field is validated
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindSet(true) then
            repeat
                if PurchLine."JMC Purchase Order Method Code" <> Rec."JMC Purchase Order Method Code" then begin
                    PurchLine."JMC Purchase Order Method Code" := Rec."JMC Purchase Order Method Code";
                    PurchLine.Modify(true);
                end;
            until PurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckAvailableCreditLimit', '', false, false)]
    local procedure OnBeforeCheckAvailableCreditLimit(var SalesHeader: Record "Sales Header"; var ReturnValue: Decimal; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Importe pedido: %4\\Total: %5\\Excedido: %6', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Importe pedido: %4\\Total: %5\\Excedido: %6"';
        OrderAmount: Decimal;
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
    begin


        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        // Verificar si tiene límite de crédito configurado
        if Customer."Credit Limit (LCY)" = 0 then
            exit;

        Customer.CalcFields("Balance (LCY)");
        SalesHeader.CalcFields("Amount Including VAT");
        OrderAmount := SalesHeader."Amount Including VAT";
        TotalAmount := Customer."Balance (LCY)" + OrderAmount;

        // Si se excede el límite, mostrar mensaje
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                Customer."Balance (LCY)",
                OrderAmount,
                TotalAmount,
                ExceededAmount);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnUpdateAmountOnBeforeCheckCreditLimit', '', false, false)]
    local procedure OnUpdateAmountOnBeforeCheckCreditLimit(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    var
        Customer: Record Customer;
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Importe pedido: %4\\Total: %5\\Excedido: %6', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Importe pedido: %4\\Total: %5\\Excedido: %6"';
        OrderAmount: Decimal;
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
    begin


        if not Customer.Get(SalesLine."Sell-to Customer No.") then
            exit;

        // Verificar si tiene límite de crédito configurado
        if Customer."Credit Limit (LCY)" = 0 then
            exit;

        Customer.CalcFields("Balance (LCY)");
        SalesLine.CalcFields("Amount Including VAT");
        OrderAmount := SalesLine."Amount Including VAT";
        TotalAmount := Customer."Balance (LCY)" + OrderAmount;

        // Si se excede el límite, mostrar mensaje
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                Customer."Balance (LCY)",
                OrderAmount,
                TotalAmount,
                ExceededAmount);
        end;
    end;
}