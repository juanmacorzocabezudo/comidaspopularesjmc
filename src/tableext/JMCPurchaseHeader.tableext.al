tableextension 53104 "JMC Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(53100; "JMC Purchase Order Reason Code"; Code[20])
        {
            Caption = 'Purchase Order Reason', Comment = 'ESP="Motivo pedido compra"';
            DataClassification = CustomerContent;
            TableRelation = "JMC Purchase Order Reason"."JMC Code";

            trigger OnValidate()
            var
                PurchLine: Record "Purchase Line";
            begin
                PurchLine.SetRange("Document Type", Rec."Document Type");
                PurchLine.SetRange("Document No.", Rec."No.");
                if PurchLine.FindSet(true) then
                    repeat
                        PurchLine."JMC Purchase Order Reason Code" := Rec."JMC Purchase Order Reason Code";
                        PurchLine.Modify(true);
                    until PurchLine.Next() = 0;
            end;
        }
        field(53101; "JMC Purchase Order Method Code"; Code[20])
        {
            Caption = 'Purchase Order Method', Comment = 'ESP="Forma pedido"';
            DataClassification = CustomerContent;
            TableRelation = "JMC Purchase Order Method"."JMC Code";

            trigger OnValidate()
            var
                PurchLine: Record "Purchase Line";
            begin
                PurchLine.SetRange("Document Type", Rec."Document Type");
                PurchLine.SetRange("Document No.", Rec."No.");
                if PurchLine.FindSet(true) then
                    repeat
                        PurchLine."JMC Purchase Order Method Code" := Rec."JMC Purchase Order Method Code";
                        PurchLine.Modify(true);
                    until PurchLine.Next() = 0;
            end;
        }
    }
}
