pageextension 53101 "JMC Ficha Evento" extends "Ficha Evento"
{
    layout
    {
        addbefore("Total Adultos")
        {
            field("JMC Total People"; Rec."Total Adultos" + Rec."Total Ninos")
            {
                ApplicationArea = All;
                Caption = 'Total People', Comment = 'ESP="Total personas"';
                ToolTip = 'Specifies the total number of adults and children attending the event.', Comment = 'ESP="Especifica el total de adultos y niños que asisten al evento."';
                Editable = false;
            }
        }
        modify("Total Adultos")
        {
            Visible = false;
        }
        modify("Total Ninos")
        {
            Visible = false;
        }
        modify("Coste Menu Adulto")
        {
            Visible = false;
        }
        modify("Coste Menu Nino")
        {
            Visible = false;
        }
        modify("Coste Menu Otros")
        {
            Visible = false;
        }
        modify("Precio Menu Adulto")
        {
            Visible = false;
        }
        modify("Precio Menu Nino")
        {
            Visible = false;
        }
        modify("Precio Otros Menus")
        {
            Visible = false;
        }
    }

    actions
    {
        modify("Menú Adultos")
        {
            Visible = false;
        }
        modify("Menú Niños")
        {
            Visible = false;
        }
        addafter("Menú Adultos")
        {
            action("JMC Menu")
            {
                ApplicationArea = All;
                Caption = 'Menu', Comment = 'ESP="Menú"';
                ToolTip = 'Opens the adult and child menus for the event.', Comment = 'ESP="Abre los menús de adultos y niños del evento."';
                Image = SalesPurchaseTeam;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Menu Adulto";
                RunPageLink = "Codigo Evento" = field("Codigo Evento"), Tipo = filter(Adulto | Niño);
                RunPageView = sorting("Codigo Evento", Linea) order(ascending) where(Tipo = filter(Adulto | Niño));
            }
        }
    }

    /*
    actions
    {
        modify("Cambiar Estado")
        {
            Visible = false;
        }

        addafter("Calcular Costes y Precios")
        {
            action("JMC Cambiar Estado")
            {
                Caption = 'Change Status', Comment = 'ESP="Cambiar Estado"';
                ApplicationArea = All;
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.JMCChangeStatus();
                end;
            }
        }
    }*/
}
