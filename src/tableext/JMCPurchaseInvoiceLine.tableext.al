tableextension 53110 "JMC Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(53100; "JMC Purchase Order Reason Code"; Code[20])
        {
            Caption = 'Purchase Order Reason', Comment = 'ESP="Motivo pedido compra"';
            DataClassification = CustomerContent;
            TableRelation = "JMC Purchase Order Reason"."JMC Code";
        }
        field(53101; "JMC Purchase Order Method Code"; Code[20])
        {
            Caption = 'Purchase Order Method', Comment = 'ESP="Forma pedido"';
            DataClassification = CustomerContent;
            TableRelation = "JMC Purchase Order Method"."JMC Code";
        }
        field(53102; "JMC Internal Notes"; Text[500])
        {
            Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
            DataClassification = CustomerContent;
        }
    }
}
