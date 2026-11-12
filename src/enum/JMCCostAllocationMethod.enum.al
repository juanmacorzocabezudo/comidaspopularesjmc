enum 53101 "JMC Cost Allocation Method"
{
    Extensible = false;

    value(0; Sales)
    {
        Caption = 'Sales', Comment = 'ESP="Contra ventas"';
    }
    value(1; Recipe)
    {
        Caption = 'Recipe', Comment = 'ESP="Contra receta"';
    }
}
