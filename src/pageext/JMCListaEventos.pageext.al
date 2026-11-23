pageextension 53104 "JMC Lista Eventos" extends "Lista de Eventos"
{
    layout
    {
        addafter(Descripcion)
        {
            field("JMC Customer Type"; Rec."JMC Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                ToolTip = 'Specifies the customer type.', Comment = 'ESP="Especifica el tipo de cliente."';
            }
        }
        addbefore("Total Adultos")
        {
            field("JMC Total People"; JMCTotalPeople)
            {
                ApplicationArea = All;
                Caption = 'Total People', Comment = 'ESP="Total personas"';
                ToolTip = 'Specifies the total number of adults and children attending the event.', Comment = 'ESP="Especifica el total de adultos y niños que asisten al evento."';

                trigger OnValidate()
                begin
                    Rec.Validate("Total Adultos", JMCTotalPeople - Rec."Total Ninos");
                    JMCTotalPeople := Rec."Total Adultos" + Rec."Total Ninos";
                end;
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

    var
        JMCTotalPeople: Integer;

    trigger OnAfterGetRecord()
    begin
        JMCTotalPeople := Rec."Total Adultos" + Rec."Total Ninos";
    end;
}