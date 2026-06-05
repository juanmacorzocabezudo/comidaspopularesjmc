table 53115 "JMC Purchase Order Method"
{
    Caption = 'Purchase Order Method', Comment = 'ESP="Forma pedido"';
    DataClassification = CustomerContent;
    LookupPageId = "JMC Purchase Order Methods";
    DrillDownPageId = "JMC Purchase Order Methods";
    InherentPermissions = RX;
    InherentEntitlements = RX;

    fields
    {
        field(1; "JMC Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            DataClassification = CustomerContent;
        }
        field(2; "JMC Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "JMC Code")
        {
            Clustered = true;
        }
    }
}
