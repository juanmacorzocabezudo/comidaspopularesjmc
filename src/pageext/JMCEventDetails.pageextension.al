pageextension 53107 "JMC Event Details" extends AlxiaMenuCard
{
    layout
    {
        addfirst(Content)
        {
            group(JMCEventCosts)
            {
                Caption = 'Costs and Amounts', Comment = 'ESP="Costes e Importes"';

                field("Coste Total Elaboracion"; Rec."Coste Total Elaboracion")
                {
                    ApplicationArea = All;
                }
                field("Coste Total Recursos"; Rec."Coste Total Recursos")
                {
                    ApplicationArea = All;
                    Caption = 'Total Indirect Cost', Comment = 'ESP="Coste Total Indirecto"';

                    trigger OnDrillDown()
                    var
                        EventRecord: Record Evento;
                    begin
                        EventRecord.SetRange("Codigo Evento", Rec."Codigo Evento");
                        Page.Run(50144, EventRecord);
                    end;
                }
                field("Coste Total Visualizado"; Rec."Coste Total Visualizado")
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost', Comment = 'ESP="Coste Total"';
                    Editable = false;
                }
                field("Importe Total Evento"; Rec."Importe Total Evento")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        EventLines: Record "Lineas Evento";
                    begin
                        EventLines.SetRange("Codigo Evento", Rec."Codigo Evento");
                        Page.Run(50069, EventLines);
                    end;
                }
                field("Importe Total IVA Incluido"; Rec."Importe Total IVA Incluido")
                {
                    ApplicationArea = All;
                }
                field(ImporteBeneficio; Rec.gfu_ImpBeneficio)
                {
                    ApplicationArea = All;
                    Caption = 'Benefit Amount', Comment = 'ESP="Importe Beneficio"';
                }
                field(PorcBeneficio; Rec.gfu_PorcBeneficio)
                {
                    ApplicationArea = All;
                    Caption = '% Real Benefit', Comment = 'ESP="% Beneficio Real"';
                    ToolTip = 'Shows the real benefit percentage: (total event amount - total cost) / total event amount x 100.', Comment = 'ESP="Muestra el porcentaje de beneficio real: (importe total del evento - coste total) / importe total del evento x 100."';
                }
                field(gfu_PorcBeneficioTeorico; Rec.gfu_PorcBeneficioTeorico())
                {
                    ApplicationArea = All;
                    Caption = '% Theoretical Benefit', Comment = 'ESP="% Beneficio Teórico"';
                    ToolTip = 'Shows the theoretical cost percentage: total cost / total event amount x 100.', Comment = 'ESP="Muestra el porcentaje de coste teórico: coste total / importe total del evento x 100."';
                }
                field("Importe Rechazado"; Rec."Importe Rechazado")
                {
                    ApplicationArea = All;
                }
                field("Importe Pedido Venta"; Rec."Importe Pedido Venta")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe Factura Venta"; Rec."Importe Factura Venta")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Distance.Text"; Rec."Distance.Text")
                {
                    ApplicationArea = All;
                }
            }
        }
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