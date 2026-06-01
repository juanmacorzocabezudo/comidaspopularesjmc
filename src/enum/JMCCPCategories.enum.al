enum 53111 "JMC CP Categories"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Comment = 'ESP=" "';
    }
    value(1; "Current Asset")
    {
        Caption = 'Current Asset', Comment = 'ESP="Activo corriente"';
    }
    value(2; "Non-Current Asset")
    {
        Caption = 'Non-Current Asset', Comment = 'ESP="Activo no corriente"';
    }
    value(3; "Current Asset/Liability")
    {
        Caption = 'Current Asset/Liability', Comment = 'ESP="Activo/Pasivo corriente"';
    }
    value(4; "Expense")
    {
        Caption = 'Expense', Comment = 'ESP="Gasto"';
    }
    value(5; "Income")
    {
        Caption = 'Income', Comment = 'ESP="Ingreso"';
    }
    value(6; "Current Liability")
    {
        Caption = 'Current Liability', Comment = 'ESP="Pasivo corriente"';
    }
    value(7; "Non-Current Liability")
    {
        Caption = 'Non-Current Liability', Comment = 'ESP="Pasivo no corriente"';
    }
    value(8; "Equity")
    {
        Caption = 'Equity', Comment = 'ESP="Patrimonio neto"';
    }
}
