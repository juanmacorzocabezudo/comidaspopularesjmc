pageextension 53122 "JMC Item Card" extends "Item Card"
{
    layout
    {
        addafter(Formato)
        {
            field("JMC Weight"; Rec."JMC Weight")
            {
                ApplicationArea = All;
                Caption = 'Weight (Kg)', Comment = 'ESP="Peso (Kg)"';
                ToolTip = 'Specifies the weight of the item in kilograms.', Comment = 'ESP="Especifica el peso del producto en kilogramos."';
            }
        }
    }
}
