pageextension 53125 "JMC Item List" extends "Item List"
{
    layout
    {
        modify("Last Direct Cost")
        {
            Visible = false;
        }
        addafter("Unit Cost")
        {
            field("JMC Last Direct Cost"; Rec."JMC Average Purchase Cost")
            {
                ApplicationArea = All;
                Caption = 'Last Direct Cost', Comment = 'ESP="Último coste directo"';
                ToolTip = 'Specifies the average purchase cost calculated from the last purchase invoice.', Comment = 'ESP="Especifica el coste medio de compra calculado de la última factura de compra."';

                trigger OnDrillDown()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    if Rec."JMC Last Purch. Invoice No." <> '' then begin
                        PurchInvHeader.Get(Rec."JMC Last Purch. Invoice No.");
                        Page.Run(Page::"Posted Purchase Invoice", PurchInvHeader);
                    end;
                end;
            }
        }
    }
}
