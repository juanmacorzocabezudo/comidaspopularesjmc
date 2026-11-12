enum 53112 "JMC Cost Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Fixed)
    {
        Caption = 'Fixed', Comment = 'ESP="Fijo"';
    }
    value(2; Variable)
    {
        Caption = 'Variable', Comment = 'ESP="Variable"';
    }
}
