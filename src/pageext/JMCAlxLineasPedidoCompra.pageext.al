pageextension 53112 "JMC Alx Lineas Pedido Compra" extends AlxLineasPedidoCompra
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            Caption = 'Unit Cost with Discount', Comment = 'ESP="Coste unitario con descuento"';
        }
        addlast(Group)
        {
            field("JMC Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = All;
                Caption = 'Direct Unit Cost', Comment = 'ESP="Coste unitario directo"';
            }
            field("Line Discount %"; Rec."Line Discount %")
            {
                ApplicationArea = All;
                Caption = 'Discount %', Comment = 'ESP="% Descuento"';
            }
            field("JMC Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Business Line', Comment = 'ESP="Línea negocio"';
                Visible = true;
            }
            field("JMC Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
                Caption = 'Family', Comment = 'ESP="Familia"';
                Visible = true;
            }
            field("JMC Internal Notes"; Rec."JMC Internal Notes")
            {
                ApplicationArea = All;
                Caption = 'Internal Notes', Comment = 'ESP="Observaciones internas"';
            }
            field("JMC Received"; Rec."JMC Received")
            {
                ApplicationArea = All;
                Caption = 'Received', Comment = 'ESP="Recibido"';
            }
            field("JMC Recipe"; Rec."JMC Recipe")
            {
                ApplicationArea = All;
                Caption = 'Recipe (Free Text)', Comment = 'ESP="Receta (Texto libre)"';
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
            field("Último Coste Directo"; Rec."Último Coste Directo")
            {
                ApplicationArea = All;
                Caption = 'Last Direct Cost', Comment = 'ESP="Último Coste Directo"';
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
            action("JMC View Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'View Purchase Order', Comment = 'ESP="Ver pedido compra"';
                Image = Document;
                ToolTip = 'View and edit the purchase order related to the selected line.', Comment = 'ESP="Ver y editar el pedido de compra relacionado con la línea seleccionada."';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    jmcPurchaseHeader: Record "Purchase Header";
                    jmcPurchaseOrderPage: Page "Purchase Order";
                    jmcNoPurchaseOrderErr: Label 'No purchase order found for this line.', Comment = 'ESP="No se encontró pedido de compra para esta línea."';
                begin
                    if Rec."Document No." = '' then
                        Error(jmcNoPurchaseOrderErr);

                    if jmcPurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                        jmcPurchaseOrderPage.SetRecord(jmcPurchaseHeader);
                        jmcPurchaseOrderPage.Run();
                        CurrPage.Update(false);
                    end else
                        Error(jmcNoPurchaseOrderErr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Expected Receipt Date", '%1..%2', CalcDate('<-CY>', Today), CalcDate('<CY>', Today));
    end;
}
