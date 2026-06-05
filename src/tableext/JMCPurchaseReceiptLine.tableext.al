tableextension 53109 "JMC Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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
        field(53103; "JMC Received"; Boolean)
        {
            Caption = 'Received', Comment = 'ESP="Recibido"';
            DataClassification = CustomerContent;
        }
        field(53104; "JMC Recipe"; Text[100])
        {
            Caption = 'Recipe', Comment = 'ESP="Receta"';
            DataClassification = CustomerContent;
        }
    }
}
