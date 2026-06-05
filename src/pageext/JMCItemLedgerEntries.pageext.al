pageextension 53119 "JMC Item Ledger Entries" extends "Item Ledger Entries"
{
    actions
    {
        addlast(processing)
        {
            action("JMC View Related Item")
            {
                ApplicationArea = All;
                Caption = 'View Related Item', Comment = 'ESP="Ver producto relacionado"';
                Image = Item;
                ToolTip = 'Open the item card for the item in this entry, even if it is blocked.', Comment = 'ESP="Abrir la ficha del producto de este movimiento, incluso si está bloqueado."';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    jmcItem: Record Item;
                    jmcItemCard: Page "Item Card";
                    jmcNoItemErr: Label 'No source number specified for this entry.', Comment = 'ESP="No hay código de procedencia especificado para este movimiento."';
                    jmcItemNotFoundErr: Label 'Item %1 does not exist.', Comment = 'ESP="El producto %1 no existe."';
                begin
                    if Rec."Source No." = '' then
                        Error(jmcNoItemErr);

                    if not jmcItem.Get(Rec."Source No.") then
                        Error(jmcItemNotFoundErr, Rec."Source No.");

                    jmcItemCard.SetRecord(jmcItem);
                    jmcItemCard.Run();
                end;
            }
        }
    }
}
