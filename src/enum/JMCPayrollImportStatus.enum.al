enum 53152 "JMC Payroll Import Status"
{
    Caption = 'Payroll Import Status', Comment = 'ESP="Estado importación nóminas"';
    Extensible = false;

    value(0; Pending)
    {
        Caption = 'Pending', Comment = 'ESP="Pendiente"';
    }
    value(1; Validated)
    {
        Caption = 'Validated', Comment = 'ESP="Validado"';
    }
    value(2; "Journal Created")
    {
        Caption = 'Journal Created', Comment = 'ESP="Diario creado"';
    }
    value(3; Processed)
    {
        Caption = 'Processed', Comment = 'ESP="Procesado"';
    }
}
