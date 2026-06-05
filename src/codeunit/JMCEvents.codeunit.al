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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchRcptLine."JMC Purchase Order Reason Code" := PurchaseLine."JMC Purchase Order Reason Code";
        PurchRcptLine."JMC Purchase Order Method Code" := PurchaseLine."JMC Purchase Order Method Code";
        PurchRcptLine."JMC Internal Notes" := PurchaseLine."JMC Internal Notes";
        PurchRcptLine."JMC Received" := PurchaseLine."JMC Received";
        PurchRcptLine."JMC Recipe" := PurchaseLine."JMC Recipe";
        PurchRcptLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchLine: Record "Purchase Line")
    begin
        PurchInvLine."JMC Purchase Order Reason Code" := PurchLine."JMC Purchase Order Reason Code";
        PurchInvLine."JMC Purchase Order Method Code" := PurchLine."JMC Purchase Order Method Code";
        PurchInvLine."JMC Internal Notes" := PurchLine."JMC Internal Notes";
        PurchInvLine."JMC Received" := PurchLine."JMC Received";
        PurchInvLine."JMC Recipe" := PurchLine."JMC Recipe";
        PurchInvLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoLineInsert', '', false, false)]
    local procedure OnAfterPurchCrMemoLineInsert(var PurchCrMemoLine: Record "Purch. Cr. Memo Line"; var PurchLine: Record "Purchase Line")
    begin
        PurchCrMemoLine."JMC Purchase Order Reason Code" := PurchLine."JMC Purchase Order Reason Code";
        PurchCrMemoLine."JMC Purchase Order Method Code" := PurchLine."JMC Purchase Order Method Code";
        PurchCrMemoLine."JMC Internal Notes" := PurchLine."JMC Internal Notes";
        PurchCrMemoLine."JMC Received" := PurchLine."JMC Received";
        PurchCrMemoLine."JMC Recipe" := PurchLine."JMC Recipe";
        PurchCrMemoLine.Modify();
    end;
}