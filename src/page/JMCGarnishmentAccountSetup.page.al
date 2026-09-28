page 53153 "JMC Garnishment Account Setup"
{
    Caption = 'Garnishment Accounts', Comment = 'ESP="Cuentas por organismo embargante"';
    PageType = List;
    SourceTable = "JMC Garnishment Account Setup";
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Authority; Rec."JMC Authority") { }
                field(GLAccountNo; Rec."JMC G/L Account No.") { }
                field(GLAccountName; Rec."JMC G/L Account Name") { }
            }
        }
    }
}
