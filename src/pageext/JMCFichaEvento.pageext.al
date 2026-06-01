pageextension 53101 "JMC Ficha Evento" extends "Ficha Evento"
{/*
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
