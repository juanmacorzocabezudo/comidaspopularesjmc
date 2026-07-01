pageextension 53118 "JMC Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addbefore("Document Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Caption = 'Order Date', Comment = 'ESP="Fecha pedido"';
                ToolTip = 'Specifies the date when the order was created.', Comment = 'ESP="Especifica la fecha en que se creó el pedido."';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("JMC View Purchase Order Lines")
            {
                ApplicationArea = All;
                Caption = 'View Purchase Order Lines', Comment = 'ESP="Ver Lineas Pedido Compra"';
                Image = OrderList;
                ToolTip = 'View all purchase order lines.', Comment = 'ESP="Ver todas las líneas de pedidos de compra."';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    jmcPurchaseOrderLinesPage: Page AlxLineasPedidoCompra;
                begin
                    jmcPurchaseOrderLinesPage.Run();
                end;
            }
        }
    }
}
