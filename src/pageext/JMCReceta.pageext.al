pageextension 53102 "JMC Receta" extends Receta
{
    /*layout
    {
        // Ocultar el part original de costos adicionales
        modify(BOMAdditionalCostPart)
        {
            Visible = false;
        }

        // Agregar el nuevo part con decimales a 3
        addafter(General)
        {
            part("JMC BOM Cost"; "JMC CP BOM Aditional Cost")
            {
                ApplicationArea = All;
                SubPageLink = "Item No" = FIELD("No."),
                              "BOM Version" = CONST(0);
            }
        }
    }

    actions
    {
        modify(BOMCost)
        {
            Visible = false;
        }

        addafter(sepa)
        {
            action("JMC BOMCost")
            {
                Caption = 'General Costs', Comment = 'ESP="Costes Generales"';
                ApplicationArea = All;
                Image = Costs;

                trigger OnAction()
                var
                    PageBOMAditionalCost: Page "JMC CP BOM Aditional Cost";
                    BOMAditionalCost: Record "BOM Aditional Cost";
                begin
                    if Rec.Receta_CosteLMFijado = 0 then begin
                        Rec.SetFijarCosteLMRecetaEnFichaArticulo();
                        Commit();
                    end;

                    BOMAditionalCost.Reset();
                    BOMAditionalCost.SetRange("Item No", Rec."No.");
                    BOMAditionalCost.SetRange("BOM Version", 0);
                    BOMAditionalCost.SetCurrentKey("Item No", "BOM Version", "No. Cost");
                    PageBOMAditionalCost.SetTableView(BOMAditionalCost);
                    PageBOMAditionalCost.RunModal();
                end;
            }
        }
    }*/
}
