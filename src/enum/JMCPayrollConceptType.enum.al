enum 53150 "JMC Payroll Concept Type"
{
    Caption = 'Payroll Concept Type', Comment = 'ESP="Tipo concepto nómina"';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Salary)
    {
        Caption = 'Salaries and Wages', Comment = 'ESP="Sueldos y salarios"';
    }
    value(2; "Company SS")
    {
        Caption = 'Company Social Security', Comment = 'ESP="Seguridad Social a cargo de la empresa"';
    }
    value(3; "SS Payable")
    {
        Caption = 'Social Security Payable', Comment = 'ESP="Organismos Seguridad Social acreedores"';
    }
    value(4; "IRPF Payable")
    {
        Caption = 'IRPF Payable', Comment = 'ESP="HP acreedora por IRPF"';
    }
    value(5; "Net Pay")
    {
        Caption = 'Net Pay Payable', Comment = 'ESP="Remuneraciones pendientes de pago"';
    }
    value(6; Advance)
    {
        Caption = 'Advance', Comment = 'ESP="Anticipo"';
    }
    value(7; "Employee Loan")
    {
        Caption = 'Employee Loan', Comment = 'ESP="Préstamo a empleado"';
    }
    value(8; "Related Party Loan Principal")
    {
        Caption = 'Related Party Loan Principal', Comment = 'ESP="Préstamo parte vinculada - amortización"';
    }
    value(9; "Related Party Loan Interest")
    {
        Caption = 'Related Party Loan Interest', Comment = 'ESP="Préstamo parte vinculada - intereses"';
    }
    value(10; Garnishment)
    {
        Caption = 'Garnishment', Comment = 'ESP="Embargo"';
    }
    value(11; "Other Deduction")
    {
        Caption = 'Other Deduction', Comment = 'ESP="Otras deducciones"';
    }
    value(12; Bonus)
    {
        Caption = 'Bonus', Comment = 'ESP="Primas"';
    }
    value(13; "Payment in Kind")
    {
        Caption = 'Payment in Kind', Comment = 'ESP="Retribución en especie"';
    }
    value(14; "Medical Insurance")
    {
        Caption = 'Medical Insurance', Comment = 'ESP="Seguro médico"';
    }
    value(15; "Extra Pay Accrual")
    {
        Caption = 'Extra Pay Accrual', Comment = 'ESP="Devengo paga extra"';
    }
    value(16; "Extra Pay Provision")
    {
        Caption = 'Extra Pay Provision', Comment = 'ESP="Provisión paga extra"';
    }
    value(17; "Self-Employed SS")
    {
        Caption = 'Self-Employed Social Security', Comment = 'ESP="Seguridad Social autónomos"';
    }
    value(18; Other)
    {
        Caption = 'Other', Comment = 'ESP="Otros"';
    }
}
