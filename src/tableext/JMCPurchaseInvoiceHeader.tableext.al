tableextension 53106 "JMC Purch. Inv. Header" extends "Purch. Inv. Header"
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
    }
}
