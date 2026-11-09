pageextension 53107 "JMC Event Details" extends AlxiaMenuCard
{
    layout
    {
        modify(MenuAdulto)
        {
            Visible = JMCShowLegacyMenuParts;
        }
        modify(MenuNino)
        {
            Visible = JMCShowLegacyMenuParts;
        }
        addafter(MenuAdulto)
        {
            part("JMC Menu"; MenuAdultoListPart)
            {
                ApplicationArea = All;
                Caption = 'Menu', Comment = 'ESP="Menú"';
                UpdatePropagation = Both;
                SubPageLink = "Codigo Evento" = field("Codigo Evento"), Tipo = filter(Adulto | Niño);
                SubPageView = sorting("Codigo Evento", Linea) order(ascending) where(Tipo = filter(Adulto | Niño));
            }
        }
    }

    var
        JMCShowLegacyMenuParts: Boolean;

    trigger OnOpenPage()
    begin
        JMCShowLegacyMenuParts := false;
    end;
}