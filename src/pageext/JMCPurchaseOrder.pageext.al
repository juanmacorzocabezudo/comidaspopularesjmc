pageextension 53105 "JMC Purchase Order" extends "Purchase Order"
{
    layout
    {
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        addafter("Order Date")
        {
            field("JMC Purchase Order Reason Code"; Rec."JMC Purchase Order Reason Code")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Reason', Comment = 'ESP="Motivo pedido compra"';
            }
            field("JMC Purchase Order Method Code"; Rec."JMC Purchase Order Method Code")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Method', Comment = 'ESP="Forma pedido"';
            }
        }
    }
}
