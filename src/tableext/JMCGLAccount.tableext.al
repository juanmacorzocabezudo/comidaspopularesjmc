tableextension 53103 "JMC G/L Account" extends "G/L Account"
{
    fields
    {
        field(53101; "JMC CP Categories"; Enum "JMC CP Categories")
        {
            Caption = 'CP Categories', Comment = 'ESP="Categorías CP"';
            DataClassification = CustomerContent;
        }
        field(53102; "JMC Cost Type"; Enum "JMC Cost Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            DataClassification = CustomerContent;
            InitValue = " ";
        }
        field(53103; "JMC Cost Classification"; Enum "JMC Cost Classification")
        {
            Caption = 'Cost Classification', Comment = 'ESP="Clasificación del coste"';
            DataClassification = CustomerContent;
            InitValue = " ";
        }
    }
}
