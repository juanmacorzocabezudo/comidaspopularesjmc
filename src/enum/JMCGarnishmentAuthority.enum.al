enum 53151 "JMC Garnishment Authority"
{
    Caption = 'Garnishment Authority', Comment = 'ESP="Organismo embargante"';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Provincial Council")
    {
        Caption = 'Provincial Council', Comment = 'ESP="Diputación"';
    }
    value(2; Court)
    {
        Caption = 'Court', Comment = 'ESP="Juzgado"';
    }
    value(3; "Tax Agency")
    {
        Caption = 'Tax Agency (AEAT)', Comment = 'ESP="AEAT"';
    }
    value(4; "Social Security")
    {
        Caption = 'Social Security (TGSS)', Comment = 'ESP="Seguridad Social (TGSS)"';
    }
    value(5; Other)
    {
        Caption = 'Other', Comment = 'ESP="Otros"';
    }
}
