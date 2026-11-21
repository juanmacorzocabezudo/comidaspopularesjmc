codeunit 53105 "JMC Cost Priority Install"
{
    Subtype = Install;
    Permissions = tabledata Item = rm,
                  tabledata "JMC Cost Model" = rm,
                  tabledata "JMC Cost Priority Factor" = rim;

    trigger OnInstallAppPerCompany()
    begin
        InitializeItemPriorities();
    end;

    procedure InitializeItemPriorities()
    var
        jmcItem: Record Item;
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcPriorityTagLbl: Label 'JMC-ItemPriorityDefault-20261119', Locked = true;
        jmcPercentageTagLbl: Label 'JMC-PriorityPercentages-20261119', Locked = true;
    begin
        if not jmcUpgradeTag.HasUpgradeTag(jmcPriorityTagLbl) then begin
            jmcItem.SetRange("JMC Priority Level", 0);
            jmcItem.ModifyAll("JMC Priority Level", 1, false);
            jmcUpgradeTag.SetUpgradeTag(jmcPriorityTagLbl);
        end;
        if not jmcUpgradeTag.HasUpgradeTag(jmcPercentageTagLbl) then begin
            RestoreDefaultPercentages();
            jmcUpgradeTag.SetUpgradeTag(jmcPercentageTagLbl);
        end;
    end;

    procedure RestoreDefaultPercentages()
    var
        jmcFactor: Record "JMC Cost Priority Factor";
        jmcLevel: Integer;
    begin
        for jmcLevel := 1 to 5 do begin
            if not jmcFactor.Get(jmcLevel) then begin
                jmcFactor.Init();
                jmcFactor."JMC Priority Level" := jmcLevel;
                jmcFactor."JMC Allocation Pct." := 120 - 20 * jmcLevel;
                jmcFactor.Insert(false);
            end else begin
                jmcFactor."JMC Allocation Pct." := 120 - 20 * jmcLevel;
                jmcFactor.Modify(false);
            end;
        end;
        // Triggers are skipped to avoid checking intermediate values, so invalidate the model explicitly.
        jmcFactor.InvalidateCalculation();
    end;
}
