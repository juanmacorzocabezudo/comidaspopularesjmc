pageextension 53118 "JMC Purchase Order List" extends "Purchase Order List"
{
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
