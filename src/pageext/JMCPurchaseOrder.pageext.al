pageextension 53310 "JMC Purchase Order" extends "Purchase Order"
{
    layout
    {
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

    actions
    {
        addlast(processing)
        {
            action("JMC Create Incident")
            {
                ApplicationArea = All;
                Caption = 'Create Incident', Comment = 'ESP="Crear incidencia"';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    IncidentMgt: Codeunit "JMC Supplier Incident Mgt";
                begin
                    IncidentMgt.CreateFromPurchaseOrder(Rec);
                end;
            }
        }
        addlast(navigation)
        {
            action("JMC View Incidents")
            {
                ApplicationArea = All;
                Caption = 'View Incidents', Comment = 'ESP="Ver incidencias"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Incident: Record "JMC Supplier Incident";
                begin
                    Incident.SetRange("JMC Source Type", Incident."JMC Source Type"::"Purchase Order");
                    Incident.SetRange("JMC Source Document No.", Rec."No.");
                    Page.Run(Page::"JMC Supplier Incident List", Incident);
                end;
            }
        }
    }
}