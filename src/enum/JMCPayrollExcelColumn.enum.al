enum 53154 "JMC Payroll Excel Column"
{
    Caption = 'Payroll Excel Column', Comment = 'ESP="Columna Excel nómina"';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Gross)
    {
        Caption = 'C.BRUTO', Locked = true;
    }
    value(2; "Company SS")
    {
        Caption = 'SS.EMPRESA', Locked = true;
    }
    value(3; "Total Cost")
    {
        Caption = 'C.TOTAL', Locked = true;
    }
    value(4; TC1)
    {
        Caption = 'TC1', Locked = true;
    }
    value(5; Bonus)
    {
        Caption = 'PRIMAS', Locked = true;
    }
    value(6; "Employee SS")
    {
        Caption = 'SS.TRAB.', Locked = true;
    }
    value(7; IRPF)
    {
        Caption = 'IRPF', Locked = true;
    }
    value(8; Retention)
    {
        Caption = 'RETENCION', Locked = true;
    }
    value(9; "Net Pay")
    {
        Caption = 'LIQUIDO', Locked = true;
    }
    value(10; "SS Base")
    {
        Caption = 'BASE S.SOC', Locked = true;
    }
    value(11; "IRPF Base")
    {
        Caption = 'BASE IRPF', Locked = true;
    }
    value(12; Discounts)
    {
        Caption = 'DESCUENTOS', Locked = true;
    }
    value(13; "Payment in Kind")
    {
        Caption = 'RTOS ESPEC', Locked = true;
    }
    value(14; Advances)
    {
        Caption = 'ANTICIPOS', Locked = true;
    }
    value(15; "Medical Insurance")
    {
        Caption = 'seguro med', Locked = true;
    }
    value(16; "Medical Insurance IRPF")
    {
        Caption = 's.med irpf', Locked = true;
    }
    value(17; "Payment in Kind Deduction")
    {
        Caption = 'deduc rtos', Locked = true;
    }
    value(18; "Extra Pay")
    {
        Caption = 'PP EXTRA', Locked = true;
    }
    value(19; "Self-Employed SS")
    {
        Caption = 'SS AUTONOM', Locked = true;
    }
}
