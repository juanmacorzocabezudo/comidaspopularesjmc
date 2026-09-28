permissionset 53150 "JMC PAYROLL IMPORT"
{
    Caption = 'Payroll Import', Comment = 'ESP="Importación nóminas"';
    Assignable = true;

    Permissions =
        table "JMC Payroll Import Setup" = X,
        tabledata "JMC Payroll Import Setup" = RIMD,
        table "JMC Payroll Concept Setup" = X,
        tabledata "JMC Payroll Concept Setup" = RIMD,
        table "JMC Payroll Column Mapping" = X,
        tabledata "JMC Payroll Column Mapping" = RIMD,
        table "JMC Garnishment Account Setup" = X,
        tabledata "JMC Garnishment Account Setup" = RIMD,
        table "JMC Payroll Import Header" = X,
        tabledata "JMC Payroll Import Header" = RIMD,
        table "JMC Payroll Import Line" = X,
        tabledata "JMC Payroll Import Line" = RIMD,
        table "JMC Payroll Import Entry" = X,
        tabledata "JMC Payroll Import Entry" = RIMD,
        tabledata "Gen. Journal Line" = RIM,
        tabledata "Gen. Journal Template" = R,
        tabledata "Gen. Journal Batch" = R,
        tabledata "G/L Account" = R,
        tabledata "Default Dimension" = R,
        tabledata "No. Series" = R,
        tabledata "No. Series Line" = RM,
        tabledata Resource = R,
        page "JMC Payroll Import Setup" = X,
        page "JMC Payroll Concept Setup" = X,
        page "JMC Payroll Column Mapping" = X,
        page "JMC Garnishment Account Setup" = X,
        page "JMC Payroll Import List" = X,
        page "JMC Payroll Import" = X,
        page "JMC Payroll Import Lines" = X,
        page "JMC Payroll Import Entries" = X,
        codeunit "JMC Payroll Import Mgt." = X;
}
