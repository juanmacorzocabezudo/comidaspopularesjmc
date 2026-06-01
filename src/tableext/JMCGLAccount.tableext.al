tableextension 53103 "JMC G/L Account" extends "G/L Account"
{
    fields
    {
        field(53101; "JMC CP Categories"; Enum "JMC CP Categories")
        {
            Caption = 'CP Categories', Comment = 'ESP="Categorías CP"';
            DataClassification = CustomerContent;
        }
    }
}
