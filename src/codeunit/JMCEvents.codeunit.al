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