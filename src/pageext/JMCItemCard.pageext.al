pageextension 53122 "JMC Item Card" extends "Item Card"
{
    layout
    {
        addafter(Formato)
        {
            field("JMC Weight"; Rec."JMC Weight")
            {
                ApplicationArea = All;
                Caption = 'Weight (Gr)', Comment = 'ESP="Peso (Gr)"';
                ToolTip = 'Specifies the weight of the item in grams.', Comment = 'ESP="Especifica el peso del producto en gramos."';
            }
        }
    }
}
