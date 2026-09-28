page 53157 "JMC Payroll Import Entries"
{
    Caption = 'Proposed Entry', Comment = 'ESP="Propuesta de asiento"';
    PageType = ListPart;
    SourceTable = "JMC Payroll Import Entry";
    AutoSplitKey = true;
    DelayedInsert = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(ConceptType; Rec."JMC Concept Type") { }
                field(GarnishmentAuthority; Rec."JMC Garnishment Authority") { }
                field(GarnishmentFileNo; Rec."JMC Garnishment File No.") { }
                field(GLAccountNo; Rec."JMC G/L Account No.") { }
                field(GLAccountName; Rec."JMC G/L Account Name") { }
                field(Description; Rec."JMC Description") { }
                field(DebitAmount; Rec."JMC Debit Amount") { }
                field(CreditAmount; Rec."JMC Credit Amount") { }
                field(Amount; Rec."JMC Amount") { Visible = false; }
                field(SourceColumn; Rec."JMC Source Column") { }
                field(Balancing; Rec."JMC Balancing") { Visible = false; }
                field(GlobalDimension1Code; Rec."JMC Global Dimension 1 Code") { }
                field(GlobalDimension2Code; Rec."JMC Global Dimension 2 Code") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SplitLine)
            {
                Caption = 'Split Line', Comment = 'ESP="Dividir línea"';
                ToolTip = 'Split the selected line into two lines with half of the amount each, for example to separate principal and interest. Then adjust the concept, account and amounts.', Comment = 'ESP="Divide la línea seleccionada en dos con la mitad del importe cada una, por ejemplo para separar amortización e intereses. Después ajuste el concepto, la cuenta y los importes."';
                Image = Split;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    jmcPayrollImportMgt.SplitEntry(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
