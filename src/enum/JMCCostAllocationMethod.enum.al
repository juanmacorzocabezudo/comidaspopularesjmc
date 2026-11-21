enum 53101 "JMC Cost Allocation Method"
{
    Extensible = false;

    value(0; Sales)
    {
        Caption = 'Calculation Against Products', Comment = 'ESP="Cálculo contra productos"';
    }
    value(1; Recipe)
    {
        Caption = 'Recipe', Comment = 'ESP="Contra receta"';
        ObsoleteState = Pending;
        ObsoleteReason = 'The cost model only calculates against products. Retained so that older saved rows remain valid.';
        ObsoleteTag = '27.5.0.50';
    }
}
