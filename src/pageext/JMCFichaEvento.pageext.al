pageextension 53101 "JMC Ficha Evento" extends "Ficha Evento"
{
    layout
    {
        modify("Codigo Cliente")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                if Rec."Codigo Cliente" = '' then
                    Rec.Validate("JMC Customer Type", '')
                else begin
                    Customer.Get(Rec."Codigo Cliente");
                    Rec.Validate("JMC Customer Type", Customer."JMC Customer Type");
                end;
            end;
        }
        addbefore("Total Adultos")
        {
            field("JMC Total People"; Format(Rec."Total Adultos" + Rec."Total Ninos"))
            {
                ApplicationArea = All;
                Caption = 'Total People', Comment = 'ESP="Total personas"';
                ToolTip = 'Specifies the total number of adults and children attending the event.', Comment = 'ESP="Especifica el total de adultos y niños que asisten al evento."';
                Editable = false;
            }
        }
        addlast("Contacto / Cliente")
        {
            field("JMC Customer Type"; Rec."JMC Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                ToolTip = 'Specifies the customer type copied from the selected customer. You can change it for this event.', Comment = 'ESP="Especifica el tipo de cliente copiado del cliente seleccionado. Puede cambiarlo para este evento."';
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
        modify(PorcBeneficio)
        {
            ToolTip = 'Shows the real benefit percentage: (total event amount - total cost) / total event amount x 100.', Comment = 'ESP="Muestra el porcentaje de beneficio real: (importe total del evento - coste total) / importe total del evento x 100."';
        }
        modify(gfu_PorcBeneficioTeorico)
        {
            ToolTip = 'Shows the theoretical cost percentage: total cost / total event amount x 100.', Comment = 'ESP="Muestra el porcentaje de coste teórico: coste total / importe total del evento x 100."';
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Plantilla Cliente" = '' then
            Rec.Validate("Plantilla Cliente", 'CLIENTE');
    end;

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
