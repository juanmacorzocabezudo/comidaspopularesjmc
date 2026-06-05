table 53114 "JMC Purchase Order Reason"
{
    Caption = 'Purchase Order Reason', Comment = 'ESP="Motivo pedido compra"';
    DataClassification = CustomerContent;
    LookupPageId = "JMC Purchase Order Reasons";
    DrillDownPageId = "JMC Purchase Order Reasons";
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
