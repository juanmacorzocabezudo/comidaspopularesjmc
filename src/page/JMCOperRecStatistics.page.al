page 53112 "JMC Cronus Statistics"
{
    Caption = 'Cronus Statistics', Comment = 'ESP="Estadísticas de Cronus"';
    PageType = CardPart;
    SourceTable = "JMC Cronus";

    layout
    {
        area(Content)
        {
            group(TotalsGroup)
            {
                Caption = 'Totals', Comment = 'ESP="Totales"';
                ShowCaption = true;

                field(TotalIncome; TotalIncomeValue)
                {
                    Caption = 'Total Income', Comment = 'ESP="Total ingresos"';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field(TotalExpense; TotalExpenseValue)
                {
                    Caption = 'Total Expenses', Comment = 'ESP="Total gastos"';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
            }
            group(CashBoxGroup)
            {
                Caption = 'Cash Box', Comment = 'ESP="Caja"';
                ShowCaption = true;

                field(TotalCashBox; TotalCashBoxValue)
                {
                    Caption = 'Total in Cash Box', Comment = 'ESP="Total en Caja"';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group(HomeGroup)
            {
                Caption = 'Home', Comment = 'ESP="Casa"';
                ShowCaption = true;

                field(TotalHome; TotalHomeValue)
                {
                    Caption = 'Total at Home', Comment = 'ESP="Total en Casa"';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateTotals();
    end;

    var
        TotalIncomeValue: Decimal;
        TotalExpenseValue: Decimal;
        TotalCashBoxValue: Decimal;
        TotalHomeValue: Decimal;

    procedure UpdateTotals()
    begin
        CalculateTotals();
        CurrPage.Update(false);
    end;

    local procedure CalculateTotals()
    var
        OperationRecord: Record "JMC Cronus";
    begin
        TotalIncomeValue := 0;
        TotalExpenseValue := 0;
        TotalCashBoxValue := 0;
        TotalHomeValue := 0;

        OperationRecord.Copy(Rec);
        OperationRecord.SetRange("JMC Entry No.");
        OperationRecord.SetLoadFields("JMC Movement Type", "JMC Amount", "JMC Cash Box");

        if OperationRecord.FindSet() then
            repeat
                case OperationRecord."JMC Movement Type" of
                    OperationRecord."JMC Movement Type"::Income:
                        TotalIncomeValue += OperationRecord."JMC Amount";
                    OperationRecord."JMC Movement Type"::Expense:
                        TotalExpenseValue += OperationRecord."JMC Amount";
                end;

                case OperationRecord."JMC Cash Box" of
                    OperationRecord."JMC Cash Box"::Caja:
                        TotalCashBoxValue += OperationRecord."JMC Amount";
                    OperationRecord."JMC Cash Box"::Casa:
                        TotalHomeValue += OperationRecord."JMC Amount";
                end;
            until OperationRecord.Next() = 0;
    end;
}
