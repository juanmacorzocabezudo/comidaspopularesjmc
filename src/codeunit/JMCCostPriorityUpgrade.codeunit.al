codeunit 53106 "JMC Cost Priority Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        jmcInstall: Codeunit "JMC Cost Priority Install";
    begin
        jmcInstall.InitializeItemPriorities();
    end;
}
