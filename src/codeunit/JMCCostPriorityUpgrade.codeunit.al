codeunit 53106 "JMC Cost Priority Upgrade"
{
    Subtype = Upgrade;
    Permissions = tabledata "JMC Cost Model Line" = rm;

    trigger OnUpgradePerCompany()
    var
        jmcInstall: Codeunit "JMC Cost Priority Install";
    begin
        jmcInstall.InitializeResourceCostPercentages();
        jmcInstall.InvalidateDirectPersonnelSources();
        jmcInstall.InvalidateExpandedItemAllocation();
        UpdateCostDifferences();
    end;

    local procedure UpdateCostDifferences()
    var
        jmcLine: Record "JMC Cost Model Line";
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcPreviousDifference: Decimal;
        jmcDifferenceTagLbl: Label 'JMC-CostDifferenceSign-20261124', Locked = true;
    begin
        if jmcUpgradeTag.HasUpgradeTag(jmcDifferenceTagLbl) then
            exit;

        if jmcLine.FindSet(true) then
            repeat
                jmcPreviousDifference := jmcLine."JMC Cost Difference";
                jmcLine.RecalculateCostDifference();
                if not jmcLine."JMC Manual Totals Ready" and not jmcLine."JMC Structure Totals Ready" and
                   jmcLine."JMC Production Inputs Ready" and jmcLine."JMC Allocation Eligible" and
                   (jmcLine."JMC Calculation Issue" = '')
                then
                    jmcLine."JMC Cost Difference" := jmcLine."JMC Final Cost" - jmcLine."JMC Total Cost";
                if jmcLine."JMC Cost Difference" <> jmcPreviousDifference then
                    jmcLine.Modify(false);
            until jmcLine.Next() = 0;
        jmcUpgradeTag.SetUpgradeTag(jmcDifferenceTagLbl);
    end;
}
