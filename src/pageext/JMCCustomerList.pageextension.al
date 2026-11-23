pageextension 53111 "JMC Customer List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("JMC Customer Type"; Rec."JMC Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                ToolTip = 'Specifies the customer type.', Comment = 'ESP="Especifica el tipo de cliente."';
            }
        }
    }
}
