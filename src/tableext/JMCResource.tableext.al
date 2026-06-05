tableextension 53112 "JMC Resource" extends Resource
{
    fields
    {
        field(53101; "JMC Gestoría ID"; Code[20])
        {
            Caption = 'Gestoría ID', Comment = 'ESP="ID Gestoría"';
            DataClassification = CustomerContent;
        }
        field(53102; "JMC Cost Type"; Enum "JMC Cost Type")
        {
            Caption = 'Cost Type', Comment = 'ESP="Tipo coste"';
            DataClassification = CustomerContent;
        }
    }
}
