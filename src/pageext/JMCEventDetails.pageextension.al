pageextension 53107 "JMC Event Details" extends AlxiaMenuCard
{
    layout
    {
        modify(MenuAdulto)
        {
            Visible = false;
        }
        modify(MenuNino)
        {
            Visible = false;
        }
        addafter(MenuAdulto)
        {
            part("JMC Menu"; MenuAdultoListPart)
            {
                ApplicationArea = All;
                Caption = 'Menu', Comment = 'ESP="Menú"';
                UpdatePropagation = Both;
                SubPageLink = "Codigo Evento" = field("Codigo Evento"), Tipo = filter(Adulto | Niño);
                SubPageView = sorting("Codigo Evento", Linea) order(ascending) where(Tipo = filter(Adulto | Niño), Cantidad = filter(<> 0));
            }
        }
    }
}