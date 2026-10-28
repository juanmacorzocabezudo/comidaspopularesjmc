pageextension 53101 "JMC Ficha Evento" extends "Ficha Evento"
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

    /*
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
