codeunit 53105 "JMC Cost Priority Install"
{
    Subtype = Install;
    Permissions = tabledata Item = rm;

    trigger OnInstallAppPerCompany()
    begin
        InitializeItemPriorities();
    end;

    procedure InitializeItemPriorities()
    var
        jmcItem: Record Item;
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcPriorityTagLbl: Label 'JMC-ItemCostPriority-20261116', Locked = true;
    begin
        if jmcUpgradeTag.HasUpgradeTag(jmcPriorityTagLbl) then
            exit;
        jmcItem.SetRange("JMC Priority Level", 0);
        jmcItem.ModifyAll("JMC Priority Level", 1, false);
        jmcUpgradeTag.SetUpgradeTag(jmcPriorityTagLbl);
    end;
}
