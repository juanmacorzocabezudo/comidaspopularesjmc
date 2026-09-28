page 53156 "JMC Payroll Import Lines"
{
    Caption = 'Payrolls', Comment = 'ESP="Nóminas"';
    PageType = ListPart;
    SourceTable = "JMC Payroll Import Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(ValidationStatus; Rec."JMC Validation Status")
                {
                    StyleExpr = StatusStyle;
                }
                field(ValidationMessage; Rec."JMC Validation Message")
                {
                    StyleExpr = StatusStyle;
                }
                field(ExcelRowNo; Rec."JMC Excel Row No.") { }
                field(GestoriaID; Rec."JMC Gestoría ID") { }
                field(ResourceNo; Rec."JMC Resource No.") { }
                field(ResourceName; Rec."JMC Resource Name") { }
                field(WorkerName; Rec."JMC Worker Name") { }
                field(VATRegistrationNo; Rec."JMC VAT Registration No.") { }
                field(PayType; Rec."JMC Pay Type") { }
                field(PostingDate; Rec."JMC Posting Date") { }
                field(Description; Rec."JMC Description") { }
                field(Gross; Rec."JMC Gross") { }
                field(CompanySS; Rec."JMC Company SS") { }
                field(TotalCost; Rec."JMC Total Cost") { }
                field(TC1; Rec."JMC TC1") { }
                field(Bonus; Rec."JMC Bonus") { }
                field(EmployeeSS; Rec."JMC Employee SS") { }
                field(IRPF; Rec."JMC IRPF") { }
                field(Retention; Rec."JMC Retention") { }
                field(NetPay; Rec."JMC Net Pay") { }
                field(SSBase; Rec."JMC SS Base") { Visible = false; }
                field(IRPFBase; Rec."JMC IRPF Base") { Visible = false; }
                field(Discounts; Rec."JMC Discounts") { }
                field(PaymentInKind; Rec."JMC Payment in Kind") { }
                field(Advances; Rec."JMC Advances") { }
                field(MedicalInsurance; Rec."JMC Medical Insurance") { }
                field(MedicalInsuranceIRPF; Rec."JMC Medical Insurance IRPF") { }
                field(PaymentInKindDeduction; Rec."JMC Payment in Kind Deduction") { }
                field(ExtraPay; Rec."JMC Extra Pay") { }
                field(SelfEmployedSS; Rec."JMC Self-Employed SS") { }
                field(TotalDebit; Rec."JMC Total Debit") { }
                field(TotalCredit; Rec."JMC Total Credit") { }
                field(EntryBalance; Rec."JMC Entry Balance")
                {
                    StyleExpr = BalanceStyle;
                }
                field(DocumentNo; Rec."JMC Document No.") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RegenerateEntry)
            {
                Caption = 'Regenerate Entry', Comment = 'ESP="Regenerar asiento"';
                ToolTip = 'Create the proposed entry of the selected payroll again from its amounts. The manual changes are lost.', Comment = 'ESP="Vuelve a crear la propuesta de asiento de la nómina seleccionada a partir de sus importes. Se pierden los cambios manuales."';
                Image = Refresh;

                trigger OnAction()
                var
                    jmcPayrollImportMgt: Codeunit "JMC Payroll Import Mgt.";
                begin
                    jmcPayrollImportMgt.RegenerateEntries(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        StatusStyle: Text;
        BalanceStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec."JMC Validation Status" of
            Rec."JMC Validation Status"::Error:
                StatusStyle := 'Unfavorable';
            Rec."JMC Validation Status"::Warning:
                StatusStyle := 'Ambiguous';
            Rec."JMC Validation Status"::Correct:
                StatusStyle := 'Favorable';
            else
                StatusStyle := 'Standard';
        end;
        if Rec."JMC Entry Balance" <> 0 then
            BalanceStyle := 'Unfavorable'
        else
            BalanceStyle := 'Standard';
    end;

    procedure SetIssueFilter(jmcOnlyIssues: Boolean)
    begin
        if jmcOnlyIssues then
            Rec.SetFilter("JMC Validation Status", '%1|%2', Rec."JMC Validation Status"::Error, Rec."JMC Validation Status"::Warning)
        else
            Rec.SetRange("JMC Validation Status");
        CurrPage.Update(false);
    end;
}
