pageextension 53104 "JMC Lista Eventos" extends "Lista de Eventos"
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
    }

    actions
    {
        addlast(Processing)
        {
            action("JMC Detalles evento")
            {
                Caption = 'Event Details', Comment = 'ESP="Detalles evento"';
                ApplicationArea = All;
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page AlxiaMenuCard;
                RunPageLink = "Codigo Evento" = field("Codigo Evento");
            }
        }
    }
}