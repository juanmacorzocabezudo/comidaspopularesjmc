page 53151 "JMC Payroll Concept Setup"
{
    Caption = 'Payroll Concept Accounts', Comment = 'ESP="Cuentas por concepto de nómina"';
    PageType = List;
    SourceTable = "JMC Payroll Concept Setup";
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(ConceptType; Rec."JMC Concept Type") { }
                field(PostingSide; Rec."JMC Posting Side") { }
                field(GLAccountNo; Rec."JMC G/L Account No.") { }
                field(GLAccountName; Rec."JMC G/L Account Name") { }
            }
        }
    }

    trigger OnOpenPage()
    var
        jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
    begin
        jmcPayrollImportMgt.InitializeDefaults();
    end;
}
