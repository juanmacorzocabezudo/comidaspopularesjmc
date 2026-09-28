enum 53153 "JMC Payroll Validation Status"
{
    Caption = 'Payroll Validation Status', Comment = 'ESP="Estado validación nómina"';
    Extensible = false;

    value(0; Pending)
    {
        Caption = 'Pending', Comment = 'ESP="Pendiente"';
    }
    value(1; Correct)
    {
        Caption = 'Correct', Comment = 'ESP="Correcta"';
    }
    value(2; Warning)
    {
        Caption = 'Warning', Comment = 'ESP="Aviso"';
    }
    value(3; Error)
    {
        Caption = 'Error', Comment = 'ESP="Error"';
    }
}
