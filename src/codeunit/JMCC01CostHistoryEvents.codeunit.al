codeunit 53109 "JMC C01 Cost History Events"
{
    Permissions = tabledata "JMC C01 Cost History" = RM;

    [EventSubscriber(ObjectType::Table, Database::"BOM Aditional Cost", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCost(var Rec: Record "BOM Aditional Cost"; var xRec: Record "BOM Aditional Cost"; RunTrigger: Boolean)
    var
        jmcHistory: Record "JMC C01 Cost History";
    begin
        if Rec.IsTemporary() or (Rec."No. Cost" <> 'C01') or (Rec."BOM Version" <> 0) then
            exit;
        jmcHistory.LockTable();
        jmcHistory.SetRange("JMC Item No.", Rec."Item No");
        jmcHistory.SetRange("JMC Cost Fixed", true);
        if jmcHistory.FindSet(true) then
            repeat
                if (jmcHistory."JMC Cost Value" <> Rec.Value) or Rec."Apply on all cost" or
                   ((jmcHistory."JMC Cost Type" = jmcHistory."JMC Cost Type"::Percentage) <> (Rec."Type Coste" = Rec."Type Coste"::"%"))
                then begin
                    jmcHistory."JMC Cost Fixed" := false;
                    jmcHistory.Modify(false);
                end;
            until jmcHistory.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"BOM Aditional Cost", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteCost(var Rec: Record "BOM Aditional Cost"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() or (Rec."No. Cost" <> 'C01') or (Rec."BOM Version" <> 0) then
            exit;
        ClearFixedHistory(Rec."Item No");
    end;

    [EventSubscriber(ObjectType::Table, Database::"BOM Aditional Cost", 'OnAfterRenameEvent', '', false, false)]
    local procedure OnAfterRenameCost(var Rec: Record "BOM Aditional Cost"; var xRec: Record "BOM Aditional Cost"; RunTrigger: Boolean)
    begin
        if xRec.IsTemporary() or (xRec."No. Cost" <> 'C01') or (xRec."BOM Version" <> 0) then
            exit;
        ClearFixedHistory(xRec."Item No");
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
}
