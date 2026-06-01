pageextension 53112 "JMC Alx Lineas Pedido Compra" extends AlxLineasPedidoCompra
{
    layout
    {
        addlast(Group)
        {
            field("JMC Internal Notes"; Rec."JMC Internal Notes")
            {
                ApplicationArea = All;
                Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
            }
            field("JMC Purchase Order Reason Code"; Rec."JMC Purchase Order Reason Code")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Reason', Comment = 'ESP="Motivo pedido compra"';
                Editable = false;
            }
            field("JMC Purchase Order Method Code"; Rec."JMC Purchase Order Method Code")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Method', Comment = 'ESP="Forma pedido"';
                Editable = false;
            }
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                Caption = 'Brand', Comment = 'ESP="Marca"';
                Editable = false;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                Caption = 'Business Line', Comment = 'ESP="Línea negocio"';
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("JMC Add Internal Notes")
            {
                ApplicationArea = All;
                Caption = 'Add Internal Notes', Comment = 'ESP="Añadir observaciones internas"';
                Image = Notes;
                ToolTip = 'Add or edit internal notes for the selected line.', Comment = 'ESP="Añadir o editar observaciones internas para la línea seleccionada."';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    jmcSelectedLines: Record "Purchase Line";
                    jmcInternalNotesPage: Page "JMC Internal Notes Editor";
                    jmcMultipleLinesSelectedErr: Label 'You must select only one line to add internal notes.', Comment = 'ESP="Debe seleccionar solo una línea para añadir observaciones internas."';
                    jmcNoLineSelectedErr: Label 'You must select a line to add internal notes.', Comment = 'ESP="Debe seleccionar una línea para añadir observaciones internas."';
                begin
                    CurrPage.SetSelectionFilter(jmcSelectedLines);

                    if jmcSelectedLines.Count = 0 then
                        Error(jmcNoLineSelectedErr);

                    if jmcSelectedLines.Count > 1 then
                        Error(jmcMultipleLinesSelectedErr);

                    jmcSelectedLines.FindFirst();
                    jmcInternalNotesPage.SetRecord(jmcSelectedLines);
                    jmcInternalNotesPage.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
