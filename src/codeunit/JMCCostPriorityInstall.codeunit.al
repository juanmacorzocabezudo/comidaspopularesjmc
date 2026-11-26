codeunit 53105 "JMC Cost Priority Install"
{
    Subtype = Install;
    Permissions = tabledata "JMC Cost Model" = rm,
                  tabledata "JMC Cost Priority Factor" = rim;

    trigger OnInstallAppPerCompany()
    begin
        InitializeResourceCostPercentages();
        InvalidateDirectPersonnelSources();
        InvalidateExpandedItemAllocation();
    end;

    procedure InvalidateExpandedItemAllocation()
    var
        jmcCostModel: Record "JMC Cost Model";
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcTagLbl: Label 'JMC-ExpandedItemAllocation-20261126', Locked = true;
    begin
        if jmcUpgradeTag.HasUpgradeTag(jmcTagLbl) then
            exit;
        if jmcCostModel.Get('GENERAL') then begin
            jmcCostModel."JMC Personnel Sources Ready" := false;
            jmcCostModel."JMC Calculation Current" := false;
            jmcCostModel.Modify(false);
        end;
        jmcUpgradeTag.SetUpgradeTag(jmcTagLbl);
    end;

    procedure InvalidateDirectPersonnelSources()
    var
        jmcCostModel: Record "JMC Cost Model";
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcDirectBusinessTagLbl: Label 'JMC-DirectPersonnelBusiness-20261126', Locked = true;
    begin
        if jmcUpgradeTag.HasUpgradeTag(jmcDirectBusinessTagLbl) then
            exit;
        if jmcCostModel.Get('GENERAL') then begin
            jmcCostModel."JMC Personnel Sources Ready" := false;
            jmcCostModel."JMC Calculation Current" := false;
            jmcCostModel.Modify(false);
        end;
        jmcUpgradeTag.SetUpgradeTag(jmcDirectBusinessTagLbl);
    end;

    procedure InitializeResourceCostPercentages()
    var
        jmcCostModel: Record "JMC Cost Model";
        jmcUpgradeTag: Codeunit "Upgrade Tag";
        jmcResourcePercentageTagLbl: Label 'JMC-PersonnelStructurePercentages-20261126', Locked = true;
    begin
        if jmcUpgradeTag.HasUpgradeTag(jmcResourcePercentageTagLbl) then
            exit;
        if jmcCostModel.Get('GENERAL') then begin
            jmcCostModel."JMC Industry Resource Pct." := jmcCostModel."JMC Industry Structure Pct.";
            jmcCostModel."JMC Catering Resource Pct." := jmcCostModel."JMC Catering Structure Pct.";
            jmcCostModel."JMC Personnel Sources Ready" := false;
            jmcCostModel."JMC Calculation Current" := false;
            jmcCostModel.Modify(false);
        end;
        jmcUpgradeTag.SetUpgradeTag(jmcResourcePercentageTagLbl);
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
    end;
}
