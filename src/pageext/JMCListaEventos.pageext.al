pageextension 53104 "JMC Lista Eventos" extends "Lista de Eventos"
{
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